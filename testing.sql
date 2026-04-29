CREATE OR REPLACE FUNCTION test_log(msg TEXT)
RETURNS VOID LANGUAGE plpgsql AS $$
BEGIN
  RAISE NOTICE '%', msg;
END;
$$;


SELECT setval('public.authors_id_seq',       1, false);
SELECT setval('public.members_id_seq',        1, false);
SELECT setval('public.books_id_seq',          1, false);
SELECT setval('public.genres_id_seq',         1, false);
SELECT setval('public.loans_id_seq',          1, false);
SELECT setval('public.reservations_id_seq',   1, false);


INSERT INTO authors (name, bio, nationality, birth_year) VALUES
  ('George Orwell',          'English novelist and critic.',                        'British',     1903),
  ('Frank Herbert',          'American science fiction author.',                    'American',    1920),
  ('Ursula K. Le Guin',      'American author of speculative fiction.',             'American',    1929),
  ('J.R.R. Tolkien',         'English author and philologist.',                     'British',     1892),
  ('Isaac Asimov',           'American author and professor of biochemistry.',      'American',    1920),
  ('Aldous Huxley',          'English writer and philosopher.',                     'British',     1894),
  ('Ray Bradbury',           'American author and screenwriter.',                   'American',    1920),
  ('Philip K. Dick',         'American science fiction writer.',                    'American',    1928),
  ('Arthur C. Clarke',       'British science fiction writer.',                     'British',     1917),
  ('Margaret Atwood',        'Canadian poet and novelist.',                         'Canadian',    1939),
  ('Cormac McCarthy',        'American novelist and playwright.',                   'American',    1933),
  ('Toni Morrison',          'American novelist and professor.',                    'American',    1931),
  ('Gabriel Garcia Marquez', 'Colombian novelist and Nobel laureate.',              'Colombian',   1927),
  ('Haruki Murakami',        'Japanese writer and translator.',                     'Japanese',    1949),
  ('Fyodor Dostoevsky',      'Russian novelist and philosopher.',                   'Russian',     1821),
  ('Leo Tolstoy',            'Russian writer regarded as one of the greatest.',     'Russian',     1828),
  ('Virginia Woolf',         'English writer and modernist.',                       'British',     1882),
  ('Ernest Hemingway',       'American novelist and Nobel laureate.',               'American',    1899),
  ('Franz Kafka',            'German-speaking Bohemian novelist.',                  'Czech',       1883),
  ('James Joyce',            'Irish novelist and poet.',                            'Irish',       1882),
  ('William Gibson',         'American-Canadian speculative fiction writer.',       'American',    1948),
  ('Neal Stephenson',        'American writer known for speculative fiction.',      'American',    1959),
  ('China Miéville',         'English author of weird fiction.',                    'British',     1972),
  ('N.K. Jemisin',           'American fantasy writer.',                            'American',    1972),
  ('Terry Pratchett',        'English author of comic fantasy.',                    'British',     1948),
  ('Douglas Adams',          'English author and humorist.',                        'British',     1952),
  ('Neil Gaiman',            'English author of short fiction and novels.',         'British',     1960),
  ('Octavia Butler',         'American science fiction author.',                    'American',    1947),
  ('Samuel R. Delany',       'American author and literary critic.',                'American',    1942),
  ('Kim Stanley Robinson',   'American science fiction writer.',                    'American',    1952),
  ('Dan Simmons',            'American science fiction and horror author.',         'American',    1948),
  ('Iain M. Banks',          'Scottish author known for the Culture series.',       'Scottish',    1954),
  ('Peter F. Hamilton',      'British science fiction author.',                     'British',     1960),
  ('Alastair Reynolds',      'British author of hard science fiction.',             'British',     1966),
  ('Greg Bear',              'American science fiction author.',                    'American',    1951),
  ('Greg Egan',              'Australian hard science fiction author.',             'Australian',  1961),
  ('Ted Chiang',             'American science fiction writer.',                    'American',    1967),
  ('Ken Liu',                'American author and translator.',                     'American',    1976),
  ('Liu Cixin',              'Chinese science fiction author.',                     'Chinese',     1963),
  ('Stanislaw Lem',          'Polish writer of science fiction and philosophy.',    'Polish',      1921),
  ('Jorge Luis Borges',      'Argentine short-story writer and essayist.',          'Argentine',   1899),
  ('Italo Calvino',          'Italian journalist and writer.',                      'Italian',     1923),
  ('Umberto Eco',            'Italian novelist and philosopher.',                   'Italian',     1932),
  ('Milan Kundera',          'Czech-French novelist.',                              'Czech',       1929),
  ('Salman Rushdie',         'British-Indian novelist.',                            'British',     1947),
  ('Kazuo Ishiguro',         'British novelist and Nobel laureate.',                'British',     1954),
  ('Colson Whitehead',       'American author and journalist.',                     'American',    1969),
  ('Andy Weir',              'American author known for hard science fiction.',     'American',    1972),
  ('Pierce Brown',           'American author of the Red Rising series.',           'American',    1988),
  ('Brandon Sanderson',      'American author of epic fantasy.',                    'American',    1975);



