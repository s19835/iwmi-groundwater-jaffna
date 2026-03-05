-- =============================================
-- IWMI Website CMS - Database Setup
-- =============================================

-- Content table: stores timeline, gallery, team data as JSON
CREATE TABLE IF NOT EXISTS public.site_content (
  section TEXT PRIMARY KEY,
  data JSONB NOT NULL DEFAULT '[]'::jsonb,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Enable Row Level Security
ALTER TABLE public.site_content ENABLE ROW LEVEL SECURITY;

-- Anyone can read content (public website)
CREATE POLICY "Public read access"
  ON public.site_content
  FOR SELECT
  USING (true);

-- Only the authorized CMS editor can modify content
CREATE POLICY "Editor can insert"
  ON public.site_content
  FOR INSERT
  WITH CHECK (auth.jwt() ->> 'email' = 'D.Sithara@cgiar.org');

CREATE POLICY "Editor can update"
  ON public.site_content
  FOR UPDATE
  USING (auth.jwt() ->> 'email' = 'D.Sithara@cgiar.org');

CREATE POLICY "Editor can delete"
  ON public.site_content
  FOR DELETE
  USING (auth.jwt() ->> 'email' = 'D.Sithara@cgiar.org');

-- Insert default empty rows for each section
INSERT INTO public.site_content (section, data) VALUES
  ('timeline', '[]'::jsonb),
  ('gallery', '[]'::jsonb),
  ('team', '[]'::jsonb)
ON CONFLICT (section) DO NOTHING;

-- =============================================
-- Storage bucket for CMS image uploads
-- =============================================
INSERT INTO storage.buckets (id, name, public)
VALUES ('cms-images', 'cms-images', true)
ON CONFLICT (id) DO NOTHING;

-- Anyone can view images (public bucket)
CREATE POLICY "Public image read"
  ON storage.objects
  FOR SELECT
  USING (bucket_id = 'cms-images');

-- Only the editor can upload images
CREATE POLICY "Editor can upload images"
  ON storage.objects
  FOR INSERT
  WITH CHECK (
    bucket_id = 'cms-images'
    AND auth.jwt() ->> 'email' = 'D.Sithara@cgiar.org'
  );

-- Editor can delete their uploads
CREATE POLICY "Editor can delete images"
  ON storage.objects
  FOR DELETE
  USING (
    bucket_id = 'cms-images'
    AND auth.jwt() ->> 'email' = 'D.Sithara@cgiar.org'
  );
