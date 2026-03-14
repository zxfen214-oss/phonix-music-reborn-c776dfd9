-- Create songs table for admin-managed tracks
CREATE TABLE public.songs (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  title TEXT NOT NULL,
  artist TEXT NOT NULL,
  album TEXT,
  duration INTEGER DEFAULT 0,
  youtube_id TEXT,
  cover_url TEXT,
  lyrics_url TEXT,
  created_by UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Enable RLS
ALTER TABLE public.songs ENABLE ROW LEVEL SECURITY;

-- Everyone can view songs
CREATE POLICY "Anyone can view songs"
  ON public.songs FOR SELECT
  USING (true);

-- Only admins can insert songs
CREATE POLICY "Admins can insert songs"
  ON public.songs FOR INSERT
  WITH CHECK (public.has_role(auth.uid(), 'admin'));

-- Only admins can update songs
CREATE POLICY "Admins can update songs"
  ON public.songs FOR UPDATE
  USING (public.has_role(auth.uid(), 'admin'));

-- Only admins can delete songs
CREATE POLICY "Admins can delete songs"
  ON public.songs FOR DELETE
  USING (public.has_role(auth.uid(), 'admin'));

-- Create trigger for updated_at
CREATE TRIGGER update_songs_updated_at
  BEFORE UPDATE ON public.songs
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at_column();

-- Create storage bucket for song assets (covers and lyrics)
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'song-assets',
  'song-assets',
  true,
  10485760, -- 10MB
  ARRAY['image/jpeg', 'image/png', 'image/webp', 'image/gif', 'text/plain', 'application/octet-stream']
);

-- Storage policies for song-assets bucket
CREATE POLICY "Anyone can view song assets"
  ON storage.objects FOR SELECT
  USING (bucket_id = 'song-assets');

CREATE POLICY "Admins can upload song assets"
  ON storage.objects FOR INSERT
  WITH CHECK (bucket_id = 'song-assets' AND public.has_role(auth.uid(), 'admin'));

CREATE POLICY "Admins can update song assets"
  ON storage.objects FOR UPDATE
  USING (bucket_id = 'song-assets' AND public.has_role(auth.uid(), 'admin'));

CREATE POLICY "Admins can delete song assets"
  ON storage.objects FOR DELETE
  USING (bucket_id = 'song-assets' AND public.has_role(auth.uid(), 'admin'));