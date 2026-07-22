/*  PART 0: CLEAN UP OLD DATA */

DROP TABLE IF EXISTS transactions;

/*  PART 1: FINTECH DATABASE SCHEMA SETUP */
CREATE TABLE transactions (
    txn_id VARCHAR(50) PRIMARY KEY,
    user_id VARCHAR(50),
    merchant_id VARCHAR(50),
    txn_amount DECIMAL(10,2),
    payment_method VARCHAR(20), -- UPI, Wallet, Credit Card
    txn_status VARCHAR(20),     -- SUCCESS, FAILED, PENDING
    txn_timestamp DATETIME      
);

/*  PART 2: INSERT MOCK TRANSACTION DATA */
INSERT INTO transactions (txn_id, user_id, merchant_id, txn_amount, payment_method, txn_status, txn_timestamp)
VALUES
  
-- Normal successful transactions for Query 1
('TXN-1001', 'U-101', 'M-50', 1500.00, 'UPI', 'SUCCESS', DATEADD(MINUTE, -120, GETDATE())),
('TXN-1002', 'U-102', 'M-51', 850.00, 'Wallet', 'SUCCESS', DATEADD(MINUTE, -115, GETDATE())),
('TXN-1003', 'U-103', 'M-50', 250.00, 'UPI', 'SUCCESS', DATEADD(MINUTE, -110, GETDATE())),
('TXN-1004', 'U-104', 'M-52', 5000.00, 'Credit Card', 'SUCCESS', DATEADD(MINUTE, -100, GETDATE())),
('TXN-1005', 'U-105', 'M-51', 120.00, 'Wallet', 'FAILED', DATEADD(MINUTE, -90, GETDATE())),

-- Fraudulent behavior simulation for Query 2 (High-Frequency Failures in last hour)
('TXN-9001', 'U-999', 'M-99', 10000.00, 'Credit Card', 'FAILED', DATEADD(MINUTE, -25, GETDATE())),
('TXN-9002', 'U-999', 'M-99', 10000.00, 'Credit Card', 'FAILED', DATEADD(MINUTE, -24, GETDATE())),
('TXN-9003', 'U-999', 'M-99', 10000.00, 'Credit Card', 'FAILED', DATEADD(MINUTE, -23, GETDATE())),
('TXN-9004', 'U-999', 'M-99', 10000.00, 'Credit Card', 'FAILED', DATEADD(MINUTE, -22, GETDATE())),
('TXN-9005', 'U-999', 'M-99', 10000.00, 'Credit Card', 'FAILED', DATEADD(MINUTE, -21, GETDATE())),
('TXN-9006', 'U-999', 'M-99', 10000.00, 'Credit Card', 'FAILED', DATEADD(MINUTE, -20, GETDATE()));

/*  PART 3: ADVANCED ANALYTICS QUERIES (PhonePe Metrics) */

-- QUERY 1: Payment Success Rate & Volume by Method (Daily)
WITH Daily_Stats AS (
    SELECT 
        CAST(txn_timestamp AS DATE) AS txn_date,
        payment_method,
        COUNT(txn_id) AS total_txns,
        SUM(CASE WHEN txn_status = 'SUCCESS' THEN 1 ELSE 0 END) AS successful_txns,
        SUM(txn_amount) AS total_processing_volume
    FROM transactions
    GROUP BY CAST(txn_timestamp AS DATE), payment_method
)
SELECT 
    txn_date,
    payment_method,
    total_txns,
    successful_txns,
    ROUND((successful_txns * 100.0) / total_txns, 2) AS success_rate_pct,
    total_processing_volume
FROM Daily_Stats
ORDER BY txn_date DESC, success_rate_pct ASC;

-- QUERY 2: Anomaly / Fraud Detection (High-Frequency Failures)
SELECT 
    user_id,
    COUNT(txn_id) AS failed_attempts,
    SUM(txn_amount) AS at_risk_amount,
    MIN(txn_timestamp) AS first_failure,
    MAX(txn_timestamp) AS latest_failure
FROM transactions
WHERE txn_status = 'FAILED' 
  AND txn_timestamp >= DATEADD(HOUR, -1, GETDATE())
GROUP BY user_id
HAVING COUNT(txn_id) > 5 
ORDER BY failed_attempts DESC;
