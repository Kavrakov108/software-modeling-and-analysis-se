-- Roles
INSERT INTO Roles (RoleName, Description) VALUES
('Admin','Administrator'),
('User','Regular subscriber');

-- Users
INSERT INTO Users (Email, PasswordHash, FirstName, LastName, DateJoined, LastLogin, Country, RoleId)
VALUES
('alice@example.com','HASH1','Alice','Ivanova','2024-01-10','2024-12-01 10:00','Bulgaria',2),
('bob@example.com','HASH2','Bob','Petrov','2023-05-03','2024-11-28 18:30','Bulgaria',2),
('admin@example.com','HASHADMIN','Site','Admin','2022-01-01','2024-12-01 09:00','Bulgaria',1);

-- Subscription plans
INSERT INTO SubscriptionPlans (PlanName, BillingCycle, Price, Currency, TrialDays)
VALUES ('Monthly','Monthly',9.99,'EUR',14),
       ('Yearly','Yearly',99.99,'EUR',14);

-- UserSubscriptions
INSERT INTO UserSubscriptions (UserId, PlanId, StartDate, EndDate, IsActive, AutoRenew)
VALUES (1,1,'2024-01-10',NULL,1,1),
       (2,2,'2023-06-01','2024-06-01',0,0);

-- Payments
INSERT INTO Payments (UserId, UserSubscriptionId, Amount, Currency, Provider, PaymentDate, Status)
VALUES (1,1,9.99,'EUR','Stripe','2024-01-10 08:00','Completed'),
       (2,2,99.99,'EUR','Paypal','2023-06-01 09:00','Completed');

-- Formats
INSERT INTO Formats (FormatName) VALUES ('MP3'), ('AAC'), ('FLAC');

-- Genres
INSERT INTO Genres (Name, Description) VALUES
('Fiction','Fictional works'),
('Non-Fiction','Non-fictional works'),
('Sci-Fi','Science Fiction');

-- Publishers
INSERT INTO Publishers (Name, Country, Website) VALUES
('Penguin Random House','USA','https://penguinrandomhouse.com'),
('LocalPub','Bulgaria','http://localpub.example');

-- Authors
INSERT INTO Authors (FullName, Bio, Country, Website) VALUES
('George Orwell','Author of 1984','UK',NULL),
('Isaac Asimov','Sci-fi author','USA',NULL),
('Elena Marinova','Contemporary writer from BG','Bulgaria',NULL);

-- Books
INSERT INTO Books (Title, Subtitle, Description, PublisherId, PublishedDate, Language, ISBN, DurationSeconds, CoverImageUrl)
VALUES
('1984','A novel','Dystopian novel by George Orwell',1,'1949-06-08','English','9780451524935',36000,NULL),
('Foundation','Foundation series book 1','Classic sci-fi by Asimov',1,'1951-05-01','English','9780553293357',40000,NULL),
('BG Short Stories',NULL,'A collection of short stories in Bulgarian',2,'2022-03-15','Bulgarian','BG-0001',7200,NULL);

-- BookAuthors (M:N)
INSERT INTO BookAuthors (BookId, AuthorId, Role) VALUES
(1,1,'Author'),
(2,2,'Author'),
(3,3,'Author');

-- BookGenres (M:N)
INSERT INTO BookGenres (BookId, GenreId) VALUES
(1,1),
(2,3),
(3,1);

-- BookFormats (M:N)
INSERT INTO BookFormats (BookId, FormatId, SizeMB) VALUES
(1,1,85.5),
(1,2,70.2),
(2,1,95.0),
(3,1,20.0);

-- UserProgress
INSERT INTO UserProgress (UserId, BookId, LastPositionSeconds, UpdatedAt) VALUES
(1,1,1200,'2024-12-01 11:00'),
(2,2,3000,'2024-11-28 19:00');