

CREATE OR REPLACE FUNCTION test_log(msg TEXT)
RETURNS VOID LANGUAGE plpgsql AS $$
BEGIN
  RAISE NOTICE '%', msg;
END;
$$;


SELECT setval('public.authors_id_seq',       COALESCE((SELECT MAX(id) FROM public.authors), 1),       false);
SELECT setval('public.members_id_seq',        COALESCE((SELECT MAX(id) FROM public.members), 1),       false);
SELECT setval('public.books_id_seq',          COALESCE((SELECT MAX(id) FROM public.books), 1),         false);
SELECT setval('public.genres_id_seq',         COALESCE((SELECT MAX(id) FROM public.genres), 1),        false);
SELECT setval('public.loans_id_seq',          COALESCE((SELECT MAX(id) FROM public.loans), 1),         false);
SELECT setval('public.reservations_id_seq',   COALESCE((SELECT MAX(id) FROM public.reservations), 1),  false);
SELECT test_log('=== SEEDING DATA ===');

INSERT INTO authors (name, bio, nationality, birth_year) VALUES
  ('George Orwell',     'English novelist, essayist and critic.', 'British',  1903),
  ('Frank Herbert',     'American science fiction author.',        'American', 1920),
  ('Ursula K. Le Guin', 'American author of speculative fiction.', 'American', 1929);

INSERT INTO members (name, email, phone, joined_date, is_active) VALUES
  ('Alice Johnson', 'alice@example.com', '555-0101', '2023-01-15', TRUE),
  ('Bob Smith',     'bob@example.com',   '555-0102', '2023-03-22', TRUE),
  ('Carol White',   'carol@example.com', '555-0103', '2024-06-01', TRUE),
  ('Dave Inactive', 'dave@example.com',  '555-0104', '2022-11-10', FALSE);

INSERT INTO genres (name, description, parent_genre_id, is_active) VALUES
  ('Dystopian',       'Fiction set in an oppressive imagined future.', NULL, TRUE),
  ('Science Fiction', 'Fiction based on imagined future science.',     NULL, TRUE),
  ('Fantasy',         'Fiction involving magical or supernatural elements.', NULL, TRUE);

INSERT INTO books (author_id, title, isbn, quantity, available_quantity) VALUES
  (1, 'Nineteen Eighty-Four',      '978-0451524935', 2, 2),   
  (1, 'Animal Farm',               '978-0451526342', 3, 3),   
  (2, 'Dune',                      '978-0441013593', 1, 1),  
  (3, 'The Left Hand of Darkness', '978-0441478125', 2, 2);   

INSERT INTO book_genres (book_id, genre_id, is_primary_genre) VALUES
  (1, 1, TRUE),  (1, 2, FALSE),
  (2, 1, TRUE),
  (3, 2, TRUE),
  (4, 2, TRUE),  (4, 3, FALSE);



SELECT * FROM books;

