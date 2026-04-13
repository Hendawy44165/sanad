-- Drop existing tables if they exist
DROP TABLE IF EXISTS events CASCADE;
DROP TABLE IF EXISTS services CASCADE;
DROP TABLE IF EXISTS news_items CASCADE;
DROP TABLE IF EXISTS doctors CASCADE;

-- Create Events Table
CREATE TABLE IF NOT EXISTS events (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    title TEXT NOT NULL,
    description TEXT,
    date DATE NOT NULL,
    time TEXT NOT NULL,
    location TEXT,
    organizer TEXT,
    category TEXT CHECK (category IN ('trip', 'gathering', 'workshop', 'sports')),
    accessibility_features TEXT[],
    image_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Create Services Table
CREATE TABLE IF NOT EXISTS services (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    title TEXT NOT NULL,
    description TEXT,
    provider TEXT NOT NULL,
    category TEXT CHECK (category IN ('transportation', 'companion', 'home-help', 'medical', 'other')),
    rating NUMERIC(2, 1) DEFAULT 0,
    reviews_count INTEGER DEFAULT 0,
    is_available BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Create News Items Table
CREATE TABLE IF NOT EXISTS news_items (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    title TEXT NOT NULL,
    summary TEXT,
    content TEXT,
    category TEXT CHECK (category IN ('achievement', 'government', 'community', 'health')),
    published_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    source TEXT,
    image_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Create Doctors Table
CREATE TABLE IF NOT EXISTS doctors (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT NOT NULL,
    specialty TEXT,
    hospital TEXT,
    rating NUMERIC(2, 1) DEFAULT 0,
    reviews_count INTEGER DEFAULT 0,
    is_available BOOLEAN DEFAULT true,
    languages TEXT[],
    image_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Seed Data: Events
INSERT INTO events (title, description, date, time, location, organizer, category, accessibility_features) VALUES
('Community Garden Day', 'Join us for accessible gardening activities and meet other community members.', '2025-02-05', '10:00 AM', 'Central Park', 'Ability Alliance', 'gathering', ARRAY['Wheelchair accessible', 'Sign language interpreter']),
('Adaptive Sports Workshop', 'Learn about various adaptive sports and try wheelchair basketball.', '2025-02-12', '2:00 PM', 'Sports Center', 'Paralympic Foundation', 'sports', ARRAY['Full accessibility', 'Equipment provided']),
('Beach Trip - Accessible Tour', 'Fully accessible beach trip with adapted vehicles and beach wheelchairs.', '2025-02-20', '9:00 AM', 'Sunny Beach Resort', 'Access Travel', 'trip', ARRAY['Beach wheelchairs', 'Accessible transport', 'Caregiver support']);

-- Seed Data: Services
INSERT INTO services (title, description, provider, category, rating, reviews_count, is_available) VALUES
('Accessible Transportation', 'Door-to-door transportation with wheelchair-accessible vehicles.', 'MobilityFirst', 'transportation', 4.8, 156, true),
('Shopping Companion', 'Friendly assistance for grocery shopping and errands.', 'Sarah M.', 'companion', 4.9, 89, true),
('Home Cleaning Service', 'Professional cleaning with understanding of accessibility needs.', 'CareClean', 'home-help', 4.7, 203, false);

-- Seed Data: News
INSERT INTO news_items (title, summary, content, category, published_at, source) VALUES
('Paralympic Athlete Wins Gold', 'Local athlete overcomes challenges to achieve international recognition at the Paralympic Games.', 'Full story content here...', 'achievement', '2025-01-28 10:00:00+00', 'Sports Daily'),
('New Accessibility Law', 'Government announces major investment in making all public transit wheelchair accessible by 2026.', 'Full story content here...', 'government', '2025-01-25 09:00:00+00', 'Policy News'),
('Community Center Opening', 'New facility offers free physical therapy sessions for people with disabilities.', 'Full story content here...', 'community', '2025-01-22 14:00:00+00', 'Local Times');

-- Seed Data: Doctors
INSERT INTO doctors (name, specialty, hospital, rating, reviews_count, is_available, languages) VALUES
('Dr. Emily Chen', 'Physical Medicine', 'City Medical Center', 4.9, 234, true, ARRAY['English', 'Mandarin']),
('Dr. James Wilson', 'Neurology', 'University Hospital', 4.8, 189, true, ARRAY['English', 'Spanish']),
('Dr. Amira Hassan', 'Rehabilitation', 'Hope Rehabilitation Center', 4.9, 312, false, ARRAY['English', 'Arabic', 'French']);