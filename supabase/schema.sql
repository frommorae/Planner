-- Morae Planner: one table that stores each person's planner as small documents
-- ("meta" for settings and categories, "d_YYYY-MM-DD" for each day).
-- Paste this whole file into Supabase → SQL Editor → New query → Run. Safe to run again.

create table if not exists public.planner_docs (
  user_id    uuid not null default auth.uid() references auth.users(id) on delete cascade,
  id         text not null,
  body       jsonb not null,
  device     text,
  updated_at timestamptz not null default now(),
  primary key (user_id, id)
);

-- Row Level Security: each signed-in person can only see and change their own rows.
alter table public.planner_docs enable row level security;
drop policy if exists "planner: read own"   on public.planner_docs;
drop policy if exists "planner: insert own" on public.planner_docs;
drop policy if exists "planner: update own" on public.planner_docs;
drop policy if exists "planner: delete own" on public.planner_docs;
create policy "planner: read own"   on public.planner_docs for select using ((select auth.uid()) = user_id);
create policy "planner: insert own" on public.planner_docs for insert with check ((select auth.uid()) = user_id);
create policy "planner: update own" on public.planner_docs for update using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
create policy "planner: delete own" on public.planner_docs for delete using ((select auth.uid()) = user_id);

-- The server stamps the time of every save (used to catch up after a phone sleeps).
create or replace function public.planner_touch() returns trigger
language plpgsql set search_path = '' as $$
begin new.updated_at = now(); return new; end $$;
drop trigger if exists planner_touch on public.planner_docs;
create trigger planner_touch before insert or update on public.planner_docs
  for each row execute function public.planner_touch();

-- Live updates between your phone and laptop.
do $$ begin
  alter publication supabase_realtime add table public.planner_docs;
exception when duplicate_object then null; end $$;
