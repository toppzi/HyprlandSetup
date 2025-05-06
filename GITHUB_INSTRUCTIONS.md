# Instructions for Uploading to GitHub

Follow these step-by-step instructions to upload your Hyprland Easy Installer to GitHub.

## 1. Download the Project Files

First, download all the files from this Replit project:

1. Click on the three dots (...) next to any file in the file explorer
2. Select "Download as zip"
3. Extract the zip file on your computer

## 2. Create a New GitHub Repository

1. Go to [GitHub](https://github.com/) and log in to your account
2. Click on the "+" in the top-right corner and select "New repository"
3. Name your repository (e.g., "hyprland-easy-installer")
4. Add a description (optional): "A simple and customizable installer script for Hyprland window manager on Arch Linux"
5. Choose public or private repository
6. Do NOT initialize with README, .gitignore, or license (we already have these files)
7. Click "Create repository"

## 3. Upload via GitHub Web Interface (Option 1 - Easiest)

After creating the repository:

1. Click on "uploading an existing file" on the GitHub repository page
2. Drag and drop all the files from the extracted zip or click to browse and select them
3. Add a commit message like "Initial commit - Hyprland installer and configuration wizard"
4. Click "Commit changes"

## 4. Push via Git Command Line (Option 2 - For Git Users)

If you prefer using Git:

```bash
# Navigate to the directory where you extracted the zip
cd path/to/extracted/folder

# Initialize a new git repository
git init

# Add all files to be committed
git add .

# Commit the files
git commit -m "Initial commit - Hyprland installer and configuration wizard"

# Add your GitHub repository as a remote
git remote add origin https://github.com/YourUsername/hyprland-easy-installer.git

# Push the files to GitHub
git push -u origin main
```

Replace `YourUsername` with your actual GitHub username and `hyprland-easy-installer` with your repository name if different.

## 5. Verify the Repository

After uploading:

1. Refresh your GitHub repository page
2. Make sure all files have been properly uploaded, including:
   - `README.md`
   - `LICENSE`
   - `install_hyprland.sh`
   - `configure_hyprland.sh`
   - `config/` directory with all configuration files
   - `generated-icon.png` (project screenshot)
   - `.gitignore`

## 6. Update Repository Information (Optional)

You can further customize your GitHub repository:

1. Add topics to your repository (e.g., hyprland, arch-linux, wayland, installer)
2. Edit the repository description
3. Pin the repository to your profile if you want to highlight it

## 7. Share Your Repository

Now your Hyprland Easy Installer is available on GitHub! You can share the link with others:

```
https://github.com/YourUsername/hyprland-easy-installer
```

Remember to replace `YourUsername` with your actual GitHub username.

## Next Steps

Consider these additional steps to improve your project:

1. Create releases for stable versions
2. Set up GitHub Actions for automated checks
3. Add more documentation or Wiki pages
4. Accept contributions from others by setting up contribution guidelines