CREATE TABLE Users
(
    UserID serial,
    Username text NOT NULL,
    -- sum of the balances of this user's bank accounts
    NetWorth numeric NOT NULL DEFAULT 0.00,

    PRIMARY KEY (UserID),
    UNIQUE (Username)
);

CREATE TABLE BankAccounts
(
    BankAccountID integer,
    -- the owner of this bank account
    UserID integer NOT NULL REFERENCES Users,
    Balance numeric NOT NULL DEFAULT 0.00,

    PRIMARY KEY (BankAccountID)
);

CREATE TABLE BankDeposits
(
    BankDepositID serial,
    -- the bank account the money was deposited from
    SenderBankAccountID integer NOT NULL REFERENCES BankAccounts,
    -- the bank account the money was deposited to
    RecipientBankAccountID integer NOT NULL REFERENCES BankAccounts,

    Amount numeric NOT NULL,
    Datestamp timestamp with time zone NOT NULL DEFAULT now(),

    CHECK (Amount > 0.00),
    CHECK (SenderBankAccountID <> RecipientBankAccountID),

    PRIMARY KEY (BankDepositID)
);


COMMENT ON COLUMN Users.NetWorth IS 'sum of the balances of this user''s bank accounts';
COMMENT ON COLUMN BankAccounts.UserID IS 'the owner of this bank account';
COMMENT ON COLUMN BankDeposits.SenderBankAccountID IS 'the bank account the money was deposited from';
COMMENT ON COLUMN BankDeposits.RecipientBankAccountID IS 'he bank account the money was deposited to';

