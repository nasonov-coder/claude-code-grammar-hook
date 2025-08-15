# English Grammar Check Hook for Claude Code

Grammar checking hook for Claude Code that displays grammar feedback in the status line without blocking prompts.

## Setup

### 1. Add Hook to Claude Code Settings

Add to `~/.claude/settings.json`:

```json
{
  "hooks": {
    "UserPromptSubmit": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "/Users/dmitry/projects/learning-eng-prompts-hook/check_english_opencode.sh"
          }
        ]
      }
    ]
  },
  "statusLine": {
    "type": "command",
    "command": "input=$(cat); session_id=\"$(echo \"$input\" | jq -r '.session_id')\"; cwd=\"$(echo \"$input\" | jq -r '.workspace.current_dir')\"; english_fix=\"$HOME/.claude/english-fix/$session_id\"; if [ -f \"$english_fix\" ]; then grammar_status=\"$(cat \"$english_fix\")\"; printf '\\033[1;32m➜\\033[0m \\033[36m%s\\033[0m \\033[33m%s\\033[0m' \"$(basename \"$cwd\")\" \"$grammar_status\"; else printf '\\033[1;32m➜\\033[0m \\033[36m%s\\033[0m' \"$(basename \"$cwd\")\"; fi"
  }
}
```

### 2. Make Script Executable

```bash
chmod +x check_english_opencode.sh
```

## How It Works

1. **Non-blocking**: Runs in background after you submit prompts
2. **Grammar Check**: Uses OpenCode with Claude Sonnet to check grammar
3. **Status Display**: Shows results in Claude Code status line
4. **Session-specific**: Each session gets its own grammar feedback file

## Features

- ✅ Shows all grammar errors in status line
- ✅ Displays "Grammar: OK" when no errors
- ✅ Ignores formatting, slang, incomplete sentences
- ✅ Ignores capitalization of 'i' and contractions
- ✅ Ignores special characters/symbols
- ✅ Non-blocking - doesn't interrupt your workflow
- ✅ Session-specific feedback in `~/.claude/english-fix/`

## Status Line Display

- **Green arrow (➜)** + **Cyan directory name**: Normal status
- **+ Yellow grammar text**: When errors are found
- **Grammar: OK**: When no errors detected
- **Grammar: [Error: ...]**: When OpenCode API fails

## Example Output

```
➜ my-project Grammar: "goed" → "went" "buyed" → "bought" "don't likes" → "doesn't like"
```

## Files

- `check_english_opencode.sh`: Main grammar checking script
- `~/.claude/english-fix/{session_id}`: Grammar feedback files (auto-created)
- `~/.claude/settings.json`: Claude Code configuration