-- Run in the Supabase SQL editor before configuring the Site environment.
-- Data access goes through the server API; browser clients get no direct table grants.
create table if not exists public.inventory (
 id text primary key, data text not null, stock integer not null default 0 check(stock >= 0), active integer not null default 1
);
create table if not exists public.records (
 id text primary key, kind text not null, owner text not null default '', data text not null, created text not null
);
create index if not exists records_owner_kind on public.records(owner,kind);
alter table public.inventory enable row level security;
alter table public.records enable row level security;
revoke all on public.inventory, public.records from anon, authenticated;
grant all on public.inventory, public.records to service_role;
create or replace function public.place_bakery_order(order_id text,owner_id text,order_data text,order_created text,line_items jsonb)
returns void language plpgsql security invoker set search_path=public as $$
declare item jsonb; available integer;
begin
 for item in select value from jsonb_array_elements(line_items) order by value->>'id' loop
  select stock into available from inventory where id=item->>'id' and active=1 for update;
  if available is null or available < (item->>'qty')::integer or (item->>'qty')::integer < 1 then raise exception 'Insufficient stock'; end if;
  update inventory set stock=stock-(item->>'qty')::integer where id=item->>'id';
 end loop;
 insert into records(id,kind,owner,data,created) values(order_id,'order',owner_id,order_data,order_created);
 delete from records where id='cart:'||owner_id;
end; $$;
revoke all on function public.place_bakery_order(text,text,text,text,jsonb) from public, anon, authenticated;
grant execute on function public.place_bakery_order(text,text,text,text,jsonb) to service_role;
