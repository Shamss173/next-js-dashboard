#!/usr/bin/env bash
# Go to project root (works on Windows with Git Bash / WSL and most shells)
pushd "d:\NextJs\nextjs-dashboard" || { echo "Directory not found: d:\NextJs\nextjs-dashboard"; exit 1; }

# Set git user (edit or remove these lines if you already have global config)
git config user.name "Your Name"
git config user.email "you@example.com"

# Ensure .gitignore exists (overwrite/update as needed)
cat > .gitignore <<'EOF'
node_modules
.next
.env
.vscode
dist
npm-debug.log
yarn-error.log
.DS_Store
EOF

# Initialize repo if not already initialized
if [ ! -d .git ]; then
  git init
fi

# Ensure we have a sensible branch name (use main if none)
current_branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || true)"
if [ -z "$current_branch" ] || [ "$current_branch" = "HEAD" ]; then
  current_branch="main"
  git checkout -b "$current_branch" 2>/dev/null || git checkout "$current_branch" 2>/dev/null || true
fi

# Stage and commit only if there are changes
git add .
if git diff --cached --quiet && git diff --quiet; then
  echo "No changes to commit"
else
  git commit -m "Initial commit" || echo "Commit skipped (possibly no staged changes)"
fi

# Configure remote to your GitHub repo (HTTPS). Use SSH URL if you prefer.
REMOTE_URL="https://github.com/Shamss173/next-js-dashboard.git"
if git remote | grep -q '^origin$'; then
  git remote set-url origin "$REMOTE_URL"
else
  git remote add origin "$REMOTE_URL"
fi

# Check GitHub CLI auth (optional) and remind user to authenticate if needed
if command -v gh >/dev/null 2>&1; then
  if ! gh auth status >/dev/null 2>&1; then
    echo "gh CLI detected but not authenticated. Run: gh auth login OR ensure Git has valid credentials to push."
  fi
fi

# Push and set upstream (will prompt for credentials if necessary)
git push -u origin "$current_branch" || { echo "Push failed. Ensure you have permission and are authenticated."; exit 1; }

popd

# 1) Open terminal and go to project (example for Git Bash or WSL)
cd /d/NextJs/nextjs-dashboard

# 2) Authenticate if needed (recommended)
gh auth login
# or ensure Git credentials are set up (PAT or credential manager)

# 3) Run the script
bash push-commands.sh

# Alternative (make executable in WSL / Linux)
# chmod +x push-commands.sh && ./push-commands.sh

# 4) Quick checks
git remote -v
git status

# 5) If push failed due to auth, run:
# - gh auth login
# - or replace REMOTE_URL in the script with SSH and ensure SSH key is added to GitHub:
#    git remote set-url origin git@github.com:Shamss173/next-js-dashboard.git
# Then run: git push -u origin main
