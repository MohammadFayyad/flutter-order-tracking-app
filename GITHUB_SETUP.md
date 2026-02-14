# 🚀 GitHub Setup Guide

This document provides step-by-step instructions for pushing this project to GitHub.

## ⚠️ IMPORTANT: Security Notice

**Before pushing to GitHub, you MUST remove sensitive files that are currently tracked in git.**

### Files to Remove from Git History

The following files contain sensitive data and should NOT be in version control:

1. **`android/app/google-services.json`** - Contains Firebase API keys
2. **Any `.env` files** - Contains Mapbox access tokens

## 📋 Pre-Push Checklist

### 1. Remove Sensitive Files from Git

Run these commands to remove sensitive files from git tracking:

```bash
# Remove google-services.json from git (but keep local copy)
git rm --cached android/app/google-services.json

# If you have a .env file, remove it too
git rm --cached .env

# Commit the removal
git commit -m "Remove sensitive files from version control"
```

### 2. Verify .gitignore

The `.gitignore` file has been updated to include:
- ✅ `.env` files
- ✅ `google-services.json`
- ✅ `GoogleService-Info.plist`
- ✅ Build artifacts
- ✅ IDE files

### 3. Verify No Hardcoded Secrets

✅ **Fixed**: Removed hardcoded Mapbox token from `AndroidManifest.xml`
✅ **Verified**: All API keys are loaded from environment variables
✅ **Verified**: Firebase config uses `firebase_options.dart` (auto-generated)

## 🔧 Setup Instructions for New Developers

When someone clones this repository, they need to:

### 1. Set up Environment Variables

```bash
# Copy the example file
cp .env.example .env

# Edit .env and add your Mapbox token
# MAPBOX_ACCESS_TOKEN=your_actual_token_here
```

### 2. Set up Firebase

```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase for your project
flutterfire configure
```

This will:
- Create `firebase_options.dart`
- Download `google-services.json` (Android)
- Download `GoogleService-Info.plist` (iOS)

### 3. Install Dependencies

```bash
flutter pub get
```

### 4. Run the App

```bash
flutter run
```

## 📤 Pushing to GitHub

### Option 1: Create New Repository

```bash
# Initialize git (if not already initialized)
git init

# Add all files
git add .

# Commit
git commit -m "Initial commit: Order tracking app with real-time GPS"

# Add remote repository
git remote add origin https://github.com/yourusername/order_tracking.git

# Push to GitHub
git branch -M main
git push -u origin main
```

### Option 2: Push to Existing Repository

```bash
# Add all changes
git add .

# Commit
git commit -m "Prepare project for GitHub"

# Push
git push origin main
```

## 🔒 Security Best Practices

### What's Safe to Commit

✅ Source code (`.dart` files)
✅ `pubspec.yaml`
✅ `.gitignore`
✅ `.env.example` (template only)
✅ `README.md`
✅ `firebase_options.dart` (uses environment variables)

### What Should NEVER be Committed

❌ `.env` (contains actual API keys)
❌ `google-services.json` (contains Firebase keys)
❌ `GoogleService-Info.plist` (contains Firebase keys)
❌ Any file with actual API keys or credentials

## 📝 Post-Push Tasks

After pushing to GitHub:

1. **Add Repository Description**
   - Go to your GitHub repository settings
   - Add a description: "Real-time order tracking app with GPS location tracking built with Flutter"

2. **Add Topics/Tags**
   - flutter
   - dart
   - firebase
   - mapbox
   - gps-tracking
   - real-time
   - order-tracking

3. **Enable Issues** (if you want bug reports/feature requests)

4. **Add a License** (if you haven't already)
   - MIT License is recommended for open source

5. **Update README.md**
   - Replace `yourusername` with your actual GitHub username in clone URL
   - Add screenshots if available

## 🎉 You're Done!

Your project is now ready to be shared on GitHub! 🚀

## 📞 Need Help?

If you encounter any issues:
1. Check that all sensitive files are in `.gitignore`
2. Verify no API keys are hardcoded in the code
3. Make sure `google-services.json` is removed from git tracking
4. Ensure `.env` file is not tracked by git

