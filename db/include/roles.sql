-- utility function to drop owned by a role if it exists
create or replace function public.drop_owned_if_exists(role_name text)
returns void as $$
begin
    if exists (select 1 from pg_roles where rolname = role_name) then
        execute format('drop owned by %I', role_name);
    end if;
end;
$$ language plpgsql;


-- define application roles
select public.drop_owned_if_exists('authenticated'::text);
drop role if exists authenticated;
create role authenticated;

-- drop the utility function
drop function if exists public.drop_owned_if_exists(role_name text);