CREATE OR REPLACE PROCEDURE run_trigger_tests()
LANGUAGE plpgsql
AS $$
BEGIN

  PERFORM test_log('');
  PERFORM test_log('=== TRIGGER TESTS ===');


  PERFORM test_log('');
  PERFORM test_log('[T1] Loan Dune to Alice – should succeed');

  INSERT INTO loans (member_id, book_id) VALUES (1, 3);

  IF (SELECT available_quantity FROM books WHERE id = 3) = 0 THEN
    PERFORM test_log('  PASS: available_quantity decremented to 0');
  ELSE
    PERFORM test_log('  FAIL: available_quantity not decremented');
  END IF;

  IF (SELECT due_date - checkout_date FROM loans ORDER BY id DESC LIMIT 1) = 14 THEN
    PERFORM test_log('  PASS: due_date is exactly 14 days after checkout_date');
  ELSE
    PERFORM test_log('  FAIL: due_date interval incorrect');
  END IF;


  PERFORM test_log('');
  PERFORM test_log('[T2] Loan Dune to Bob while qty=0 – should raise exception');

  BEGIN
    INSERT INTO loans (member_id, book_id) VALUES (2, 3);
    PERFORM test_log('  FAIL: insert succeeded but should have raised exception');
  EXCEPTION WHEN others THEN
    PERFORM test_log('  PASS: exception caught: ' || SQLERRM);
  END;


  PERFORM test_log('');
  PERFORM test_log('[T3] Return Dune – available_quantity should become 1');

  UPDATE loans
     SET returned_date = CURRENT_DATE
   WHERE book_id = 3
     AND returned_date IS NULL;

  IF (SELECT available_quantity FROM books WHERE id = 3) = 1 THEN
    PERFORM test_log('  PASS: available_quantity restored to 1');
  ELSE
    PERFORM test_log('  FAIL: available_quantity not restored');
  END IF;


  PERFORM test_log('');
  PERFORM test_log('[T4] Reservation auto-promote on book return');

  INSERT INTO loans (member_id, book_id) VALUES (1, 3);
  INSERT INTO reservations (member_id, book_id) VALUES (2, 3);

  PERFORM test_log('  Bob reservation status before return: ' ||
    (SELECT status::TEXT FROM reservations WHERE member_id = 2 AND book_id = 3 ORDER BY id DESC LIMIT 1));

  UPDATE loans
     SET returned_date = CURRENT_DATE
   WHERE book_id = 3
     AND member_id = 1
     AND returned_date IS NULL;

  IF (SELECT status FROM reservations WHERE member_id = 2 AND book_id = 3 ORDER BY id DESC LIMIT 1) = 'reserved' THEN
    PERFORM test_log('  PASS: Bob''s reservation promoted to ''reserved''');
  ELSE
    PERFORM test_log('  FAIL: reservation status not updated');
  END IF;

  IF (SELECT available_quantity FROM books WHERE id = 3) = 0 THEN
    PERFORM test_log('  PASS: available_quantity held at 0 (copy reserved for Bob)');
  ELSE
    PERFORM test_log('  FAIL: available_quantity incorrectly incremented');
  END IF;


  PERFORM test_log('');
  PERFORM test_log('[T5] Duplicate reservation – should raise exception');

  BEGIN
    INSERT INTO reservations (member_id, book_id) VALUES (2, 3);
    PERFORM test_log('  FAIL: duplicate reservation was allowed');
  EXCEPTION WHEN others THEN
    PERFORM test_log('  PASS: exception caught: ' || SQLERRM);
  END;


  PERFORM test_log('');
  PERFORM test_log('[T6] Two loans against a 2-copy book – both should succeed');

  INSERT INTO loans (member_id, book_id) VALUES (1, 1);
  INSERT INTO loans (member_id, book_id) VALUES (2, 1);

  IF (SELECT available_quantity FROM books WHERE id = 1) = 0 THEN
    PERFORM test_log('  PASS: both copies checked out, available_quantity = 0');
  ELSE
    PERFORM test_log('  FAIL: unexpected available_quantity');
  END IF;

  BEGIN
    INSERT INTO loans (member_id, book_id) VALUES (3, 1);
    PERFORM test_log('  FAIL: third loan on 0-qty book was allowed');
  EXCEPTION WHEN others THEN
    PERFORM test_log('  PASS: third loan blocked: ' || SQLERRM);
  END;


  PERFORM test_log('');
  PERFORM test_log('[T7] Explicit checkout_date and due_date are preserved');

  INSERT INTO loans (member_id, book_id, checkout_date, due_date)
    VALUES (3, 2, '2025-01-01', '2025-02-01');

  IF EXISTS (
    SELECT 1 FROM loans
     WHERE book_id       = 2
       AND member_id     = 3
       AND checkout_date = '2025-01-01'
       AND due_date      = '2025-02-01'
  ) THEN
    PERFORM test_log('  PASS: explicit dates preserved correctly');
  ELSE
    PERFORM test_log('  FAIL: explicit dates were overwritten');
  END IF;


  PERFORM test_log('');
  PERFORM test_log('[T8] Re-reservation allowed after cancellation');

  INSERT INTO reservations (member_id, book_id) VALUES (1, 2);
  UPDATE reservations SET status = 'canceled'
   WHERE member_id = 1 AND book_id = 2 AND status = 'pending';

  BEGIN
    INSERT INTO reservations (member_id, book_id) VALUES (1, 2);
    PERFORM test_log('  PASS: re-reservation after cancellation allowed');
  EXCEPTION WHEN others THEN
    PERFORM test_log('  FAIL: re-reservation incorrectly blocked: ' || SQLERRM);
  END;


  PERFORM test_log('');
  PERFORM test_log('[T9] Loan by inactive member – should raise exception');

  BEGIN
    INSERT INTO loans (member_id, book_id) VALUES (4, 2);
    PERFORM test_log('  FAIL: loan by inactive member was allowed');
  EXCEPTION WHEN others THEN
    PERFORM test_log('  PASS: exception caught: ' || SQLERRM);
  END;


  PERFORM test_log('');
  PERFORM test_log('=== TRIGGER TESTS COMPLETE ===');

END;
$$;

CALL run_trigger_tests();


SELECT
  b.id                                      AS book_id,
  b.title,
  a.name                                    AS author,
  b.quantity,
  b.available_quantity,
  STRING_AGG(g.name, ', ' ORDER BY g.name)  AS genres
FROM books b
JOIN authors      a  ON a.id = b.author_id
LEFT JOIN book_genres bg ON bg.book_id = b.id
LEFT JOIN genres      g  ON g.id = bg.genre_id
GROUP BY b.id, b.title, a.name, b.quantity, b.available_quantity
ORDER BY b.id;

SELECT
  l.id                                          AS loan_id,
  m.name                                        AS member,
  b.title                                       AS book,
  a.name                                        AS author,
  l.checkout_date,
  l.due_date,
  l.due_date - CURRENT_DATE                     AS days_remaining,
  CASE
    WHEN l.due_date < CURRENT_DATE THEN 'OVERDUE'
    WHEN l.due_date = CURRENT_DATE THEN 'DUE TODAY'
    ELSE 'OK'
  END                                           AS status
