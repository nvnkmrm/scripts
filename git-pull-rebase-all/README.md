# Git Pull Rebase All

A command-line tool to traverse all folders in a directory and automatically run `git pull --rebase` on every git repository found.

## Features

- Automatically discovers all git repositories in subdirectories
- Runs `git pull --rebase` on each repository
- Error handling: failures in one repository won't block others
- Provides a summary of successful and failed operations
- Optional: specify a target directory or use the current directory

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
./setup.sh
```

This will:

- Make the script executable
- Create symbolic links in `/usr/local/bin` for global access
- Create an alias named `pull-all` for easier usage

## Usage

### Basic Usage (Current Directory)

Run the command in a directory containing multiple git repositories:

```bash
git-pull-rebase-all
```

Or using the short alias:

```bash
pull-all
```

This will scan all subdirectories in the current directory and run `git pull --rebase` on each git repository found.

### Specify a Target Directory

You can also specify a target directory:

```bash
git-pull-rebase-all ~/projects
```

Or:

```bash
pull-all ~/projects
```

## Example Output

```
Scanning for git repositories in: .
================================================

[project-1]
Already up to date.
  ✓ Pull rebase successful

[project-2]
remote: Enumerating objects: 5, done.
remote: Counting objects: 100% (5/5), done.
Updating 1234567..abcdefg
Fast-forward
 file.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
  ✓ Pull rebase successful

[project-3]
fatal: unable to access 'https://...': Could not resolve host
  ✗ Pull rebase failed (continuing with other repos)

================================================
Summary:
  Total repositories found: 3
  Successful: 2
  Failed: 1
```

## Use Cases

- **Workspace Sync**: Keep all your projects up-to-date in one command
- **Morning Routine**: Update all repositories at the start of your workday
- **CI/CD**: Automate repository updates in build scripts
- **Team Workflows**: Ensure all project dependencies are current

## How It Works

1. The script traverses all immediate subdirectories of the target directory
2. For each subdirectory, it checks if a `.git` folder exists
3. If it's a git repository, it enters the directory and runs `git pull --rebase`
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

## License

MIT License - feel free to use and modify as needed.
