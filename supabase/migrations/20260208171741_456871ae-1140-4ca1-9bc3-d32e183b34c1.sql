
-- Add audio_url column to songs table for storing MP3 file URLs
ALTER TABLE public.songs 
ADD COLUMN audio_url TEXT;

-- Add index for faster lookups
CREATE INDEX idx_songs_audio_url ON public.songs(audio_url) WHERE audio_url IS NOT NULL;
