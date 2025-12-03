CREATE DATABASE StorytelDB;
GO

USE StorytelDB;
GO

-- 1. Formats
CREATE TABLE Formats(
    FormatId INT IDENTITY PRIMARY KEY,
    FormatName NVARCHAR(100) NOT NULL
);

-- 2. Genres
CREATE TABLE Genres(
    GenreId INT IDENTITY PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Description NVARCHAR(500)
);

-- 3. Authors
CREATE TABLE Authors(
    AuthorId INT IDENTITY PRIMARY KEY,
    FullName NVARCHAR(200) NOT NULL,
    Bio NVARCHAR(MAX),
    Country NVARCHAR(100),
    Website NVARCHAR(200)
);

-- 4. Publishers
CREATE TABLE Publishers(
    PublisherId INT IDENTITY PRIMARY KEY,
    Name NVARCHAR(200) NOT NULL,
    Country NVARCHAR(100),
    Website NVARCHAR(200)
);

-- 5. Books (включва AverageRating и ReviewCount)
CREATE TABLE Books(
    BookId INT IDENTITY PRIMARY KEY,
    Title NVARCHAR(300) NOT NULL,
    Subtitle NVARCHAR(300),
    Description NVARCHAR(MAX),
    PublisherId INT NULL,
    PublishedDate DATE,
    Language NVARCHAR(50),
    ISBN NVARCHAR(50),
    DurationSeconds INT,
    CoverImageUrl NVARCHAR(500),
    AverageRating DECIMAL(3,2) DEFAULT 0.00,
    ReviewCount INT DEFAULT 0,
    CONSTRAINT FK_Books_Publishers FOREIGN KEY (PublisherId)
        REFERENCES Publishers(PublisherId)
);

-- 6. Many-to-many: BookFormats
CREATE TABLE BookFormats(
    BookId INT NOT NULL,
    FormatId INT NOT NULL,
    SizeMB DECIMAL(10,2),
    PRIMARY KEY (BookId, FormatId),
    FOREIGN KEY (BookId) REFERENCES Books(BookId),
    FOREIGN KEY (FormatId) REFERENCES Formats(FormatId)
);

-- 7. Many-to-many: BookGenres
CREATE TABLE BookGenres(
    BookId INT NOT NULL,
    GenreId INT NOT NULL,
    PRIMARY KEY (BookId, GenreId),
    FOREIGN KEY (BookId) REFERENCES Books(BookId),
    FOREIGN KEY (GenreId) REFERENCES Genres(GenreId)
);

-- 8. Many-to-many: BookAuthors
CREATE TABLE BookAuthors(
    BookId INT NOT NULL,
    AuthorId INT NOT NULL,
    Role NVARCHAR(100) NULL,
    PRIMARY KEY (BookId, AuthorId),
    FOREIGN KEY (BookId) REFERENCES Books(BookId),
    FOREIGN KEY (AuthorId) REFERENCES Authors(AuthorId)
);

-- 9. Roles
CREATE TABLE Roles(
    RoleId INT IDENTITY PRIMARY KEY,
    RoleName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(300)
);

-- 10. Users
CREATE TABLE Users(
    UserId INT IDENTITY PRIMARY KEY,
    Email NVARCHAR(200) UNIQUE NOT NULL,
    PasswordHash NVARCHAR(500) NOT NULL,
    FirstName NVARCHAR(100),
    LastName NVARCHAR(100),
    DateJoined DATE,
    LastLogin DATETIME,
    Country NVARCHAR(100),
    RoleId INT NULL,
    CONSTRAINT FK_Users_Roles FOREIGN KEY (RoleId) REFERENCES Roles(RoleId)
);

-- 11. Reviews
CREATE TABLE Reviews(
    ReviewId INT IDENTITY PRIMARY KEY,
    UserId INT NOT NULL,
    BookId INT NOT NULL,
    Rating INT CHECK (Rating BETWEEN 1 AND 5),
    Title NVARCHAR(200),
    Comment NVARCHAR(MAX),
    CreatedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Reviews_Users FOREIGN KEY (UserId) REFERENCES Users(UserId),
    CONSTRAINT FK_Reviews_Books FOREIGN KEY (BookId) REFERENCES Books(BookId)
);

-- 12. SubscriptionPlans
CREATE TABLE SubscriptionPlans(
    PlanId INT IDENTITY PRIMARY KEY,
    PlanName NVARCHAR(100) NOT NULL,
    BillingCycle NVARCHAR(50),
    Price DECIMAL(10,2),
    Currency NVARCHAR(20),
    TrialDays INT
);

-- 13. UserSubscriptions
CREATE TABLE UserSubscriptions(
    UserSubscriptionId INT IDENTITY PRIMARY KEY,
    UserId INT NOT NULL,
    PlanId INT NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE,
    IsActive BIT DEFAULT 1,
    AutoRenew BIT DEFAULT 1,
    CONSTRAINT FK_UserSubscriptions_Users FOREIGN KEY (UserId) REFERENCES Users(UserId),
    CONSTRAINT FK_UserSubscriptions_Plans FOREIGN KEY (PlanId) REFERENCES SubscriptionPlans(PlanId)
);

-- 14. Payments
CREATE TABLE Payments(
    PaymentId INT IDENTITY PRIMARY KEY,
    UserId INT NULL,
    UserSubscriptionId INT NULL,
    Amount DECIMAL(10,2),
    Currency NVARCHAR(20),
    Provider NVARCHAR(50),
    PaymentDate DATETIME DEFAULT GETDATE(),
    Status NVARCHAR(50),
    CONSTRAINT FK_Payments_Users FOREIGN KEY (UserId) REFERENCES Users(UserId),
    CONSTRAINT FK_Payments_UserSubscriptions FOREIGN KEY (UserSubscriptionId) REFERENCES UserSubscriptions(UserSubscriptionId)
);

-- 15. UserProgress
CREATE TABLE UserProgress(
    UserProgressId INT IDENTITY PRIMARY KEY,
    UserId INT NOT NULL,
    BookId INT NOT NULL,
    LastPositionSeconds INT DEFAULT 0,
    UpdatedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_UserProgress_Users FOREIGN KEY (UserId) REFERENCES Users(UserId),
    CONSTRAINT FK_UserProgress_Books FOREIGN KEY (BookId) REFERENCES Books(BookId)
);
