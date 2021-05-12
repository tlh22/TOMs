/**
Change over guacamole connections
**/

UPDATE public.guacamole_connection_parameter
	SET parameter_value=?
	WHERE parameter_name='hostname'
	AND parameter_value = '??';