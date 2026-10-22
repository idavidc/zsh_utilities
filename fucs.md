# Create an auto sync repo

 ```bash
   ~/.agents/skills/repo-init/scripts/repo-init.sh <name>
   ~/.agents/skills/repo-init/scripts/repo-init.sh --no-push <name>   # skip GitHub push
 ```

 What it does:
 1. Creates ~/repos/<name>/ with a minimal README.md
 2. git init -b main + initial commit
 3. gh repo create <name> --private --source . --remote origin --push