drop table if exists medication_alarms;

create table medication_alarms (
  id uuid default gen_random_uuid() primary key,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  title text not null,
  dosage text,
  time text not null, -- Format "HH:mm"
  frequency text default 'Daily',
  is_active boolean default true,
  user_id uuid references auth.users not null -- Assuming row level security
);