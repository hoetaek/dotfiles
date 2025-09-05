#!/bin/bash

# Launchpad Configuration Import Script

# Colors for output
BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

if [ ! -f "launchpad_backup.sql" ]; then
    echo -e "${RED}❌ launchpad_backup.sql not found${NC}"
    echo "Run export_launchpad.sh first to create a backup"
    exit 1
fi

# Find current Launchpad database
LAUNCHPAD_DB=$(find /private/var/folders -name "com.apple.dock.launchpad" -type d 2>/dev/null | head -1)

if [ -z "$LAUNCHPAD_DB" ]; then
    echo -e "${RED}❌ Could not find Launchpad database${NC}"
    exit 1
fi

DB_FILE="$LAUNCHPAD_DB/db/db"

echo -e "${BLUE}📱 Restoring Launchpad configuration...${NC}"
echo "Target database: $DB_FILE"

# Stop Dock to prevent conflicts
echo -e "${BLUE}🛑 Stopping Dock...${NC}"
killall Dock

# Wait a moment
sleep 2

# Backup current database
echo -e "${BLUE}💾 Backing up current Launchpad database...${NC}"
cp "$DB_FILE" "$DB_FILE.backup.$(date +%Y%m%d_%H%M%S)"

# Clear current database and restore from backup
echo -e "${BLUE}📥 Restoring database from backup...${NC}"
rm -f "$DB_FILE"
sqlite3 "$DB_FILE" < launchpad_backup.sql

echo -e "${BLUE}🚀 Restarting Dock...${NC}"
open /System/Applications/Launchpad.app

echo -e "${GREEN}✅ Launchpad configuration restored!${NC}"
echo -e "${BLUE}📱 Open Launchpad to see your folder structure${NC}"