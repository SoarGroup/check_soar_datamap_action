#!/bin/bash

# Parse the jsonlines output from the VisualSoar datamap check command and
# convert it to GitHub Actions annotations.

# Example input:
# {"message": "Operator node diagnostic", "severity": 1, "relatedInformation": [{"message": "could not match constraint (<anchor-arg2-object>,objet-handle,<anchor-arg2-object-handle>) in production", "location": {"uri": "file:///path/to/agent/anchor-relation-category.soar", "range": {"start": {"line": 16, "character": 0}, "end": {"line": 16, "character": 0}}}}], "source": "VisualSoar"}
# {"message": "Unable to check productions due to parse error", "severity": 1, "source": "VisualSoar"}
# {"message": "Operator node diagnostic", "severity": 1, "relatedInformation": [{"message": "parser.ParseException: Encountered \" <VARIABLE> \"<operator> \"\" at line 23, column 4.\nWas expecting:\n    \"-->\" ...\n    ", "location": {"uri": "file:///path/to/agent/clear-achieved-desireds.soar", "range": {"start": {"line": 23, "character": 0}, "end": {"line": 23, "character": 0}}}}], "source": "VisualSoar"}

# Example output:
# ::error file=/path/to/agent/anchor-relation-category.soar,line=16::"Operator node diagnostic" - "could not match constraint (<anchor-arg2-object>,objet-handle,<anchor-arg2-object-handle>) in production"
# ::error::"Unable to check productions due to parse error"
# ::error file=/path/to/agent/clear-achieved-desireds.soar,line=23::"Operator node diagnostic" - "parser.ParseException: Encountered \" <VARIABLE> \"<operator> \"\" at line 23, column 4.%0AWas expecting:%0A    \"-->\" ...%0A    "

while read -r diagnostic; do
    mainMessage=$(printf %s "$diagnostic" | jq '.message // empty' | sed 's/%/%25/g; s/\\n/%0A/g; s/\\r/%0D/g')

    if [[ -z "$mainMessage" ]]; then
        printf "Skipping malformed diagnostic: %s\n" "$diagnostic" >&2
        continue
    fi

    relatedExists=$(printf %s "$diagnostic" | jq -e '.relatedInformation? | type == "array"' 2>/dev/null || echo "false")

    if [[ "$relatedExists" == "true" ]]; then
        printf %s "$diagnostic" | jq -c '.relatedInformation[]' | jq -Rr . | while read -r related; do
            file=$(printf %s "$related" | jq -r '.location.uri // empty' | sed 's|file://||')
            line=$(printf %s "$related" | jq -r '.location.range.start.line // empty')
						message=$(printf %s "$related" | jq '.message // empty' | sed 's/%/%25/g; s/\\n/%0A/g; s/\\r/%0D/g')
            severity=$(printf %s "$diagnostic" | jq -r '.severity // 1')

            if [[ -z "$file" || -z "$line" || -z "$message" ]]; then
                printf "Skipping malformed related information: %s\n" "$related" >&2
                continue
            fi

            if [[ "$severity" -eq 2 ]]; then
                printf "::warning file=%s,line=%s::%s - %s\n" "$file" "$line" "$mainMessage" "$message"
            else
                printf "::error file=%s,line=%s::%s - %s\n" "$file" "$line" "$mainMessage" "$message"
            fi
        done
    else
        severity=$(printf %s "$diagnostic" | jq -r '.severity // 1')
        if [[ "$severity" -eq 2 ]]; then
            printf "::warning::%s\n" "$mainMessage"
        else
            printf "::error::%s\n" "$mainMessage"
        fi
    fi
done
