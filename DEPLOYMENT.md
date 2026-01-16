# Deployment Guide - HubSpot Dynamic Quote Theme

This guide explains how to safely deploy the dynamic quote theme to HubSpot without accidentally overriding existing files.

## ⚠️ Important Safety Notes

**Yes, pushing/uploading WILL override existing files** if they have the same path in HubSpot Design Manager. This is why we've set up safety measures.

## Safety Measures in Place

### 1. `.hsignore` File
- Controls what files get uploaded to HubSpot
- Prevents README, config files, and other non-essential files from being uploaded
- Similar to `.gitignore` but for HubSpot uploads

### 2. CI/CD Workflow
- Only deploys from `main`/`master` branch
- Requires manual approval for production
- Shows what files will be uploaded before deploying

### 3. Safe Deployment Script
- Interactive script that shows what will be uploaded
- Asks for confirmation before proceeding
- Checks for existing files and warns about overwrites

## Deployment Methods

### Method 1: Manual Upload (Safest for First Time)

```bash
# 1. Review what will be uploaded
find themes/dynamic-quote-theme -type f

# 2. Upload to a test location first (recommended)
hs upload themes/dynamic-quote-theme themes/dynamic-quote-theme-test

# 3. Verify in HubSpot Design Manager
# 4. If everything looks good, upload to final location
hs upload themes/dynamic-quote-theme themes/dynamic-quote-theme
```

### Method 2: Using Safe Deployment Script

```bash
# Make script executable
chmod +x scripts/safe-deploy.sh

# Run the script
./scripts/safe-deploy.sh
```

### Method 3: CI/CD (Automated)

#### Setup (One-time)

1. **Add GitHub Secrets:**
   - Go to your GitHub repository
   - Settings → Secrets and variables → Actions
   - Add these secrets:
     - `HUBSPOT_PERSONAL_ACCESS_KEY`: Your HubSpot personal access key
     - `HUBSPOT_PORTAL_ID`: Your portal ID (48527516)
     - `HUBSPOT_PORTAL_NAME`: Your portal name (integral-services-gmb-h)

2. **Push to main branch:**
   ```bash
   git add .
   git commit -m "Add dynamic quote theme"
   git push origin main
   ```

3. **Monitor deployment:**
   - Go to Actions tab in GitHub
   - Watch the deployment workflow

#### Manual Trigger (for testing)

You can also trigger deployments manually:
- Go to Actions → Deploy to HubSpot → Run workflow
- Choose environment (staging/production)

## Best Practices

### 1. Test First
- Always test in a separate folder first: `themes/dynamic-quote-theme-test`
- Verify everything works before deploying to production path

### 2. Use Version Control
- Commit changes to git before deploying
- Use feature branches for development
- Only merge to main when ready to deploy

### 3. Backup Existing Files
If you're worried about overwriting:
```bash
# Fetch existing files from HubSpot first
hs fetch themes/dynamic-quote-theme themes/dynamic-quote-theme-backup
```

### 4. Check Before Deploying
```bash
# List what's currently in HubSpot
hs cms list themes/dynamic-quote-theme
```

## File Path Mapping

When you upload `themes/dynamic-quote-theme` to HubSpot, it will create:

```
HubSpot Design Manager:
└── themes/
    └── dynamic-quote-theme/
        ├── templates/
        │   └── dynamic-quote.html
        ├── styles/
        │   └── dynamic-quote.css
        └── imports/
            └── mock_data.html
```

**Important:** If files already exist at these paths, they WILL be overwritten.

## Rollback Plan

If something goes wrong:

1. **Fetch previous version from HubSpot** (if you have a backup):
   ```bash
   hs fetch themes/dynamic-quote-theme-backup themes/dynamic-quote-theme
   ```

2. **Or restore from git:**
   ```bash
   git checkout HEAD~1 -- themes/dynamic-quote-theme
   hs upload themes/dynamic-quote-theme themes/dynamic-quote-theme
   ```

3. **Or manually edit in HubSpot Design Manager**

## Troubleshooting

### Upload fails with authentication error
- Check your `hubspot.config.yml` has valid credentials
- For CI/CD, verify GitHub secrets are set correctly

### Files not appearing in Design Manager
- Check the upload path matches your folder structure
- Verify you have permissions to upload to that location
- Check HubSpot Design Manager → File Manager for the files

### Want to exclude certain files
- Add patterns to `.hsignore` file
- Files matching patterns won't be uploaded

## Questions?

- HubSpot CLI Docs: https://developers.hubspot.com/docs/cms/developer-reference/local-development-cli
- HubSpot Design Manager: https://app.hubspot.com/design-manager

<<<<<<< HEAD
=======


>>>>>>> a803340 (inital commit)
