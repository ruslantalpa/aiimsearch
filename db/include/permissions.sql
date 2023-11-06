

-- enable row level security on all tables in the public schema
-- alter table todos enable row level security;

-- define permissions and policies
-- allow authenticated role access to personal rows in todos table
-- grant 
--     select (id, title, done),
--     insert (title, done),
--     update (title, done),
--     delete
-- on todos to authenticated;
-- grant usage on sequence todos_id_seq to authenticated;
-- create policy "authenticated role access for todos" on todos to authenticated
-- using ( user_id = (auth.jwt()->>'sub')::uuid );

grant usage on schema data to authenticated;
grant all on all tables in schema data to authenticated;
