# Git Profile Switch (gps)

A simple command-line tool to quickly switch between different Git profiles (personal, work, etc.) by managing SSH keys and Git configuration.

## Installation

Follow these steps to install the `gps` command:

### 1. Clone the Repository

```bash
git clone git@github.com:nvnkmrm/scripts.git
```

### 2. Navigate to the git-profile-switch Directory

```bash
cd git-profile-switch
```

### 3. Configure Your Profiles

Edit `profiles.yaml` to define your profiles. Each profile needs a `name`, `ssh_key`, `email`, and `user_name`:

```yaml
profiles:
  - name: personal
    ssh_key: ~/.ssh/personal_rsa
    email: your.personal@email.com
    user_name: Your Name

  - name: work
    ssh_key: ~/.ssh/work_rsa
    email: your.work@email.com
    user_name: Your Work Name
```

You can add as many profiles as you need — no script modifications required.

**Important:** Make sure your SSH keys exist at the specified paths before proceeding.

> **Dependency:** The script uses [`yq`](https://github.com/mikefarah/yq) to parse the YAML file. If `yq` is not installed, the script will offer to install it automatically via Homebrew.

### 4. Run the Setup Script

Execute the setup script to install `gps` command globally:

```bash
./setup.sh
```

This will:

- Make the `git-profile-switch` script executable
- Create a symlink in `/usr/local/bin` (requires sudo)
- Add the command to your PATH
- Prompt you to choose a default profile for automatic switching:
  - **Option 1 (work)**: Automatically switches to work profile on new terminal sessions
  - **Option 2 (personal)**: Automatically switches to personal profile on new terminal sessions
  - **Option 3 (skip)**: Skip automatic profile switching (manual switching only)

## Usage

After installation, you can switch between profiles using:

```bash
gps <profile>
```

You can also run `gps` without arguments to show the current profile and active Git identity:

```bash
gps
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

Show current profile information:

```bash
gps
```

### Output

When switching profiles, you'll see:

```
✓ SSH key switched
✓ Switched to personal profile
  Your Name <your.personal@email.com>
```

When checking the current profile, you'll see:

```
Current profile: work
  Name:  Your Work Name
  Email: your.work@email.com

Available profiles: personal | work
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
- The `ssh_key` value in `profiles.yaml` is correct
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
