#!/usr/bin/env bash

# This script reads the current sprint.md, updates or adds new sprints,
# and keeps existing ones that haven't changed, sorting them by sprint number.

SPRINT_MD="$1"
shift
SPRINT_FILES=("$@")

# Temporary storage for sprints
declare -A UPDATED_SPRINTS

# Function to extract and format sprint information
extract_sprint_info() {
    local FILE="$1"
    local SPRINT_NUMBER=$(yq --front-matter=extract e '.sprint' "$FILE")
    local START_DATE=$(yq --front-matter=extract e '.start_date' "$FILE")
    local END_DATE=$(yq --front-matter=extract e '.end_date' "$FILE")
    local GOAL=$(yq --front-matter=extract e '.goal' "$FILE")
    local STATUS=$(yq --front-matter=extract e '.status' "$FILE")

    # Default status if missing
    [ -z "$STATUS" ] || [ "$STATUS" = "null" ] && STATUS="open"

    # Capitalize the first letter of the status
    local STATUS_CAP
    STATUS_CAP="$(tr '[:lower:]' '[:upper:]' <<< "${STATUS:0:1}")${STATUS:1}"

    # Format sprint entry
    echo "## [[sprint/$SPRINT_NUMBER.md|Sprint $SPRINT_NUMBER]]"
    echo "- **Goal:** $GOAL"
    echo "- **Dates:** $START_DATE - $END_DATE"
    echo "- **Status:** $STATUS_CAP"
    echo ""
}

# Read the current sprint.md and store its contents
if [[ -f "$SPRINT_MD" ]]; then
    CURRENT_SPRINT=""
    while IFS= read -r LINE; do
        if [[ $LINE =~ ^##\ Sprint\ ([0-9]+) ]]; then
            CURRENT_SPRINT="${BASH_REMATCH[1]}"
            UPDATED_SPRINTS["$CURRENT_SPRINT"]=""
        fi
        UPDATED_SPRINTS["$CURRENT_SPRINT"]+="$LINE"$'\n'
    done < "$SPRINT_MD"
fi

# Update or add sprints from modified files
for FILE in "${SPRINT_FILES[@]}"; do
    SPRINT_NUMBER=$(yq --front-matter=extract e '.sprint' "$FILE")

    # Skip files with no sprint number
    if [ -z "$SPRINT_NUMBER" ] || [ "$SPRINT_NUMBER" = "null" ]; then
        continue
    fi

    # Extract and store sprint information
    UPDATED_SPRINTS["$SPRINT_NUMBER"]="$(extract_sprint_info "$FILE")"
done

# Print sorted sprints by sprint number
echo "# Sprints Overview"
echo ""

# Sort sprint numbers and print their corresponding data
for SPRINT_NUMBER in $(printf "%s\n" "${!UPDATED_SPRINTS[@]}" | sort -n); do
    echo "${UPDATED_SPRINTS[$SPRINT_NUMBER]}"
    echo ""
done

