# Git Profile Switch (gps)

A simple command-line tool to quickly switch between different Git profiles (personal, work, etc.) by managing SSH keys and Git configuration.

## Installation

Follow these steps to install the `gps` command:

### 1. Clone the Repository

```bash
git clone git@github.com:nvnkmrm/nvnkmrm.github.io.git
```

### 2. Navigate to the git-profile-switch Directory

```bash
cd git-profile-switch
```

### 3. Configure Your Profiles

Edit the `git-profile-switch` script to configure your profiles. Modify the case statement to match your SSH keys, email addresses, and names:

```bash
case $PROFILE in
    personal)
        SSH_KEY="$HOME/.ssh/id_rsa"
        GIT_EMAIL="your.personal@email.com"
        GIT_NAME="Your Name"
        ;;
    work)
        SSH_KEY="$HOME/.ssh/work_key"
        GIT_EMAIL="your.work@email.com"
        GIT_NAME="Your Work Name"
        ;;
    *)
        echo "Error: Unknown profile '$PROFILE'"
        usage
        ;;
esac
```

**Important:** Make sure your SSH keys exist at the specified paths before proceeding.

### 4. Run the Setup Script

Execute the setup script to install `gps` command globally:

```bash
./setup.sh
```

This will:

- Make the `git-profile-switch` script executable
- Create a symlink in `/usr/local/bin` (requires sudo)
- Add the command to your PATH

## Usage

After installation, you can switch between profiles using:

```bash
gps <profile>
```

### Examples

Switch to personal profile:

```bash
gps personal
```

Switch to work profile:

```bash
gps work
```

### Output

When switching profiles, you'll see:

```
✓ SSH key switched
✓ Switched to personal profile
  Your Name <your.personal@email.com>
```

## What It Does

The `gps` command performs the following actions:

1. **Clears existing SSH keys** from the SSH agent
2. **Adds the specified SSH key** for the selected profile
3. **Updates Git global configuration**:
   - Sets `user.email`
   - Sets `user.name`
4. **Confirms the switch** with a success message

## Troubleshooting

### SSH Key Not Found

If you see "Error: SSH key not found at...", verify:

- The SSH key exists at the specified path
- The path in the `git-profile-switch` script is correct
- You have read permissions for the key

### Permission Denied

If the setup script fails, ensure:

- You have sudo access
- `/usr/local/bin` is writable or you have sudo permissions

### Command Not Found

If `gps` command is not found after installation:

- Check if `/usr/local/bin` is in your PATH: `echo $PATH`
- Restart your terminal or run: `source ~/.zshrc`

## Configuration Files Modified

This tool modifies:

- **SSH Agent**: Manages loaded SSH keys
- **Git Global Config** (`~/.gitconfig`): Updates `user.name` and `user.email`

## License

MIT
