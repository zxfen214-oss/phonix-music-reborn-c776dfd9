
-- Drop all existing restrictive policies on user_song_library
DROP POLICY IF EXISTS "Admins can view all library entries" ON public.user_song_library;
DROP POLICY IF EXISTS "Users can delete own library entries" ON public.user_song_library;
DROP POLICY IF EXISTS "Users can insert own library entries" ON public.user_song_library;
DROP POLICY IF EXISTS "Users can view own library" ON public.user_song_library;

-- Recreate as PERMISSIVE policies
CREATE POLICY "Users can view own library"
  ON public.user_song_library
  FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Admins can view all library entries"
  ON public.user_song_library
  FOR SELECT
  TO authenticated
  USING (public.has_role(auth.uid(), 'admin'::app_role));

CREATE POLICY "Users can insert own library entries"
  ON public.user_song_library
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own library entries"
  ON public.user_song_library
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own library entries"
  ON public.user_song_library
  FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);