INSERT INTO members (name, email, phone, joined_date, is_active) VALUES
  ('Alice Johnson',    'alice@example.com',    '555-0101', '2023-01-15', TRUE),
  ('Bob Smith',        'bob@example.com',      '555-0102', '2023-03-22', TRUE),
  ('Carol White',      'carol@example.com',    '555-0103', '2024-06-01', TRUE),
  ('Dave Inactive',    'dave@example.com',     '555-0104', '2022-11-10', FALSE),
  ('Eva Green',        'eva@example.com',      '555-0105', '2023-07-19', TRUE),
  ('Frank Moore',      'frank@example.com',    '555-0106', '2023-08-05', TRUE),
  ('Grace Lee',        'grace@example.com',    '555-0107', '2024-01-11', TRUE),
  ('Henry Taylor',     'henry@example.com',    '555-0108', '2022-05-30', TRUE),
  ('Isla Brown',       'isla@example.com',     '555-0109', '2023-09-14', TRUE),
  ('Jack Wilson',      'jack@example.com',     '555-0110', '2024-02-28', TRUE),
  ('Karen Davis',      'karen@example.com',    '555-0111', '2023-04-17', TRUE),
  ('Liam Martinez',    'liam@example.com',     '555-0112', '2022-12-01', TRUE),
  ('Mia Anderson',     'mia@example.com',      '555-0113', '2024-03-09', TRUE),
  ('Noah Thomas',      'noah@example.com',     '555-0114', '2023-06-22', TRUE),
  ('Olivia Jackson',   'olivia@example.com',   '555-0115', '2022-08-15', TRUE),
  ('Paul Harris',      'paul@example.com',     '555-0116', '2023-11-03', TRUE),
  ('Quinn Martin',     'quinn@example.com',    '555-0117', '2024-04-18', TRUE),
  ('Rachel Garcia',    'rachel@example.com',   '555-0118', '2023-02-27', TRUE),
  ('Sam Robinson',     'sam@example.com',      '555-0119', '2022-07-06', FALSE),
  ('Tara Clark',       'tara@example.com',     '555-0120', '2023-10-31', TRUE),
  ('Uma Rodriguez',    'uma@example.com',      '555-0121', '2024-05-12', TRUE),
  ('Victor Lewis',     'victor@example.com',   '555-0122', '2023-01-29', TRUE),
  ('Wendy Lee',        'wendy@example.com',    '555-0123', '2022-09-18', TRUE),
  ('Xander Walker',    'xander@example.com',   '555-0124', '2023-12-07', TRUE),
  ('Yara Hall',        'yara@example.com',     '555-0125', '2024-06-25', TRUE),
  ('Zoe Allen',        'zoe@example.com',      '555-0126', '2023-03-14', TRUE),
  ('Aaron Young',      'aaron@example.com',    '555-0127', '2022-10-22', TRUE),
  ('Bella Hernandez',  'bella@example.com',    '555-0128', '2023-07-08', TRUE),
  ('Carlos King',      'carlos@example.com',   '555-0129', '2024-01-30', TRUE),
  ('Diana Wright',     'diana@example.com',    '555-0130', '2023-05-19', TRUE),
  ('Ethan Lopez',      'ethan@example.com',    '555-0131', '2022-06-11', TRUE),
  ('Fiona Hill',       'fiona@example.com',    '555-0132', '2023-08-24', TRUE),
  ('George Scott',     'george@example.com',   '555-0133', '2024-02-05', TRUE),
  ('Hannah Green',     'hannah@example.com',   '555-0134', '2023-04-01', TRUE),
  ('Ian Adams',        'ian@example.com',      '555-0135', '2022-11-28', FALSE),
  ('Julia Baker',      'julia@example.com',    '555-0136', '2023-09-16', TRUE),
  ('Kevin Nelson',     'kevin@example.com',    '555-0137', '2024-03-22', TRUE),
  ('Laura Carter',     'laura@example.com',    '555-0138', '2023-01-07', TRUE),
  ('Mike Mitchell',    'mike@example.com',     '555-0139', '2022-07-19', TRUE),
  ('Nancy Perez',      'nancy@example.com',    '555-0140', '2023-11-14', TRUE),
  ('Oscar Roberts',    'oscar@example.com',    '555-0141', '2024-04-03', TRUE),
  ('Penny Turner',     'penny@example.com',    '555-0142', '2023-06-30', TRUE),
  ('Ray Phillips',     'ray@example.com',      '555-0143', '2022-08-07', TRUE),
  ('Sara Campbell',    'sara@example.com',     '555-0144', '2023-02-13', TRUE),
  ('Tom Parker',       'tom@example.com',      '555-0145', '2024-05-27', TRUE),
  ('Ulla Evans',       'ulla@example.com',     '555-0146', '2023-10-09', TRUE),
  ('Wade Edwards',     'wade@example.com',     '555-0147', '2022-12-16', TRUE),
  ('Xena Collins',     'xena@example.com',     '555-0148', '2023-07-25', TRUE),
  ('York Stewart',     'york@example.com',     '555-0149', '2024-01-14', TRUE),
  ('Zara Sanchez',     'zara@example.com',     '555-0150', '2023-03-31', TRUE);


