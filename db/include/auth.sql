-- this is a dummy function to make sure the auth schema exists
-- the auth schema is created and managed by the @subzerocloud/auth package
create schema if not exists auth;
create or replace function auth.jwt() returns jsonb
language sql stable
as $$
    select '{}'::jsonb
$$;