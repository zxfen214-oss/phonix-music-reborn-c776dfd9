-- Add karaoke support columns to songs table
ALTER TABLE public.songs ADD COLUMN IF NOT EXISTS karaoke_enabled boolean NOT NULL DEFAULT false;
ALTER TABLE public.songs ADD COLUMN IF NOT EXISTS karaoke_data jsonb DEFAULT NULL;

-- karaoke_data structure example:
-- {
--   "words": [
--     { "word": "Hello", "startTime": 0.5, "endTime": 1.2 },
--     { "word": "world", "startTime": 1.3, "endTime": 2.0 }
--   ]
-- }

COMMENT ON COLUMN public.songs.karaoke_enabled IS 'Whether karaoke mode is enabled for this song';
COMMENT ON COLUMN public.songs.karaoke_data IS 'Word-by-word timing data for karaoke effect';