FROM loans l
JOIN members m ON m.id = l.member_id
JOIN books   b ON b.id = l.book_id
JOIN authors a ON a.id = b.author_id
WHERE l.returned_date IS NULL
ORDER BY l.due_date;

SELECT
  r.id                AS reservation_id,
  m.name              AS member,
  b.title             AS book,
  a.name              AS author,
  r.reserved_date,
  r.status
FROM reservations r
JOIN members m ON m.id = r.member_id
JOIN books   b ON b.id = r.book_id
JOIN authors a ON a.id = b.author_id
ORDER BY r.book_id, r.reserved_date;

SELECT
  m.name              AS member,
  b.title             AS book,
  l.checkout_date,
  l.due_date,
  l.returned_date,
  CASE
    WHEN l.returned_date IS NULL AND l.due_date < CURRENT_DATE THEN 'overdue'
    WHEN l.returned_date IS NULL                               THEN 'active'
    WHEN l.returned_date > l.due_date                         THEN 'returned late'
    ELSE                                                           'returned on time'
  END                 AS loan_status
FROM loans l
JOIN members m ON m.id = l.member_id
JOIN books   b ON b.id = l.book_id
ORDER BY m.name, l.checkout_date;

SELECT
  b.title,
  b.available_quantity,
  COUNT(r.id)                                         AS pending_reservations,
  STRING_AGG(m.name, ' → ' ORDER BY r.reserved_date) AS reservation_queue
FROM books b
LEFT JOIN reservations r ON r.book_id = b.id AND r.status = 'pending'
LEFT JOIN members      m ON m.id = r.member_id
WHERE b.available_quantity = 0
GROUP BY b.id, b.title, b.available_quantity
ORDER BY b.title;

SELECT
  m.name              AS member,
  m.email,
  b.title             AS book,
  l.due_date,
  CURRENT_DATE - l.due_date AS days_overdue
FROM loans l
JOIN members m ON m.id = l.member_id
JOIN books   b ON b.id = l.book_id
WHERE l.returned_date IS NULL
  AND l.due_date < CURRENT_DATE
ORDER BY days_overdue DESC;

SELECT
  m.id,
  m.name,
  m.is_active,
  COUNT(DISTINCT l.id)                                          AS total_loans,
  COUNT(DISTINCT l.id) FILTER (WHERE l.returned_date IS NULL)  AS active_loans,
  COUNT(DISTINCT r.id)                                         AS total_reservations,
  COUNT(DISTINCT r.id) FILTER (WHERE r.status = 'pending')    AS pending_reservations
FROM members m
LEFT JOIN loans        l ON l.member_id = m.id
LEFT JOIN reservations r ON r.member_id = m.id
GROUP BY m.id, m.name, m.is_active
ORDER BY m.id;

SELECT
  b.id,
  b.title,
  b.quantity                                         AS total_copies,
  b.available_quantity,
  b.quantity - b.available_quantity                  AS copies_on_loan,
  COUNT(DISTINCT l.id) FILTER (WHERE l.returned_date IS NULL) AS open_loan_count,
  COUNT(DISTINCT r.id) FILTER (WHERE r.status IN ('pending', 'reserved')) AS reserved_count,
  CASE
    WHEN b.available_quantity < 0                    THEN 'NEGATIVE – data error'
    WHEN b.available_quantity > b.quantity           THEN 'EXCEEDS TOTAL – data error'
    WHEN b.quantity - b.available_quantity <>
         COUNT(DISTINCT l.id) FILTER (WHERE l.returned_date IS NULL) +
         COUNT(DISTINCT r.id) FILTER (WHERE r.status IN ('pending', 'reserved'))
                                                     THEN 'MISMATCH with open loans'
    ELSE                                                  'OK'
  END                                                AS health
FROM books b
LEFT JOIN loans l ON l.book_id = b.id
LEFT JOIN reservations r ON r.book_id = b.id
GROUP BY b.id, b.title, b.quantity, b.available_quantity
ORDER BY b.id;

DO $$
BEGIN
  IF current_setting('app.do_cleanup', true) = 'true' THEN
    DELETE FROM reservations;
    DELETE FROM loans;
    DELETE FROM book_genres;
    DELETE FROM books;
    DELETE FROM genres;
    DELETE FROM members;
    DELETE FROM authors;
    ALTER SEQUENCE public.authors_id_seq      RESTART WITH 1;
    ALTER SEQUENCE public.members_id_seq      RESTART WITH 1;
    ALTER SEQUENCE public.books_id_seq        RESTART WITH 1;
    ALTER SEQUENCE public.genres_id_seq       RESTART WITH 1;
    ALTER SEQUENCE public.loans_id_seq        RESTART WITH 1;
    ALTER SEQUENCE public.reservations_id_seq RESTART WITH 1;
    RAISE NOTICE 'Cleanup complete.';
  ELSE
    RAISE NOTICE 'Cleanup skipped. Run SET app.do_cleanup = true; before this block to enable.';
  END IF;
END;
$$;
