
ALTER TABLE public.songs
  ADD COLUMN IF NOT EXISTS needs_metadata boolean NOT NULL DEFAULT false,
  ADD COLUMN IF NOT EXISTS synced_lyrics text,
  ADD COLUMN IF NOT EXISTS plain_lyrics text;
