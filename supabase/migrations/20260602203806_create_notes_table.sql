/*
  # Create notes table for Mural de Notas

  1. New Tables
    - `notes`
      - `id` (uuid, primary key) - unique identifier
      - `color` (text) - note color key (yellow, slate, olive, rust, charcoal)
      - `text` (text) - note body content
      - `category` (text) - note category label
      - `note_date` (text) - display date string (e.g. "02/JUN")
      - `position` (integer) - order of the note on the board
      - `created_at` (timestamptz) - creation timestamp
      - `updated_at` (timestamptz) - last update timestamp

  2. Security
    - Enable RLS on `notes` table
    - Public read/write policy so unauthenticated users can manage notes on shared board
    - Notes are global (shared mural) - no user ownership needed
*/

CREATE TABLE IF NOT EXISTS notes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  color text NOT NULL DEFAULT 'yellow',
  text text NOT NULL DEFAULT '',
  category text NOT NULL DEFAULT '',
  note_date text NOT NULL DEFAULT '',
  position integer NOT NULL DEFAULT 0,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE notes ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can read notes"
  ON notes FOR SELECT
  TO anon, authenticated
  USING (true);

CREATE POLICY "Anyone can insert notes"
  ON notes FOR INSERT
  TO anon, authenticated
  WITH CHECK (true);

CREATE POLICY "Anyone can update notes"
  ON notes FOR UPDATE
  TO anon, authenticated
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Anyone can delete notes"
  ON notes FOR DELETE
  TO anon, authenticated
  USING (true);

CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER notes_updated_at
  BEFORE UPDATE ON notes
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();
