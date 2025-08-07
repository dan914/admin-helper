#!/bin/bash

# Make sure we're in the right directory
cd "$(dirname "$0")"

# Run Flutter with Supabase credentials
flutter run -d web-server --web-port 8080 \
  --dart-define=SUPABASE_URL=https://vgxewradmqwbkzckubpd.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZneGV3cmFkbXF3Ymt6Y2t1YnBkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzI5NDU0MTUsImV4cCI6MjA0ODUyMTQxNX0.0BTZ_DM5Pv7aVqlhvUhtSXDk0r91LsQZFdz5gOqRsik