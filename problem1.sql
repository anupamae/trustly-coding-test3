 CREATE OR REPLACE FUNCTION New_User(_Username text)
	RETURNS integer
	LANGUAGE plpgsql
AS
$$
	DECLARE
		new_userid integer;
	BEGIN
		SELECT nextval(pg_get_serial_sequence('users', 'userid'))
		INTO new_userid;
		
		INSERT INTO Users (UserID, Username)
		VALUES (new_userid, _Username);

		RETURN new_userid;
		
	EXCEPTION
		WHEN unique_violation THEN
			RAISE unique_violation USING MESSAGE = 'User already exists';
	END;
$$
