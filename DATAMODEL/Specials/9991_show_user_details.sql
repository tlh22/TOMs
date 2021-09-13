
/**
Show user role
**/
-- https://stackoverflow.com/questions/3554484/postgresql-query-to-show-the-groups-of-a-user
select rolname from pg_user
join pg_auth_members on (pg_user.usesysid=pg_auth_members.member)
join pg_roles on (pg_roles.oid=pg_auth_members.roleid)
where pg_user.usename='user.name';