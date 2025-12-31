# xrun

### Inspired by [@vraravam](https://github.com/vraravam)'s [run_all.sh](https://github.com/vraravam/git_scripts?tab=readme-ov-file#run_allsh)

A command-line tool to traverse directories at a specified depth and run any command in each directory.

## Features

- Execute any command across multiple directories
- Control traversal depth (default: 1 level)
- Specify custom starting directory
- Error handling: failures in one directory won't block others
- Provides a summary of successful and failed operations
- Displays relative paths for easy identification

## Installation

### 1. Navigate to the xrun Directory

```bash
cd scripts/xrun
```

### 2. Run the Setup Script

Execute the setup script to make the command executable and install it globally:

```bash
sh setup.sh
```

This will:

- Make the script executable
- Create a symbolic link in `/usr/local/bin` for global access

## Usage

### Basic Usage

Run a command in all immediate subdirectories (depth 1):

```bash
xrun "git status"
```

### Specify Depth

Traverse deeper into the directory tree:

```bash
xrun --depth 2 "npm test"
xrun -d 3 "ls -la"
```

### Specify Starting Directory

Start from a different directory:

```bash
xrun --path ~/projects "git pull"
xrun -p ~/workspace -d 2 "git status"
```

### Combined Options

```bash
xrun -d 2 -p ~/workspace "git fetch --all"
```

## Options

| Option    | Short | Description               | Default                 |
| --------- | ----- | ------------------------- | ----------------------- |
| `--depth` | `-d`  | Maximum depth to traverse | 1                       |
| `--path`  | `-p`  | Starting directory        | Current directory (`.`) |
| `--help`  | `-h`  | Show help message         | -                       |

## Examples

### Check Git Status Across Projects

```bash
cd ~/projects
xrun "git status"
```

### Run Tests in All Packages

```bash
xrun -d 2 "npm test"
```

### List Contents of Nested Directories

```bash
xrun --depth 3 --path ~/workspace "ls -la"
```

### Update All Git Repositories

```bash
xrun -d 2 "git pull --rebase"
```

### Check Node Versions

```bash
xrun "node --version"
```

## How It Works

1. **Traversal**: The tool starts from the specified directory (or current directory) and traverses subdirectories up to the specified depth
2. **Execution**: For each directory found, it changes into that directory and executes the specified command
3. **Results**: It tracks successful and failed executions and provides a summary at the end
4. **Error Handling**: If a command fails in one directory, it continues processing other directories

## Depth Explanation

- **Depth 1** (default): Only immediate subdirectories
- **Depth 2**: Subdirectories and their subdirectories
- **Depth 3**: Three levels deep
- And so on...

## Tips

- Use quotes around commands with spaces or special characters: `xrun "npm run build"`
- Commands are executed in the context of each directory, so relative paths work as expected
- The tool shows relative paths to help you identify which directory is being processed
- Check the summary at the end to see if any commands failed

## Troubleshooting

### Command Not Found

If you get "command not found" after installation, try:

```bash
# Refresh your shell
source ~/.zshrc
# Or open a new terminal window
```

### Permission Denied

If the setup script fails, ensure you have sudo privileges:

```bash
sudo sh setup.sh
```

## Uninstallation

To remove xrun:

```bash
sudo rm /usr/local/bin/xrun
```