INSERT INTO genres (name, description, parent_genre_id, is_active) VALUES
  ('Science Fiction', 'Fiction based on imagined future science and technology.',   NULL, TRUE), 
  ('Fantasy',         'Fiction involving magical or supernatural elements.',         NULL, TRUE), 
  ('Horror',          'Fiction intended to frighten or disturb.',                   NULL, TRUE),  
  ('Literary Fiction','Character-driven works with artistic intent.',               NULL, TRUE), 
  ('Mystery',         'Fiction dealing with puzzling crimes or events.',            NULL, TRUE),  
  ('Dystopian',       'Fiction set in an oppressive imagined future.',              1,    TRUE), 
  ('Cyberpunk',       'High-tech low-life science fiction subgenre.',               1,    TRUE), 
  ('Epic Fantasy',    'Large-scale fantasy with world-building.',                   2,    TRUE), 
  ('Magical Realism', 'Realistic fiction with magical elements.',                   2,    TRUE), 
  ('Thriller',        'Fiction designed to hold interest through suspense.',        5,    TRUE); 


INSERT INTO books (author_id, title, isbn, quantity, available_quantity) VALUES
  (1,  'Nineteen Eighty-Four',         '978-0451524935', 3, 3),
  (1,  'Animal Farm',                  '978-0451526342', 3, 3),
  (2,  'Dune',                         '978-0441013593', 2, 2),
  (2,  'Dune Messiah',                 '978-0441172696', 2, 2),
  (3,  'The Left Hand of Darkness',    '978-0441478125', 2, 2),
  (3,  'The Dispossessed',             '978-0061054815', 2, 2),
  (4,  'The Hobbit',                   '978-0547928227', 4, 4),
  (4,  'The Fellowship of the Ring',   '978-0547928210', 3, 3),
  (5,  'Foundation',                   '978-0553293357', 3, 3),
  (5,  'I Robot',                      '978-0553294385', 2, 2),
  (6,  'Brave New World',              '978-0060850524', 3, 3),
  (7,  'Fahrenheit 451',               '978-1451673319', 3, 3),
  (8,  'Do Androids Dream',            '978-0345404473', 2, 2),
  (8,  'The Man in the High Castle',   '978-0547572482', 2, 2),
  (9,  '2001 A Space Odyssey',         '978-0451457998', 2, 2),
  (10, 'The Handmaids Tale',           '978-0385490818', 3, 3),
  (10, 'Oryx and Crake',               '978-0385721677', 2, 2),
  (11, 'The Road',                     '978-0307387899', 2, 2),
  (12, 'Beloved',                      '978-1400033416', 2, 2),
  (13, 'One Hundred Years of Solitude','978-0060883287', 3, 3),
  (14, 'Norwegian Wood',               '978-0375704024', 2, 2),
  (14, 'Kafka on the Shore',           '978-1400079278', 2, 2),
  (15, 'Crime and Punishment',         '978-0143107637', 2, 2),
  (15, 'The Brothers Karamazov',       '978-0374528379', 2, 2),
  (16, 'War and Peace',                '978-1400079988', 2, 2),
  (17, 'Mrs Dalloway',                 '978-0156628709', 2, 2),
  (18, 'The Old Man and the Sea',      '978-0684801223', 3, 3),
  (19, 'The Trial',                    '978-0805209990', 2, 2),
  (20, 'Ulysses',                      '978-0394743127', 1, 1),
  (21, 'Neuromancer',                  '978-0441569595', 2, 2),
  (22, 'Snow Crash',                   '978-0553380958', 2, 2),
  (23, 'Perdido Street Station',       '978-0345459404', 2, 2),
  (24, 'The Fifth Season',             '978-0316229296', 2, 2),
  (25, 'The Colour of Magic',          '978-0062225672', 3, 3),
  (26, 'The Hitchhikers Guide',        '978-0345391803', 4, 4),
  (27, 'American Gods',                '978-0060558123', 2, 2),
  (28, 'Kindred',                      '978-0807083697', 2, 2),
  (29, 'Dhalgren',                     '978-0375706684', 1, 1),
  (30, 'The Martian Chronicles',       '978-1451678191', 2, 2), 
  (31, 'Hyperion',                     '978-0553283686', 2, 2),
  (32, 'The Player of Games',          '978-0061090141', 2, 2),
  (33, 'The Reality Dysfunction',      '978-0330340328', 1, 1),
  (34, 'Revelation Space',             '978-0441009428', 2, 2),
  (35, 'Blood Music',                  '978-0759240360', 2, 2),
  (36, 'Diaspora',                     '978-1857988215', 1, 1),
  (37, 'Stories of Your Life',         '978-1101972120', 3, 3),
  (38, 'The Paper Menagerie',          '978-1481424363', 3, 3),
  (39, 'The Three-Body Problem',       '978-0765382030', 3, 3),
  (40, 'Solaris',                      '978-0156837installé', 2, 2),
  (41, 'Ficciones',                    '978-0802130303', 2, 2);

