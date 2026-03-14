-- Add lyrics_speed column to songs table
ALTER TABLE public.songs ADD COLUMN lyrics_speed numeric DEFAULT 0.75;

-- Create user_song_library table to track which users have which songs
CREATE TABLE public.user_song_library (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  song_youtube_id text NOT NULL,
  song_title text NOT NULL,
  song_artist text NOT NULL,
  added_at timestamp with time zone DEFAULT now() NOT NULL,
  UNIQUE(user_id, song_youtube_id)
);

-- Enable RLS
ALTER TABLE public.user_song_library ENABLE ROW LEVEL SECURITY;

-- Users can insert their own library entries
CREATE POLICY "Users can insert own library entries"
ON public.user_song_library FOR INSERT
WITH CHECK (auth.uid() = user_id);

-- Users can view their own library
CREATE POLICY "Users can view own library"
ON public.user_song_library FOR SELECT
USING (auth.uid() = user_id);

-- Users can delete their own library entries
CREATE POLICY "Users can delete own library entries"
ON public.user_song_library FOR DELETE
USING (auth.uid() = user_id);

-- Admins can view all library entries (to see which users have which songs)
CREATE POLICY "Admins can view all library entries"
ON public.user_song_library FOR SELECT
USING (has_role(auth.uid(), 'admin'));