-- Accounts (account_id, type, balance, interest_rate, owner)
-- Clients (id, name, phone)
-- Deposits (account_id, amount, when) // when is a DATETIME

CREATE TABLE Clients (
    id INT,
    name VARCHAR(50),
    phone VARCHAR(13),
    PRIMARY KEY (id)
);

CREATE TABLE Accounts (
    account_id INT,
    type VARCHAR(20),
    balance FLOAT,
    interest_rate FLOAT,
    owner INT,
    PRIMARY KEY(account_id),
    FOREIGN KEY (owner) REFERENCES Clients (id)
);

CREATE TABLE Accounts (
    account_id INT,
    type VARCHAR(20),
    balance FLOAT,
    interest_rate FLOAT,
    owner INT,
    PRIMARY KEY(account_id),
    FOREIGN KEY (owner) REFERENCES Clients (id) AND Clients (name)
);

CREATE TABLE Deposits (
    account_id INT,
    amount FLOAT,
    t DATETIME,
    PRIMARY KEY (account_id, amount, t),
    FOREIGN KEY (account_id) REFERENCES Accounts (account_id)
);


Insert Into Clients (id, name, phone)
Values (1, 'Alexander', '555-555-5555');
Insert Into Accounts (account_id, type, balance, interest_rate, owner)
Values (1, 'savings', 3000.0, 7.0, 1);
Insert Into Deposits (account_id, amount, t)
Values (1, 1000.0, '2021-02-10 12:30:00');

Insert Into Deposits (account_id, amount, t)
Values (2, 99.0, '2021-02-10 12:30:00');


Insert Into Deposits (account_id, amount, t)
Values (2, 150.0, '2021-02-10 12:30:00');


Insert Into Deposits (account_id, amount, t)
Values (2, 9000.0, '2021-02-10 12:30:00');

Insert Into Clients (id, name, phone)
Values (2, 'Lex', '555-555-5555');
Insert Into Accounts (account_id, type, balance, interest_rate, owner)
Values (2, 'savings', 3000.0, 7.0, 2);
Insert Into Clients (id, name, phone)
Values (3, 'Xander', '555-555-5555');
Insert Into MyRestaurants (name, food_type, distance, last_visit, liked)
Values ('Big Tuna', 'Teriyaki', 3, '2020-01-19', 1);
Insert Into MyRestaurants (name, food_type, distance, last_visit, liked)
Values ('Kong Tofu House', 'Korean', 20, '2021-03-20', NULL);
-- Write an SQL query to find, for each member, their name, the number of accounts they own, and the date of the
-- latest deposit made to any of their accounts. 

-- You should return a date of NULL if no deposits have been made. You can use MAX over a DATETIME type. 
-- Use the output column names: name, num_accounts, and latest_deposit.

SELECT c.name AS name, COUNT(a.owner) AS num_accounts, MAX(d.t) AS latest_deposit 
FROM Clients c LEFT OUTER JOIN Accounts a ON c.id = a.owner
LEFT OUTER JOIN Deposits d ON a.account_id = d.account_id
GROUP BY c.id, c.name;

-- Write an SQL query to find the distinct ids of people whose 
-- average account interest rate is higher 
-- than 5 and who have made no more than 10 deposits each less than 
-- $100 across all of their accounts. 

SELECT DISTINCT c.id AS id FROM Clients c 
JOIN Accounts a ON c.id = a.owner
JOIN (SELECT DISTINCT a.owner, COUNT(a.owner) AS ten FROM Accounts a JOIN
        Deposits d ON a.account_id = d.account_id
        WHERE d.amount < 100
        GROUP BY a.owner) AS subq1 ON a.owner = subq1.owner
WHERE subq1.ten <= 10
GROUP BY c.id
HAVING AVG(a.interest_rate) > 5

-- "What are the names of people who have never made any deposits larger
-- than $1000 into their accounts?

SELECT c.name AS name
FROM Clients c RIGHT OUTER JOIN Accounts a ON c.id = a.owner
LEFT OUTER JOIN Deposits d ON a.account_id = d.account_id
WHERE d.amount < 1000
GROUP BY c.id, c.name;