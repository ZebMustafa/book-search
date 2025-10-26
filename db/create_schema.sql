-- We are using PostgreSQL 17.6


-- CSV Header is below
-- bookId, title, author, rating, description, isbn, isbn, bookformat, edition, pages, publisher, publicationDate, firstPublisherDate, likedPercent, price

-- Create books table

CREATE TABLE IF NOT EXISTS books (
    book_id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    rating FLOAT,
    description TEXT,
    isbn VARCHAR(20),
    book_format VARCHAR(50),
    edition VARCHAR(50),
    pages INT,
    publisher VARCHAR(255),
    publication_date DATE,
    first_publisher_date DATE,
    liked_percent FLOAT,
    price DECIMAL(10, 2)
);

-- Create the authors table
CREATE TABLE IF NOT EXISTS authors (
    author_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

-- Create the books_authors table
CREATE TABLE IF NOT EXISTS books_authors (
    book_id INT NOT  NULL,
    author_id INT NOT NULL,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id),
    FOREIGN KEY (author_id) REFERENCES authors(author_id)
);