#!/usr/bin/env bash

# Create or overwrite sprint.md
echo "# Sprints Overview" > sprint.md
echo "" >> sprint.md

for FILE in sprint/*.md; do
    # Extract frontmatter fields using yq
    SPRINT_NUMBER=$(yq --front-matter=extract e '.sprint' "$FILE")
    START_DATE=$(yq --front-matter=extract e '.start_date' "$FILE")
    END_DATE=$(yq --front-matter=extract e '.end_date' "$FILE")
    GOAL=$(yq --front-matter=extract e '.goal' "$FILE")
    STATUS=$(yq --front-matter=extract e '.status' "$FILE")

    # If status is missing or null, default to "Open"
    if [ "$STATUS" = "null" ] || [ -z "$STATUS" ]; then
        STATUS="open"
    fi

    # Capitalize status
    STATUS_CAP="$(tr '[:lower:]' '[:upper:]' <<< "${STATUS:0:1}")${STATUS:1}"

    # If no sprint number found, skip this file
    if [ "$SPRINT_NUMBER" = "null" ] || [ -z "$SPRINT_NUMBER" ]; then
        continue
    fi

    # Print sprint summary
    echo "## [[sprint/$SPRINT_NUMBER.md|Sprint $SPRINT_NUMBER]]" >> sprint.md
    echo "- **Goal:** $GOAL" >> sprint.md
    echo "- **Status:** $STATUS_CAP" >> sprint.md
    echo "- **Dates:** $START_DATE - $END_DATE" >> sprint.md
    echo "" >> sprint.md
done

