CREATE Database Bank;

Use Bank;

-- Table: Branch
CREATE TABLE Branch (
    BranchID INT PRIMARY KEY,
    BranchName VARCHAR(50),
    Location VARCHAR(100)
);

-- Table: Customer
CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY,
    BranchID INT,
    CustomerName VARCHAR(50),
    AccountNumber VARCHAR(20),
    CONSTRAINT fk_branch FOREIGN KEY (BranchID) REFERENCES Branch(BranchID)
);

-- Table: BankTransaction
CREATE TABLE BankTransaction (
    TransactionID INT PRIMARY KEY,
    CustomerID INT,
    TransactionDate DATE,
    Amount DECIMAL(10,2),
    TransactionType VARCHAR(10), -- 'Deposit' or 'Withdrawal'
    CONSTRAINT fk_customer_txn FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

-- Table: Employee
CREATE TABLE Employee (
    EmployeeID INT PRIMARY KEY,
    BranchID INT,
    EmployeeName VARCHAR(50),
    Position VARCHAR(50),
    CONSTRAINT fk_branch_emp FOREIGN KEY (BranchID) REFERENCES Branch(BranchID)
);

-- Table: Account
CREATE TABLE Account (
    AccountNumber VARCHAR(20) PRIMARY KEY,
    CustomerID INT,
    Balance DECIMAL(10,2),
    CONSTRAINT fk_customer_acc FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

-- Table: Loan
CREATE TABLE Loan (
    LoanID INT PRIMARY KEY,
    CustomerID INT,
    LoanAmount DECIMAL(10,2),
    LoanDate DATE,
    CONSTRAINT fk_customer_loan FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

ALTER TABLE BankTransaction ADD HandledByEmployeeID INT;

ALTER TABLE BankTransaction 
ADD CONSTRAINT fk_txn_employee FOREIGN KEY (HandledByEmployeeID) REFERENCES Employee(EmployeeID);

SET SQL_SAFE_UPDATES = 0;
UPDATE BankTransaction
SET HandledByEmployeeID = (
    SELECT EmployeeID
    FROM Employee
    WHERE Employee.BranchID = (
        SELECT BranchID FROM Customer WHERE Customer.CustomerID = BankTransaction.CustomerID
    )
    ORDER BY RAND()
    LIMIT 1
);
SET SQL_SAFE_UPDATES = 1;