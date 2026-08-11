# GitHub Pages Deployment for docs.wolfssl.com

This document explains the GitHub Pages deployment setup for wolfSSL documentation.

## Overview

The wolfSSL documentation is automatically built and deployed to `docs.wolfssl.com` using GitHub Pages. Each product manual is built using MkDocs (via Docker) and deployed to its own subdirectory.

## Architecture

- **Repository:** `wolfSSL/documentation`
- **Branch:** `master`
- **Deployment:** GitHub Pages (automatic on push to master)
- **Custom domain:** `docs.wolfssl.com`
- **Build system:** Docker + MkDocs + Doxygen + Doxybook2

## Site Structure

```
docs.wolfssl.com/
├── index.html                  # Landing page with product links
├── wolfssl/                    # wolfSSL Embedded SSL/TLS Library
│   ├── index.html
│   └── wolfSSL-Manual.pdf
├── wolfssh/                    # wolfSSH Lightweight SSH
│   ├── index.html
│   └── wolfSSH-Manual.pdf
├── wolftpm/                    # wolfTPM 2.0 Library
│   ├── index.html
│   └── wolfTPM-Manual.pdf
├── wolfmqtt/                   # wolfMQTT Client Library
├── wolfboot/                   # wolfBoot Secure Bootloader
├── wolfsentry/                 # wolfSentry Firewall Engine
├── wolfhsm/                    # wolfHSM Hardware Security Module
├── wolfengine/                 # wolfEngine OpenSSL Engine
├── wolfprovider/               # wolfProvider OpenSSL 3.0 Provider
├── wolfclu/                    # wolfCLU Command Line Utility
├── wolfssl-jni/                # wolfSSL JNI/JSSE Java Wrapper
├── wolfcrypt-jni/              # wolfCrypt JNI/JCE Java Wrapper
├── wolfssl-porting/            # Porting Guide
├── wolfssl-tuning/             # Tuning Guide
├── wolfssl-faq/                # FAQ
├── wolfssl-fips-ready/         # FIPS Ready Guide
├── wolfssl-fips-faq/           # FIPS FAQ
└── bouncycastle-migration/     # BouncyCastle Migration Guide
```

## Workflow

The deployment is handled by `.github/workflows/deploy-github-pages.yml`:

1. **Trigger:** Push to `master` branch or manual workflow dispatch
2. **Build:** Runs `make all` using Docker to build all manuals
3. **Structure:** Creates `_site/` directory with organized manual subdirectories
4. **Landing page:** Generates `index.html` with links to all manuals
5. **Deploy:** Uploads to GitHub Pages

## DNS Configuration

**Required DNS records:**

```
docs.wolfssl.com
  A     185.199.108.153
  A     185.199.109.153
  A     185.199.110.153
  A     185.199.111.153
```

## GitHub Pages Settings

**Repository Settings → Pages:**
1. **Source:** GitHub Actions
2. **Custom domain:** `docs.wolfssl.com`
3. **Enforce HTTPS:** ✓ (enabled)

## Build Time

- **Full build:** ~15-20 minutes (all 18 manuals)
- **Single manual:** ~1-2 minutes
- **Deploy time:** ~1 minute

## Adding a New Manual

To add a new product manual:

1. Create directory: `mkdir newProduct`
2. Add MkDocs config: `newProduct/mkdocs.yml`
3. Add source markdown: `newProduct/src/`
4. Add to Makefile:
   ```makefile
   .PHONY: newproduct
   newproduct: MANPATH=newProduct
   newproduct: PDFFILE=newProduct-Manual.pdf
   newproduct: build
       $(Q)$(DOCKER_CMD)
   ```
5. Add to workflow `.github/workflows/deploy-github-pages.yml`:
   - Add to manual list in "Create site structure" step
6. Add card to landing page `index.html` template
7. Commit and push - auto-deploys

## Local Testing

**Test build locally:**

```bash
# Build all manuals
make all

# Build single manual
make wolfssl

# Output is in build/ directory
ls -la build/wolfSSL/html/
```

**Preview locally:**

```bash
# Serve wolfSSL manual on http://localhost:8000
cd wolfSSL && make serve
```

## Comparison to WordPress VM

### Before (WordPress VM)

