#  Find the customers who have made the highest total deposits in the past month

SELECT 
    c.CustomerID,
    c.CustomerName,
    SUM(bt.Amount) AS TotalDeposits
FROM BankTransaction bt
JOIN Customer c ON bt.CustomerID = c.CustomerID
WHERE bt.TransactionType = 'Deposit'
  AND bt.TransactionDate >= CURDATE() - INTERVAL 1 MONTH
GROUP BY c.CustomerID, c.CustomerName
ORDER BY TotalDeposits DESC;

#  Calculate the average balance of accounts in each branch

SELECT 
    b.BranchID,
    b.BranchName,
    AVG(a.Balance) AS AverageBalance
FROM Account a
JOIN Customer c ON a.CustomerID = c.CustomerID
JOIN Branch b ON c.BranchID = b.BranchID
GROUP BY b.BranchID, b.BranchName;

#  List the top 3 branches with the highest number of withdrawals

SELECT 
    b.BranchID,
    b.BranchName,
    COUNT(bt.TransactionID) AS WithdrawalCount
FROM BankTransaction bt
JOIN Customer c ON bt.CustomerID = c.CustomerID
JOIN Branch b ON c.BranchID = b.BranchID
WHERE bt.TransactionType = 'Withdrawal'
GROUP BY b.BranchID, b.BranchName
ORDER BY WithdrawalCount DESC
LIMIT 3;

#  Identify customers who have a loan but have not made any deposits

SELECT 
    c.CustomerID,
    c.CustomerName
FROM Customer c
JOIN Loan l ON c.CustomerID = l.CustomerID
WHERE c.CustomerID NOT IN (
    SELECT DISTINCT CustomerID
    FROM BankTransaction
    WHERE TransactionType = 'Deposit'
);

#  Find the employee who has served the most number of customers

SELECT 
    e.EmployeeID,
    e.EmployeeName,
    COUNT(DISTINCT bt.CustomerID) AS CustomersServed
FROM BankTransaction bt
JOIN Employee e ON bt.HandledByEmployeeID = e.EmployeeID
GROUP BY e.EmployeeID, e.EmployeeName
ORDER BY CustomersServed DESC
LIMIT 1;

#  Retrieve the total number of withdrawals and deposits for a particular branch on a given day

SELECT 
    b.BranchID,
    b.BranchName,
    SUM(CASE WHEN bt.TransactionType = 'Deposit' THEN 1 ELSE 0 END) AS TotalDeposits,
    SUM(CASE WHEN bt.TransactionType = 'Withdrawal' THEN 1 ELSE 0 END) AS TotalWithdrawals
FROM BankTransaction bt
JOIN Customer c ON bt.CustomerID = c.CustomerID
JOIN Branch b ON c.BranchID = b.BranchID
WHERE b.BranchID = 7
  AND bt.TransactionDate = '2024-05-26'
GROUP BY b.BranchID, b.BranchName;