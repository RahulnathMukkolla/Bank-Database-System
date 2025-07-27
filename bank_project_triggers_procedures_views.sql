
-- ================================
-- TRIGGERS
-- ================================

-- Trigger: Update Account Balance after Insert on BankTransaction
DELIMITER $$
CREATE TRIGGER trg_update_balance
AFTER INSERT ON BankTransaction
FOR EACH ROW
BEGIN
    IF NEW.TransactionType = 'Deposit' THEN
        UPDATE Account
        SET Balance = Balance + NEW.Amount
        WHERE CustomerID = NEW.CustomerID;
    ELSEIF NEW.TransactionType = 'Withdrawal' THEN
        UPDATE Account
        SET Balance = Balance - NEW.Amount
        WHERE CustomerID = NEW.CustomerID;
    END IF;
END $$
DELIMITER ;

-- ================================
-- STORED PROCEDURES
-- ================================

-- Procedure: Make a deposit
DELIMITER $$
CREATE PROCEDURE Deposit(
    IN p_CustomerID INT,
    IN p_Amount DECIMAL(10,2)
)
BEGIN
    INSERT INTO BankTransaction (CustomerID, TransactionDate, Amount, TransactionType)
    VALUES (p_CustomerID, CURDATE(), p_Amount, 'Deposit');
END $$
DELIMITER ;

-- Procedure: Make a withdrawal
DELIMITER $$
CREATE PROCEDURE Withdraw(
    IN p_CustomerID INT,
    IN p_Amount DECIMAL(10,2)
)
BEGIN
    DECLARE current_balance DECIMAL(10,2);

    SELECT Balance INTO current_balance
    FROM Account
    WHERE CustomerID = p_CustomerID;

    IF current_balance >= p_Amount THEN
        INSERT INTO BankTransaction (CustomerID, TransactionDate, Amount, TransactionType)
        VALUES (p_CustomerID, CURDATE(), p_Amount, 'Withdrawal');
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Insufficient Balance';
    END IF;
END $$
DELIMITER ;

-- Procedure: Apply for a Loan
DELIMITER $$
CREATE PROCEDURE ApplyLoan(
    IN p_CustomerID INT,
    IN p_LoanAmount DECIMAL(10,2)
)
BEGIN
    INSERT INTO Loan (CustomerID, LoanAmount, LoanDate)
    VALUES (p_CustomerID, p_LoanAmount, CURDATE());
END $$
DELIMITER ;

-- ================================
-- VIEWS
-- ================================

-- View: Customer Summary
CREATE VIEW CustomerSummary AS
SELECT
    c.CustomerID,
    c.CustomerName,
    b.BranchName,
    a.Balance,
    COUNT(t.TransactionID) AS TotalTransactions,
    SUM(CASE WHEN t.TransactionType = 'Deposit' THEN t.Amount ELSE 0 END) AS TotalDeposits,
    SUM(CASE WHEN t.TransactionType = 'Withdrawal' THEN t.Amount ELSE 0 END) AS TotalWithdrawals
FROM Customer c
LEFT JOIN Branch b ON c.BranchID = b.BranchID
LEFT JOIN Account a ON c.AccountNumber = a.AccountNumber
LEFT JOIN BankTransaction t ON c.CustomerID = t.CustomerID
GROUP BY c.CustomerID, c.CustomerName, b.BranchName, a.Balance;

-- View: Loan Summary
CREATE VIEW LoanSummary AS
SELECT
    l.LoanID,
    c.CustomerName,
    l.LoanAmount,
    l.LoanDate
FROM Loan l
JOIN Customer c ON l.CustomerID = c.CustomerID;
