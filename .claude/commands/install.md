# Install Grammar Check Hook

Install the Claude Code grammar checking hook that displays grammar feedback in the status line.

## Steps

### 1. Make Script Executable
```bash
chmod +x check_english_opencode.sh
```

### 2. Add Hook to Claude Settings

Add this to your `~/.claude/settings.json` in the hooks section:

```json
"UserPromptSubmit": [
  {
    "matcher": "",
    "hooks": [
      {
        "type": "command",
        "command": "/full/path/to/claude-code-grammar-hook/check_english_opencode.sh"
      }
    ]
  }
]
```

If you don't have a hooks section yet, create it:

```json
{
  "hooks": {
    "UserPromptSubmit": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "/full/path/to/claude-code-grammar-hook/check_english_opencode.sh"
          }
        ]
      }
    ]
  }
}
```

### 3. Setup Status Line

Run this statusline command to configure grammar display:

```
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

### 4. Create Grammar Directory

```bash
mkdir -p ~/.claude/english-fix
```

## Verification

After setup, your status line should show:
- `➜ project-name` (normal)
- `➜ project-name Grammar: errors here` (when grammar issues found)
- `➜ project-name Grammar: OK` (when no errors)

The hook will check your prompts in the background and display feedback without blocking your workflow.