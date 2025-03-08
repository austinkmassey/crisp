#!/usr/bin/env bash

# Define the priorities and the headings
PRIORITIES=("must_have" "should_have" "could_have" "wont_have")

# Function to convert priorities to readable headings
heading_for_priority() {
    local p=$1
    echo "$p" | sed 's/_/ /g' | sed 's/\b\(.\)/\u\1/g'
}

# Function to extract and format backlog information
extract_backlog_info() {
    local FILE="$1"
    local PRIORITY=$(yq --front-matter=extract e '.priority' "$FILE")
    local STATUS=$(yq --front-matter=extract e '.status' "$FILE")
    local TITLE=$(yq --front-matter=extract e '.title' "$FILE")
    local SPRINT=$(yq --front-matter=extract e '.sprint' "$FILE")
    local FILENAME=$(basename "$FILE")

    # If title is missing, use filename without extension
    [ "$TITLE" = "null" ] || [ -z "$TITLE" ] && TITLE="${FILENAME%.md}"

    # Capitalize the first letter of the status
    STATUS_CAP="$(tr '[:lower:]' '[:upper:]' <<< "${STATUS:0:1}")${STATUS:1}"

    # Format the backlog entry
    echo "- [${STATUS_CAP}] $SPRINT [[backlog/$FILENAME|$TITLE]]"
}

# Store existing backlog entries
declare -A BACKLOG_ENTRIES

# Read the existing backlog.md if present
if [[ -f "backlog.md" ]]; then
    CURRENT_PRIORITY=""
    while IFS= read -r LINE; do
        if [[ $LINE =~ ^##\ (.+) ]]; then
            CURRENT_PRIORITY=$(echo "${BASH_REMATCH[1]}" | tr '[:upper:]' '[:lower:]' | sed 's/ /_/g')
        elif [[ $LINE =~ ^- ]]; then
            BACKLOG_ENTRIES["$CURRENT_PRIORITY"]+="$LINE"$'\n'
        fi
    done < "backlog.md"
fi

# Update with changed/new files
for FILE in "$@"; do
    FILE_PRIORITY=$(yq --front-matter=extract e '.priority' "$FILE")

    # Skip files with no priority
    [ -z "$FILE_PRIORITY" ] || [ "$FILE_PRIORITY" = "null" ] && continue

    # Extract formatted information
    BACKLOG_ENTRIES["$FILE_PRIORITY"]+="$(extract_backlog_info "$FILE")"$'\n'
done

# Write the updated backlog.md
echo "# Backlog" > backlog.md
echo "" >> backlog.md

for PRIORITY in "${PRIORITIES[@]}"; do
    HEADING=$(heading_for_priority "$PRIORITY")
    echo "## $HEADING" >> backlog.md
    echo "" >> backlog.md
    echo "${BACKLOG_ENTRIES[$PRIORITY]}" >> backlog.md
    echo "" >> backlog.md
done