UPDATE books SET isbn = '978-0156837028' WHERE title = 'Solaris';



INSERT INTO book_genres (book_id, genre_id, is_primary_genre) VALUES
  (1,  6,  TRUE),  
  (1,  1,  FALSE),  
  (2,  6,  TRUE),   
  (3,  1,  TRUE),   
  (3,  8,  FALSE),  
  (4,  1,  TRUE),   
  (5,  1,  TRUE),   
  (5,  9,  FALSE),  
  (6,  1,  TRUE),   
  (7,  8,  TRUE),   
  (8,  8,  TRUE),   
  (9,  1,  TRUE),   
  (10, 1,  TRUE),   
  (11, 6,  TRUE),   
  (11, 1,  FALSE), 
  (12, 6,  TRUE),  
  (13, 1,  TRUE),  
  (14, 1,  TRUE),  
  (15, 1,  TRUE),  
  (16, 6,  TRUE),   
  (16, 1,  FALSE),  
  (17, 1,  TRUE),   
  (18, 6,  TRUE),   
  (18, 4,  FALSE),  
  (19, 4,  TRUE),   
  (20, 9,  TRUE),   
  (21, 4,  TRUE),  
  (22, 9,  TRUE),   
  (23, 4,  TRUE),   
  (24, 4,  TRUE),   
  (25, 4,  TRUE),   
  (26, 4,  TRUE),   
  (27, 4,  TRUE),   
  (28, 4,  TRUE),  
  (29, 4,  TRUE),  
  (30, 7,  TRUE),   
  (30, 1,  FALSE), 
  (31, 7,  TRUE),  
  (32, 1,  TRUE), 
  (32, 2,  FALSE), 
  (33, 1,  TRUE),  
  (33, 8,  FALSE),  
  (34, 2,  TRUE),   
  (35, 1,  TRUE),   
  (35, 2,  FALSE),  
  (36, 9,  TRUE),   
  (36, 2,  FALSE),  
  (37, 1,  TRUE),   
  (38, 1,  TRUE),   
  (39, 1,  TRUE),   
  (40, 1,  TRUE),   
  (41, 1,  TRUE),   
  (42, 1,  TRUE),   
  (43, 1,  TRUE),   
  (44, 1,  TRUE),   
  (45, 1,  TRUE),  
  (46, 1,  TRUE),   
  (47, 1,  TRUE),  
  (48, 1,  TRUE),   
  (49, 1,  TRUE),   
  (50, 4,  TRUE);   


