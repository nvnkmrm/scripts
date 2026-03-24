# Git Pull Rebase All

A command-line tool to traverse directories (with configurable depth) and automatically update ALL local branches in every git repository found by rebasing them onto their upstream tracking branches.

## Features

- Recursively discovers git repositories up to a configurable depth (`-maxD`)
- Optionally skip shallow levels with `-minD` to target nested repos
- Updates **all local branches** (not just the current branch) by rebasing onto their upstream
- Fetches from all remotes before updating
- Automatically stashes uncommitted changes and restores them after updates
- Returns to the originally checked-out branch after updating all branches
- Error handling: failures in one repository won't block others
- Provides detailed summary of operations per repository

## Installation

### 1. Clone the Repository

```bash
git clone git@github.com:nvnkmrm/scripts.git
```

### 2. Navigate to the git-pull-rebase-all Directory

```bash
cd scripts/git-pull-rebase-all
```

### 3. Run the Setup Script

Execute the setup script to make the command executable and optionally install it globally:

```bash
sh setup.sh
```

This will:

- Make the script executable
- Create symbolic links in `/usr/local/bin` for global access
- Create an alias named `pull-all` for easier usage

## Usage

```
git-pull-rebase-all [OPTIONS] [directory]
```

| Option               | Description                               | Default           |
| -------------------- | ----------------------------------------- | ----------------- |
| `-minD <n>`          | Minimum depth to start scanning for repos | `1`               |
| `-maxD <n>`          | Maximum depth to traverse                 | `1`               |
| `-p`, `--path <dir>` | Starting directory                        | current directory |
| `-h`, `--help`       | Show help message                         | —                 |

### Basic Usage (Current Directory)

Run the command in a directory containing multiple git repositories:

```bash
git-pull-rebase-all
```

Or using the short alias:

```bash
pull-all
```

### Specify a Target Directory

```bash
git-pull-rebase-all ~/projects
# or
git-pull-rebase-all -p ~/projects
```

### Traverse Nested Directories

Scan up to 3 levels deep:

```bash
git-pull-rebase-all -maxD 3
git-pull-rebase-all -maxD 3 ~/projects
```

Skip the top level and only process repos at depth 2 and below:

```bash
git-pull-rebase-all -minD 2 -maxD 3
```

> **Note:** If only `-minD` is provided, `-maxD` defaults to match it.

## Example Output

```
Scanning for git repositories in: .
Depth range: 1 - 2
================================================

[project-1]
  ⚠ Unstaged changes detected, stashing...
  ↓ Fetching from remotes...
  → Updating branch: feature1
    ✓ Rebased feature1 onto origin/feature1
  → Updating branch: main
    ✓ Rebased main onto origin/main
  → Updating branch: feature2
    ✓ Rebased feature2 onto origin/feature2
  ← Returned to branch: main
  ↻ Restoring stashed changes...
  ✓ Stashed changes restored
  ✓ Repository update complete (3 updated, 0 without upstream)

[project-2]
  ↓ Fetching from remotes...
  → Updating branch: develop
    ✓ Rebased develop onto origin/develop
  → Updating branch: main
    ✓ Rebased main onto origin/main
  ← Returned to branch: develop
  ✓ Repository update complete (2 updated, 1 without upstream)

[project-3]
  ✗ Failed to fetch from remotes

================================================
Summary:
  Total repositories found: 3
  Successful: 2
  Failed: 1
```

## How It Works

1. The script traverses subdirectories recursively from the target directory, up to `-maxD` levels deep
2. Directories shallower than `-minD` are descended into but not processed for repos
3. For each directory at or beyond `--minD` that contains a `.git` folder, it:
   - Saves the current branch name
   - Stashes any uncommitted changes (if present)
   - Fetches from all remotes
   - Identifies all local branches with upstream tracking branches
   - For each tracked branch:
     - Checks out the branch
     - Rebases it onto its upstream (e.g., `origin/main`)
   - Returns to the original branch
   - Restores stashed changes (if any)
4. If an error occurs, it logs the failure and continues with the next repository
5. Finally, it provides a summary of all operations

## Troubleshooting

### Permission Denied

If you get a "permission denied" error, make sure the script is executable:

```bash
chmod +x git-pull-rebase-all
```

### Script Not Found

If the command is not found after installation, make sure `/usr/local/bin` is in your PATH:

```bash
echo $PATH
```

If not, add this to your `~/.zshrc` or `~/.bashrc`:

```bash
export PATH="/usr/local/bin:$PATH"
```
