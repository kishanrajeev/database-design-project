BEGIN;

CREATE OR REPLACE FUNCTION fn_loans_before_insert()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
DECLARE
  v_available INT;
  v_is_active BOOLEAN;
BEGIN
  -- Reject loans for inactive members
  SELECT is_active INTO v_is_active FROM members WHERE id = NEW.member_id;
  IF NOT v_is_active THEN
    RAISE EXCEPTION 'Member id=% is not active and cannot borrow books', NEW.member_id;
  END IF;

  -- Default checkout_date
  IF NEW.checkout_date IS NULL THEN
    NEW.checkout_date := CURRENT_DATE;
  END IF;

  -- Default due_date to checkout_date + 14 days
  IF NEW.due_date IS NULL THEN
    NEW.due_date := NEW.checkout_date + INTERVAL '14 days';
  END IF;

  -- Check availability (row lock prevents race conditions)
  SELECT available_quantity
    INTO v_available
    FROM books
   WHERE id = NEW.book_id
     FOR UPDATE;

  IF v_available <= 0 THEN
    RAISE EXCEPTION
      'Book id=% is not available for loan (available_quantity = 0)', NEW.book_id;
  END IF;

  -- Decrement available_quantity
  UPDATE books
     SET available_quantity = available_quantity - 1
   WHERE id = NEW.book_id;

  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_loans_before_insert ON loans;
CREATE TRIGGER trg_loans_before_insert
  BEFORE INSERT ON loans
  FOR EACH ROW
  EXECUTE FUNCTION fn_loans_before_insert();


CREATE OR REPLACE FUNCTION fn_loans_after_update()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
DECLARE
  v_next_reservation_id INT;
BEGIN
  -- Only act when returned_date transitions NULL → a real date
  IF OLD.returned_date IS NULL AND NEW.returned_date IS NOT NULL THEN

    -- Find the oldest pending reservation first (before touching available_quantity)
    SELECT id
      INTO v_next_reservation_id
      FROM reservations
     WHERE book_id = NEW.book_id
       AND status  = 'pending'
     ORDER BY reserved_date ASC, id ASC
     LIMIT 1
       FOR UPDATE;  -- wait for lock; SKIP LOCKED would silently skip a patron

    IF v_next_reservation_id IS NOT NULL THEN
      -- Promote reservation but do NOT increment available_quantity:
      -- the returned copy is immediately held for the reservation holder.
      UPDATE reservations
         SET status = 'reserved'
       WHERE id = v_next_reservation_id;
    ELSE
      -- No one is waiting — the copy becomes freely available again.
      UPDATE books
         SET available_quantity = available_quantity + 1
       WHERE id = NEW.book_id;
    END IF;

  END IF;

  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_loans_after_update ON loans;
CREATE TRIGGER trg_loans_after_update
  AFTER UPDATE ON loans
  FOR EACH ROW
  EXECUTE FUNCTION fn_loans_after_update();


CREATE OR REPLACE FUNCTION fn_reservations_before_insert()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
DECLARE
  v_existing_id INT;
BEGIN
  SELECT id
    INTO v_existing_id
    FROM reservations
   WHERE member_id = NEW.member_id
     AND book_id   = NEW.book_id
     AND status    IN ('pending', 'reserved')
   LIMIT 1;

  IF v_existing_id IS NOT NULL THEN
    RAISE EXCEPTION
      'Member id=% already has an active reservation (id=%) for book id=%',
      NEW.member_id, v_existing_id, NEW.book_id;
  END IF;

  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_reservations_before_insert ON reservations;
CREATE TRIGGER trg_reservations_before_insert
  BEFORE INSERT ON reservations
  FOR EACH ROW
  EXECUTE FUNCTION fn_reservations_before_insert();


COMMIT;