INSERT INTO loans (member_id, book_id, checkout_date, due_date, returned_date) VALUES
  (1,  1,  '2024-01-05', '2024-01-19', '2024-01-18'),
  (2,  3,  '2024-01-10', '2024-01-24', '2024-01-23'),
  (3,  7,  '2024-02-01', '2024-02-15', '2024-02-14'),
  (5,  9,  '2024-02-10', '2024-02-24', '2024-02-20'),
  (6,  11, '2024-02-15', '2024-03-01', '2024-02-28'),
  (7,  12, '2024-03-01', '2024-03-15', '2024-03-10'),
  (8,  16, '2024-03-05', '2024-03-19', '2024-03-18'),
  (9,  20, '2024-03-12', '2024-03-26', '2024-03-25'),
  (10, 23, '2024-04-01', '2024-04-15', '2024-04-13'),
  (11, 26, '2024-04-05', '2024-04-19', '2024-04-17'),
  (12, 30, '2024-04-10', '2024-04-24', '2024-04-22'),
  (13, 35, '2024-05-01', '2024-05-15', '2024-05-14'),
  (14, 37, '2024-05-06', '2024-05-20', '2024-05-19'),
  (15, 39, '2024-05-10', '2024-05-24', '2024-05-23'),
  (16, 46, '2024-05-15', '2024-05-29', '2024-05-28'),
  (17, 48, '2024-06-01', '2024-06-15', '2024-06-14'),
  (18, 2,  '2024-06-05', '2024-06-19', '2024-06-18'),
  (20, 4,  '2024-06-10', '2024-06-24', '2024-06-20'),
  (21, 6,  '2024-06-15', '2024-06-29', '2024-06-28'),
  (22, 8,  '2024-07-01', '2024-07-15', '2024-07-13'),
  (23, 10, '2024-07-05', '2024-07-19', '2024-07-16'),
  (24, 13, '2024-07-10', '2024-07-24', '2024-07-22'),
  (25, 15, '2024-07-15', '2024-07-29', '2024-07-28'),
  (26, 17, '2024-08-01', '2024-08-15', '2024-08-12'),
  (27, 19, '2024-08-05', '2024-08-19', '2024-08-17'),
  (28, 21, '2024-08-10', '2024-08-24', '2024-08-23'),
  (29, 24, '2024-08-15', '2024-08-29', '2024-08-27'),
  (30, 27, '2024-09-01', '2024-09-15', '2024-09-14'),
  (31, 31, '2024-09-05', '2024-09-19', '2024-09-17'),
  (32, 34, '2024-09-10', '2024-09-24', '2024-09-22'),
  (33, 36, '2024-09-15', '2024-09-29', '2024-09-27'),
  (34, 40, '2024-10-01', '2024-10-15', '2024-10-13'),
  (35, 43, '2024-10-05', '2024-10-19', '2024-10-17'),
  (36, 45, '2024-10-10', '2024-10-24', '2024-10-22'),
  (37, 47, '2024-10-15', '2024-10-29', '2024-10-27'),
  (38, 49, '2024-11-01', '2024-11-15', '2024-11-13'),
  (39, 50, '2024-11-05', '2024-11-19', '2024-11-17'),
  (40, 1,  '2024-11-10', '2024-11-24', '2024-11-22'),
  (41, 3,  '2024-11-15', '2024-11-29', '2024-11-27'),
  (42, 7,  '2024-12-01', '2024-12-15', '2024-12-13'),
  (43, 9,  '2024-12-05', '2024-12-19', '2024-12-17'),
  (44, 11, '2024-12-10', '2024-12-24', '2024-12-22'),
  (45, 16, '2024-12-15', '2024-12-29', '2024-12-27'),
  (46, 26, '2025-01-05', '2025-01-19', '2025-01-17'),
  (47, 35, '2025-01-10', '2025-01-24', '2025-01-22'),
  (48, 39, '2025-01-15', '2025-01-29', '2025-01-27'),
  (1,  7,  '2026-04-01', '2026-04-15', NULL),
  (2,  9,  '2026-04-05', '2026-04-19', NULL),
  (5,  11, '2026-04-10', '2026-04-24', NULL),
  (6,  48, '2026-04-15', '2026-04-29', NULL);


