BEGIN;

\i schema.sql

INSERT INTO Users (UserID, Username, NetWorth)
    VALUES (1, 'Richie',   '10000000000.00'),
           (2, 'Mayda',    '150.00'),
           (3, 'Freckles', '0.00'),
           (4, 'Gloria',   '0.00')
           ;

INSERT INTO BankAccounts (BankAccountID, UserID, Balance)
VALUES
    (100, 1, '5000000000.00'),
    (101, 1, '5000000000.00'),
    (102, 2, '150.00'),
    (103, 4, '0.00')
    ;

SELECT setval(pg_get_serial_sequence('users', 'userid'), 10000, FALSE);


COMMIT;
