BEGIN;

DROP TABLE IF EXISTS reservations;
DROP TABLE IF EXISTS loans;
DROP TABLE IF EXISTS book_genres;
DROP TABLE IF EXISTS books;
DROP TABLE IF EXISTS members;
DROP TABLE IF EXISTS genres;
DROP TABLE IF EXISTS authors;

DROP TYPE IF EXISTS reservation_status;

CREATE TYPE reservation_status AS ENUM ('pending', 'reserved', 'fulfilled', 'canceled');

CREATE TABLE authors (
  id          SERIAL       PRIMARY KEY,
  name        VARCHAR(150) NOT NULL,
  bio         TEXT,
  nationality VARCHAR(100),
  birth_year  INT CHECK (birth_year BETWEEN 1000 AND 2025)
);

CREATE TABLE members (
  id          SERIAL PRIMARY KEY,
  name        VARCHAR(150) NOT NULL,
  email       VARCHAR(255) NOT NULL UNIQUE,
  phone       VARCHAR(20)  NOT NULL,
  joined_date DATE         NOT NULL DEFAULT CURRENT_DATE,
  is_active   BOOLEAN      NOT NULL DEFAULT TRUE
);

CREATE TABLE books (
  id                 SERIAL PRIMARY KEY,
  author_id          INT          NOT NULL REFERENCES authors(id) ON DELETE RESTRICT,
  title              VARCHAR(255) NOT NULL,
  isbn               VARCHAR(20)  NOT NULL UNIQUE,
  quantity           INT          NOT NULL CHECK (quantity >= 0),
  available_quantity INT          NOT NULL CHECK (available_quantity >= 0),
  CONSTRAINT available_lte_total CHECK (available_quantity <= quantity)
);

CREATE TABLE genres (
  id              SERIAL       PRIMARY KEY,
  name            VARCHAR(100) NOT NULL,
  description     TEXT,
  parent_genre_id INT          REFERENCES genres(id) ON DELETE SET NULL,
  is_active       BOOLEAN      NOT NULL DEFAULT TRUE
);

CREATE TABLE book_genres (
  book_id          INT     NOT NULL REFERENCES books(id)  ON DELETE RESTRICT,
  genre_id         INT     NOT NULL REFERENCES genres(id) ON DELETE RESTRICT,
  added_date       DATE    NOT NULL DEFAULT CURRENT_DATE,
  added_by         INT     REFERENCES members(id)         ON DELETE SET NULL,
  is_primary_genre BOOLEAN NOT NULL DEFAULT FALSE,
  PRIMARY KEY (book_id, genre_id)
);

CREATE TABLE loans (
  id            SERIAL PRIMARY KEY,
  member_id     INT  NOT NULL REFERENCES members(id) ON DELETE RESTRICT,
  book_id       INT  NOT NULL REFERENCES books(id)   ON DELETE RESTRICT,
  checkout_date DATE NOT NULL DEFAULT CURRENT_DATE,
  due_date      DATE NOT NULL DEFAULT (CURRENT_DATE + INTERVAL '14 days'),
  returned_date DATE
);

CREATE TABLE reservations (
  id            SERIAL PRIMARY KEY,
  member_id     INT               NOT NULL REFERENCES members(id) ON DELETE RESTRICT,
  book_id       INT               NOT NULL REFERENCES books(id)   ON DELETE RESTRICT,
  reserved_date DATE              NOT NULL DEFAULT CURRENT_DATE,
  status        reservation_status NOT NULL DEFAULT 'pending'
);

COMMIT;