INSERT INTO reservations (member_id, book_id, reserved_date, status) VALUES
  (1,  3,  '2024-01-20', 'fulfilled'),
  (2,  7,  '2024-01-25', 'fulfilled'),
  (3,  9,  '2024-02-05', 'fulfilled'),
  (5,  12, '2024-02-12', 'fulfilled'),
  (6,  16, '2024-02-20', 'fulfilled'),
  (7,  20, '2024-03-01', 'fulfilled'),
  (8,  23, '2024-03-08', 'fulfilled'),
  (9,  26, '2024-03-15', 'fulfilled'),
  (10, 30, '2024-04-02', 'fulfilled'),
  (11, 35, '2024-04-08', 'fulfilled'),
  (12, 37, '2024-04-12', 'fulfilled'),
  (13, 39, '2024-05-02', 'fulfilled'),
  (14, 46, '2024-05-07', 'fulfilled'),
  (15, 48, '2024-05-12', 'fulfilled'),
  (16, 2,  '2024-06-02', 'fulfilled'),
  (17, 4,  '2024-06-06', 'fulfilled'),
  (18, 6,  '2024-06-11', 'fulfilled'),
  (20, 8,  '2024-07-02', 'fulfilled'),
  (21, 10, '2024-07-06', 'fulfilled'),
  (22, 13, '2024-07-11', 'fulfilled'),
  (23, 15, '2024-07-16', 'fulfilled'),
  (24, 17, '2024-08-02', 'fulfilled'),
  (25, 19, '2024-08-06', 'fulfilled'),
  (26, 21, '2024-08-11', 'fulfilled'),
  (27, 24, '2024-08-16', 'fulfilled'),
  (28, 27, '2024-09-02', 'fulfilled'),
  (29, 31, '2024-09-06', 'fulfilled'),
  (30, 34, '2024-09-11', 'fulfilled'),
  (31, 36, '2024-09-16', 'fulfilled'),
  (32, 40, '2024-10-02', 'fulfilled'),
  (33, 43, '2024-10-06', 'fulfilled'),
  (34, 45, '2024-10-11', 'fulfilled'),
  (35, 47, '2024-10-16', 'fulfilled'),
  (36, 49, '2024-11-02', 'fulfilled'),
  (37, 50, '2024-11-06', 'fulfilled'),
  (38, 1,  '2024-11-11', 'canceled'),
  (39, 3,  '2024-11-16', 'canceled'),
  (40, 7,  '2024-12-02', 'canceled'),
  (41, 9,  '2024-12-06', 'canceled'),
  (42, 11, '2024-12-11', 'canceled'),
  (43, 16, '2024-12-16', 'canceled'),
  (44, 26, '2025-01-02', 'canceled'),
  (45, 35, '2025-01-06', 'canceled'),
  (7,  7,  '2026-04-02', 'pending'),
  (8,  9,  '2026-04-06', 'pending'),
  (9,  11, '2026-04-11', 'pending'),
  (10, 48, '2026-04-16', 'pending'),
  (11, 7,  '2026-04-17', 'pending'),
  (12, 9,  '2026-04-18', 'pending'),
  (13, 11, '2026-04-19', 'pending');


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
