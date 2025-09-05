#!/bin/bash

# Launchpad Configuration Export Script

# Find the current Launchpad database
LAUNCHPAD_DB=$(find /private/var/folders -name "com.apple.dock.launchpad" -type d 2>/dev/null | head -1)

if [ -z "$LAUNCHPAD_DB" ]; then
    echo "❌ Could not find Launchpad database"
    exit 1
fi

DB_FILE="$LAUNCHPAD_DB/db/db"

if [ ! -f "$DB_FILE" ]; then
    echo "❌ Launchpad database file not found: $DB_FILE"
    exit 1
fi

echo "📱 Exporting Launchpad configuration..."
echo "Database: $DB_FILE"

# Export current folder structure
sqlite3 "$DB_FILE" "
SELECT 'Folder: ' || title || ' (ID: ' || item_id || ')'
FROM groups 
WHERE title IS NOT NULL
ORDER BY title;
" > launchpad_folders.txt

# Export apps in folders
sqlite3 "$DB_FILE" "
SELECT 
    g.title as folder_name,
    a.title as app_name,
    a.bundleid
FROM items i
JOIN apps a ON i.rowid = a.item_id
JOIN groups g ON i.parent_id = g.item_id
WHERE g.title IS NOT NULL
ORDER BY g.title, a.title;
" > launchpad_apps_in_folders.txt

# Export complete structure as SQL dump
sqlite3 "$DB_FILE" ".dump" > launchpad_backup.sql

echo "✅ Launchpad configuration exported:"
echo "  - launchpad_folders.txt (folder list)"
echo "  - launchpad_apps_in_folders.txt (apps in folders)" 
echo "  - launchpad_backup.sql (complete database)"

echo ""
echo "Current folders:"
cat launchpad_folders.txt