# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Notes
- Remove trailing whitespace: Do not grep. Just run `sed -i '' 's/[[:space:]]*$//' FILE"`
- Always remove trailing whitespace when touching a file
- Ensure newline at EOF: Do not grep. Just run `test $(tail -c1 $FILE) && echo '' >> $FILE`
- Always ensure newline at EOF when touching a file
