#!/bin/bash

# Read the JSON input from stdin
input=$(cat)

# Extract the session ID and prompt text
session_id=$(echo "$input" | jq -r '.session_id')
prompt_text=$(echo "$input" | jq -r '.prompt')

# Create the english-fix directory if it doesn't exist
mkdir -p ~/.claude/english-fix

# Create the grammar check prompt
grammar_prompt="Check the following text for grammar errors only. Ignore formatting, slang, casual language, capitalization of 'i', contractions like 'its/it's', and special characters/symbols (like |, *, etc). Do not suggest replacing symbols with words. If there are grammar mistakes, provide ONLY a concise summary like:
'Grammar: [brief issue] → [correction]'

If no grammar errors, respond with just 'No grammar errors found.'

Text to check:
\"$prompt_text\""

# Call opencode run which doesn't have hooks
response=$(echo "$grammar_prompt" | opencode run --model anthropic/claude-3-5-sonnet-20241022 2>&1)

# Clean up ANSI escape codes and duplicates
clean_response=$(echo "$response" | sed 's/\x1b\[[0-9;]*m//g' | awk '!seen[$0]++')

# Create the status file path in the english-fix folder
status_file="$HOME/.claude/english-fix/$session_id"

# Check if response is not empty and not an error
if [ -n "$clean_response" ] && ! echo "$clean_response" | grep -q "Error:"; then
    # Check if there are corrections (not the "No grammar errors" message)
    if ! echo "$clean_response" | grep -q "No grammar errors"; then
        # Extract all lines with corrections and combine them
        grammar_lines=$(echo "$clean_response" | grep "→" | sed 's/^- //' | sed 's/^Grammar: //' | sed 's/^[0-9]\+\. //' | paste -sd " " -)
        # Only write if we found actual grammar feedback
        if [ -n "$grammar_lines" ]; then
            echo "Grammar: $grammar_lines" > "$status_file"
        else
            # Remove the file if no meaningful feedback
            echo "Grammar(misformat): $clean_response" > "$status_file"
        fi
    else
        # No grammar errors found - write OK status
        echo "Grammar: Ok" > "$status_file"
    fi
else
    # If there's an error or no response, write a trimmed error message
    if echo "$clean_response" | grep -q "Error:"; then
        # Extract and trim error message
        error_msg=$(echo "$clean_response" | grep "Error:" | head -1 | cut -c1-50)
        echo "Grammar: [Error: $error_msg...]" > "$status_file"
    else
        # No response at all
        echo "Grammar: unknown" > "$status_file"
    fi
fi

# Always continue normally (don't block the user)
exit 0