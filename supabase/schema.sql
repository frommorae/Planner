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

-- ---------------------------------------------------------------
-- Morae MCAT beta board: everyone can read the open items, only creators can write.
-- After you sign up, make yourself a creator (SQL Editor, once):
--   insert into public.creators (user_id) values ('<your account ID>');
-- ---------------------------------------------------------------
create table if not exists public.creators (
  user_id uuid primary key references auth.users(id) on delete cascade
);
alter table public.creators enable row level security;   -- no policies: not readable through the app

create or replace function public.is_creator() returns boolean
language sql stable security definer set search_path = '' as $$
  select exists (select 1 from public.creators c where c.user_id = (select auth.uid()));
$$;

create table if not exists public.beta_notes (
  id         text primary key,
  kind       text not null default 'bug',
  place      text not null default '',
  text       text not null,
  at         date not null default current_date,
  done       boolean not null default false,
  imp        smallint not null default 2,
  updated_at timestamptz not null default now()
);
alter table public.beta_notes enable row level security;
drop policy if exists "beta: read"   on public.beta_notes;
drop policy if exists "beta: insert" on public.beta_notes;
drop policy if exists "beta: update" on public.beta_notes;
drop policy if exists "beta: delete" on public.beta_notes;
create policy "beta: read"   on public.beta_notes for select using (not done or public.is_creator());
create policy "beta: insert" on public.beta_notes for insert with check (public.is_creator());
create policy "beta: update" on public.beta_notes for update using (public.is_creator()) with check (public.is_creator());
create policy "beta: delete" on public.beta_notes for delete using (public.is_creator());
grant select on public.beta_notes to anon, authenticated;
grant insert, update, delete on public.beta_notes to authenticated;
