CREATE OR REPLACE FUNCTION New_User(_Username text)
	RETURNS integer
	LANGUAGE plpgsql
AS
$$
	DECLARE
		new_userid integer := 0;
	BEGIN
		PERFORM userid
		FROM users
		WHERE username = _Username;
		IF FOUND THEN
			RAISE NOTICE 'User % already exists', _Username;
			RETURN NULL;
		END IF;
	
		SELECT nextval(pg_get_serial_sequence('users', 'userid'))
		INTO new_userid;
		
		INSERT INTO Users (UserID, Username)
		VALUES (new_userid, _Username);

		RETURN new_userid;
	END;
$$