- **Location:** `/var/www/html/documentation/`
- **Build:** Manual FTP upload after local build
- **Updates:** Manual process
- **Security:** VM to patch, Apache to maintain
- **Cost:** $50-100/month (part of VM)
- **Deployment:** Manual (FTP to VM)

### After (GitHub Pages)

- **Location:** GitHub Pages CDN
- **Build:** Automatic on git push
- **Updates:** Push to GitHub = auto-deploy
- **Security:** No VM, static files only
- **Cost:** $0
- **Deployment:** Automatic CI/CD

## Advantages Over WordPress VM Deployment

**Security:**
- No server to compromise
- No PHP execution
- No database
- Static HTML only
- Automatic HTTPS

**Performance:**
- CDN edge caching
- No database queries
- Pre-built HTML
- Faster page loads

**Developer Experience:**
- Git-based workflow
- PR reviews for doc changes
- Version controlled
- CI tests on every PR
- Auto-deploy on merge

**Reliability:**
- No VM to crash
- No manual FTP
- GitHub's 99.95% SLA
- No "forgot to upload" mistakes

**Cost:**
- $0 hosting
- $0 maintenance
- No VM fees

## Migration from WordPress VM

**Current state:**
- WordPress VM hosts docs at `wolfssl.com/documentation/manuals/`
- Manual builds uploaded via FTP
- PDFs in root `/documentation/` directory

**After migration:**
- DNS points to GitHub Pages
- Auto-builds and deploys
- All manuals available at `docs.wolfssl.com/<product>/`
- PDFs available at `docs.wolfssl.com/<product>/<Product>-Manual.pdf`

**Cutover plan:**
1. ✓ Create GitHub Pages deployment workflow
2. ✓ Configure DNS for `docs.wolfssl.com`
3. ✓ Enable GitHub Pages in repo settings
4. Test docs.wolfssl.com (wait for DNS propagation)
5. Update links from `wolfssl.com/documentation/manuals/` to `docs.wolfssl.com/`
6. After 30 days: remove docs from WordPress VM

**Rollback plan:**
- Keep WordPress VM running for 30 days
- If issues: revert DNS to WordPress VM
- Documentation continues serving from old location

## Maintenance

**Regular tasks:**
- **None** - Fully automated

**When product releases:**
- Update manual source in `<product>/src/`
- Commit and push to master
- GitHub Actions auto-builds and deploys
- Takes ~20 minutes from push to live

**When adding features:**
- Update markdown in manual source
- PR review process
- Merge to master = auto-deploy

## Access Control

**Who can deploy:**
- Anyone with write access to `wolfSSL/documentation` repo
- Deployment triggered by push to `master` branch
- PRs build and test but don't deploy

**Who can approve PRs:**
- Repository maintainers
- CODEOWNERS (if configured)

## Monitoring

**Check deployment status:**
- GitHub Actions: https://github.com/wolfSSL/documentation/actions
- GitHub Pages status: Repository Settings → Pages

**Check site:**
- https://docs.wolfssl.com/
- https://docs.wolfssl.com/wolfssl/
- Check that PDFs load: https://docs.wolfssl.com/wolfssl/wolfSSL-Manual.pdf

## Troubleshooting

**Build fails:**
- Check GitHub Actions logs
- Common issues:
  - Syntax error in mkdocs.yml
  - Missing source files
  - Docker build timeout

**Site not updating:**
- Check DNS propagation (15 minutes after change)
- Check GitHub Actions completed successfully
- Clear browser cache
- Check CNAME file is correct

**404 errors:**
- Verify path matches directory structure
- Check file was included in build output
- Verify GitHub Pages is enabled

**SSL certificate issues:**
- GitHub auto-provisions Let's Encrypt cert
- Wait 24 hours after DNS setup
- Check "Enforce HTTPS" is enabled

## Future Enhancements

**Considered:**
- Versioned docs (e.g., `docs.wolfssl.com/wolfssl/5.7/`)
- Search functionality (Algolia DocSearch)
- Contribution guidelines for docs
- Automated link checking
- Broken link detection
- Dark mode theme

## Questions?

Contact Mark Atwood or refer to:
- GitHub Pages docs: https://docs.github.com/en/pages
- MkDocs documentation: https://www.mkdocs.org/
- Repository README: https://github.com/wolfSSL/documentation/blob/master/README.md
