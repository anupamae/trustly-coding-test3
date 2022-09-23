CREATE OR REPLACE FUNCTION New_Deposit(_Username text, _Recipient text, _Amount numeric)
	RETURNS integer 
	LANGUAGE plpgsql 
AS
$$
	DECLARE
		sender_id users.userid%TYPE;
		sender_bankid bankaccounts.bankaccountid%TYPE;
		
		recvr_id users.userid%TYPE;
		recvr_bankid bankaccounts.bankaccountid%TYPE;
		
		new_deposit_id bankdeposits.bankdepositid%TYPE;

	BEGIN
		-- Get sender user id
		SELECT userid
		FROM public.users
		WHERE username = _Username
		LIMIT 1
		INTO sender_id;
		IF NOT FOUND THEN
     		RAISE NOTICE 'User % could not be found', _Username;
			RETURN NULL;
		END IF;

	    -- Get receiver user id
		SELECT userid
		FROM public.users
		WHERE username = _Recipient
		LIMIT 1
		INTO recvr_id;
		IF NOT FOUND THEN
			RAISE NOTICE 'User % could not be found', _Recipient;
			RETURN NULL;
		END IF;
		
		-- Get sender bank account with enough balance
		SELECT BankAccountID
		FROM public.bankaccounts
		WHERE userid = sender_id AND balance >= _Amount
		LIMIT 1
		INTO sender_bankid;
		IF NOT FOUND THEN
			RAISE NOTICE 'User % does not have enough fund to send', _Username;
			RETURN NULL;
		END IF;
		
		-- Get receiver bank account
		SELECT BankAccountID
		FROM public.bankaccounts
		WHERE userid = recvr_id
		LIMIT 1
		INTO recvr_bankid;
		IF NOT FOUND THEN
			RAISE NOTICE 'User % does not any bank account to deposit', _Recipient;
			RETURN NULL;
		END IF;
		
		-- Validate accounts
		IF sender_id = recvr_id OR sender_bankid = recvr_bankid THEN
    		RAISE NOTICE 'Sender account and receiver are the same';
			RETURN NULL;
  		END IF;
		
		-- Update user worth
		UPDATE users SET networth = networth - _Amount WHERE userid = sender_id;
		UPDATE users SET networth = networth + _Amount WHERE userid = recvr_id;
		
		-- Update bank accounts
		UPDATE bankaccounts SET balance = balance - _Amount WHERE BankAccountID = sender_bankid;
		UPDATE bankaccounts SET balance = balance + _Amount WHERE BankAccountID = recvr_bankid;
		
		-- Get next sequence for deposit id
		SELECT nextval(pg_get_serial_sequence('bankdeposits', 'bankdepositid'))
		INTO new_deposit_id;
		
		-- Create deposit record
		INSERT INTO bankdeposits(BankDepositID, SenderBankAccountID, RecipientBankAccountID, Amount)
		VALUES (new_deposit_id, sender_bankid, recvr_bankid, _Amount);
		
		RETURN new_deposit_id;
	END;
$$
