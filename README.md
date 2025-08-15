# English Grammar Check Hook for Claude Code

Grammar checking hook for Claude Code that displays grammar feedback in the status line without blocking prompts.

## Setup

### 1. Add Hook to Claude Code Settings

Add hook using `/hooks` command in Claude Code:

```bash
/hooks
# Select: UserPromptSubmit  
# Command: /path/to/check_english_opencode.sh
```

Or manually add to `~/.claude/settings.json`:

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
  }
}
```

### 2. Configure Status Line

Run this command in Claude Code to set up the status line integration:

```bash
/statusline look at this project files. script will be called as hook after user message. so we would need to output this message to .claude/english-fix - one file per session. so it will be displayed at status line. also backup previous conf. and make @check_english_opencode.sh output more concise

UserPromptSubmit Input

{
  "session_id": "abc123",
  "transcript_path": "/Users/.../.claude/projects/.../00893aaf-19fa-41d2-8238-13269b9b3ca0.jsonl",
  "cwd": "/Users/...",
  "hook_event_name": "UserPromptSubmit",
  "prompt": "Write a function to calculate the factorial of a number"
}
```

### 3. Make Script Executable

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