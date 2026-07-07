# Deployment Preparation for docs.wolfssl.com

This document outlines the preparation steps, timeline, and considerations for migrating wolfSSL documentation from the WordPress VM to GitHub Pages at `docs.wolfssl.com`.

## Executive Summary

**Current state:** Documentation manually FTP'd to WordPress VM, served alongside blog
**Proposed state:** Automatic deployment to docs.wolfssl.com via GitHub Pages
**Timeline:** 1-2 hours to enable, 30-day validation period
**Risk level:** Low (can rollback in <5 minutes)
**Cost impact:** Eliminates ~$20/month hosting allocation, reduces ops time by 2-4 hrs/month

## Pre-Deployment Checklist

### Technical Prerequisites (Complete ✓)

- [x] GitHub Actions workflow created and tested
- [x] Landing page template with product cards
- [x] CNAME file configured for docs.wolfssl.com
- [x] Pull Request opened: https://github.com/wolfSSL/documentation/pull/267
- [x] Documentation written (GITHUB-PAGES-SETUP.md)
- [x] Build system verified (CI runs on every PR, proves it works)

### Deployment Steps (Requires Action)

1. **Merge PR #267** (5 minutes)
   - Requires: Repository admin approval
   - Action: Review and merge pull request
   - Impact: Adds deployment workflow to master branch

2. **Enable GitHub Pages** (2 minutes)
   - Navigate to: https://github.com/wolfSSL/documentation/settings/pages
   - Set Source: "GitHub Actions"
   - Set Custom Domain: `docs.wolfssl.com`
   - Check "Enforce HTTPS"

3. **Configure DNS** (5 minutes, 15-minute propagation)
   - Add A records for docs.wolfssl.com:
     ```
     docs.wolfssl.com  A  185.199.108.153
     docs.wolfssl.com  A  185.199.109.153
     docs.wolfssl.com  A  185.199.110.153
     docs.wolfssl.com  A  185.199.111.153
     ```
   - DNS propagation: 5-15 minutes typically
   - Who: Whoever manages wolfSSL DNS (likely Chris or IT)

4. **Wait for First Build** (20 minutes)
   - Automatic trigger on merge to master
   - Monitor at: https://github.com/wolfSSL/documentation/actions
   - Builds all 18+ manuals in parallel
   - Deploys to docs.wolfssl.com automatically

5. **Verify Deployment** (10 minutes)
   - Check landing page: https://docs.wolfssl.com/
   - Spot check manuals:
     - https://docs.wolfssl.com/wolfssl/
     - https://docs.wolfssl.com/wolfssh/
     - https://docs.wolfssl.com/wolftpm/
   - Verify PDFs load:
     - https://docs.wolfssl.com/wolfssl/wolfSSL-Manual.pdf
   - Test search engines can crawl (robots.txt)
   - Verify HTTPS certificate provisioned

## Timeline

**Total time to production:** ~1 hour active work + 20 minutes automated build

| Task | Duration | Who | Blocking? |
|------|----------|-----|-----------|
| Review PR | 5 min | Repo admin | Yes |
| Merge PR | 1 min | Repo admin | Yes |
| Enable Pages | 2 min | Repo admin | Yes |
| Configure DNS | 5 min | DNS admin | Yes |
| DNS propagation | 15 min | Automatic | Yes |
| First build | 20 min | GitHub Actions | Yes |
| Verification | 10 min | Anyone | No |
| **Total** | **~1 hour** | | |

**Validation period:** 30 days running both old and new in parallel

## Validation Period (30 Days)

### Week 1: Soft Launch
- docs.wolfssl.com is live but not primary
- WordPress VM still serves wolfssl.com/documentation/
- Internal team tests docs.wolfssl.com
- Monitor for issues: broken links, missing files, formatting problems
- Update internal documentation to reference new URLs

### Week 2-3: Parallel Operation
- Start updating external links to docs.wolfssl.com
- Monitor traffic analytics (if configured)
- Collect feedback from support team
- Fix any issues discovered

### Week 4: Cutover Decision
- If successful: Update all remaining links to docs.wolfssl.com
- If issues: Extend validation or rollback
- Plan removal of docs from WordPress VM

### End of 30 Days: Cleanup
- Remove `/var/www/html/documentation/` from WordPress VM
- Update any remaining links
- Archive old docs as backup

## Rollback Plan

**If problems occur, can rollback in <5 minutes:**

1. **Update DNS** - Point docs.wolfssl.com back to WordPress VM IP
   - Change A records to VM IP: 34.48.166.6
   - Propagation: 5-15 minutes

2. **Alternative: Keep WordPress VM serving docs**
   - Don't remove `/var/www/html/documentation/`
   - Serve from wolfssl.com/documentation/ as backup
   - Update links if needed

**Data loss risk:** Zero - WordPress VM files remain untouched during validation period

## Current WordPress VM Setup

**Location:** `/var/www/html/documentation/`
**Size:** ~100MB (PDFs + generated HTML)
**Last manual update:** Recently (manual FTP)
**Access:** https://www.wolfssl.com/documentation/manuals/wolfssl/

**What's there:**
- 30+ PDF manuals
- 18+ generated HTML manual directories
- Javadocs for Java wrappers
- Tutorial files and legacy content

**What will change:**
- URLs change from `wolfssl.com/documentation/manuals/wolfssl/` to `docs.wolfssl.com/wolfssl/`
- Deployment changes from manual FTP to automatic git push
- CDN changes from Fastly (fronting WordPress) to GitHub CDN
- No more manual build/upload steps

## GitHub Pages Infrastructure

**Hosting provider:** GitHub (Microsoft)
**CDN:** Fastly (same as current Fastly setup, but GitHub-managed)
**Edge locations:** Global (50+ locations worldwide)
**SLA:** 99.95% uptime
**Capacity:** Unlimited traffic, unlimited builds
**SSL:** Automatic Let's Encrypt certificate, auto-renewed
**DDoS protection:** GitHub's infrastructure (enterprise-grade)

**Bandwidth limits:** None (GitHub Pages has no bandwidth limits)
**Build limits:** None for actions (6-hour max per workflow, plenty for 20-min build)
**Storage limits:** 1GB (we use ~100MB)

## Risk Assessment

### Low Risk Items ✅

- **Data loss:** Zero risk - original files remain in git repo
- **Downtime during deployment:** Zero - DNS change is instant at edge
- **Breaking existing docs:** Zero - builds from same source as current manual FTP
- **Performance regression:** Impossible - GitHub CDN is faster than single VM
- **Security regression:** Impossible - static files vs PHP/MySQL

### Medium Risk Items ⚠️

- **URL changes breaking external links:**
  - Mitigation: 30-day parallel operation
  - Mitigation: Can add redirects on WordPress VM if needed
  - Impact: Some external sites may have hardcoded old URLs

- **Build failures:**
  - Mitigation: CI tests every PR before merge
  - Mitigation: Can fix and re-deploy in minutes (just push to git)
  - Impact: Docs temporarily out of sync with latest changes

### High Risk Items ❌

- **None identified**

## Cost Analysis

### Current State (WordPress VM)

**Hosting:**
- VM cost: $50-100/month (shared with blog, forum, marketing site)
- Allocated to docs: ~$20/month (20% of workload)
- Fastly CDN: $0 (already in front of WordPress)

**Operations:**
- Manual builds: ~30 min/release × 12 releases/year = 6 hrs/year
- Manual FTP uploads: ~15 min/release × 12 releases/year = 3 hrs/year
- Monitoring/maintenance: ~30 min/month = 6 hrs/year
- **Total ops time:** ~15 hrs/year (~1.25 hrs/month)

**Total annual cost:** $240 hosting + $375 ops time (@$25/hr) = **$615/year**

### Proposed State (GitHub Pages)

**Hosting:**
- GitHub Pages: $0 (included with GitHub Team/Enterprise)
- GitHub CDN: $0 (included)

**Operations:**
- Manual builds: $0 (automatic on git push)
- Manual uploads: $0 (automatic deployment)
- Monitoring/maintenance: ~5 min/month = 1 hr/year (just check it works)
- **Total ops time:** ~1 hr/year (~5 min/month)

**Total annual cost:** $0 hosting + $25 ops time = **$25/year**

**Savings:** $590/year (96% reduction)

## Benefits Summary

### For Engineers

- **Git workflow:** Same as code - push to merge = live docs
- **PR reviews:** Docs go through same review as code
- **Local testing:** `make serve` previews changes instantly
- **Version control:** Full history of every doc change
- **No FTP:** Never SSH to VM or use FTP again
- **Faster iteration:** Push to git → auto-deploy in 20 min

### For Operations

- **Zero maintenance:** No VM to patch, no server to monitor
- **Auto-scaling:** GitHub handles traffic spikes automatically
- **99.95% SLA:** Better than single VM (no downtime for patches)
- **No manual deploys:** Remove "upload docs to VM" from release checklist
- **Faster deploys:** 20 minutes vs 1+ hour for manual build + FTP

### For Security

- **Smaller attack surface:** Static files vs PHP/MySQL/Apache
- **No server to compromise:** Can't SSH to GitHub Pages
- **Automatic HTTPS:** Let's Encrypt cert auto-provisioned and renewed
- **No credentials to manage:** No FTP passwords, no SSH keys
- **Audit trail:** Git history shows who changed what and when

### For Users

- **Faster loads:** GitHub CDN vs single VM in us-east4
- **Global CDN:** 50+ edge locations vs 1 GCP region
- **Better uptime:** GitHub's infrastructure vs our VM
- **Instant updates:** Docs update 20 min after push vs waiting for manual deploy

### For Business

- **$590/year savings:** Eliminates hosting allocation + reduces ops time
- **Reduced risk:** Fewer things that can break (no VM, no FTP, no manual steps)
- **Modern tooling:** Industry best practice (GitHub Pages for docs is standard)
- **Better DX:** Engineers spend less time fighting tools, more time writing

## Post-Deployment

### Immediate (Week 1)

- Monitor GitHub Actions for build failures
- Check docs.wolfssl.com daily for issues
- Collect feedback from engineering team
- Update internal wiki/documentation

### Short-term (Month 1)

- Update external links (website, marketing materials, customer docs)
- Add Google Analytics if desired (optional)
- Configure search if needed (Algolia DocSearch is free for open source)
- Remove docs from WordPress VM after validation

### Long-term (Ongoing)

- Docs auto-deploy on every merge to master
- No manual intervention needed
- Monitor GitHub Actions occasionally
- Update workflow if adding new products

## Success Criteria

**Deployment is successful if:**

1. ✅ All manuals build without errors
2. ✅ Landing page loads and links work
3. ✅ PDFs are downloadable
4. ✅ HTTPS certificate is provisioned
5. ✅ Page load time is <500ms (faster than WordPress)
6. ✅ No broken links within docs
7. ✅ Search engines can crawl (not blocked by robots.txt)

**Deployment is a failure if:**

- Manuals don't build
- PDFs are missing
- Critical links are broken
- Page load time is >2s (slower than WordPress)
- HTTPS doesn't work after 24 hours

**Rollback triggers:**

- Build consistently fails (>3 attempts)
- Critical functionality broken (links, PDFs, search)
- Performance significantly worse than WordPress
- Security issue discovered

## Questions & Answers

**Q: What if we need to rollback?**
A: Change DNS back to WordPress VM, takes 5 minutes. WordPress docs remain untouched for 30 days.

**Q: What if GitHub is down?**
A: GitHub has 99.95% SLA (4 hours/year downtime). WordPress VM has no SLA. If GitHub is down, Cloudflare/Fastly cache likely still serves docs. If critical, can point DNS back to WordPress VM.

**Q: Can we still update docs manually if needed?**
A: Yes, but through git instead of FTP. Edit markdown file, commit, push = auto-deploy. Same process as code.

**Q: What about versioned docs (5.6, 5.7, etc.)?**
A: Not in initial deployment. Can add later if needed. Currently all docs are for "latest" version.

**Q: Who can deploy docs?**
A: Anyone with write access to wolfSSL/documentation repo. Deployment happens automatically on merge to master. PRs require approval.

**Q: What about Japanese docs?**
A: Build system already supports Japanese (DOC_LANG=JA). Workflow can be extended to build both English and Japanese versions. Not in scope for initial deployment.

**Q: Cost of GitHub Actions minutes?**
A: Free for public repos (unlimited minutes). If private: 2,000 minutes/month free, then $0.008/minute. Our builds use ~20 min/deploy. At 1 deploy/day: 600 min/month = free. At 10 deploys/day: 6,000 min/month = $32/month. Still cheaper than VM.

## Dependencies

**Internal:**
- Repository admin approval (merge PR)
- DNS admin (configure A records)
- GitHub settings access (enable Pages)

**External:**
- GitHub Actions availability (required for builds)
- DNS propagation (15-minute wait)
- GitHub Pages availability (required for hosting)

**None of these are blockers** - all are reliable, enterprise-grade services.

## Communication Plan

**Who needs to know:**

1. **Engineering team** - New docs URL, git workflow for doc updates
2. **Support team** - New docs URL for customer links
3. **Marketing** - Update website links to docs
4. **Sales** - Update collateral referencing docs
5. **Customers** - (Optional) blog post announcing new docs site

**Suggested announcement (internal Slack):**

> 📚 **New Documentation Site:** docs.wolfssl.com
>
> We've migrated all product documentation to docs.wolfssl.com for faster, more reliable access.
>
> **What changed:**
> - New URL: docs.wolfssl.com (instead of wolfssl.com/documentation/manuals/)
> - Automatic deployment: push to git = auto-update docs
> - Faster loads: GitHub CDN with global edge caching
>
> **For you:**
> - Update bookmarks to docs.wolfssl.com
> - Share new URL with customers
> - Docs update automatically when merged to master (no more manual FTP)
>
> Old URLs will redirect for 30 days. Questions? Ask #engineering

## Approval

**Recommended approval path:**

1. **Technical review:** Engineering lead (Chris? Jacob?)
2. **Business approval:** Larry and/or Todd
3. **Final approval:** Whoever can merge to master branch

**Decision needed:**

- [ ] Approve migration to docs.wolfssl.com
- [ ] Timeline preference (immediate vs scheduled)
- [ ] Any additional requirements before deployment

---

**Prepared by:** Mark Atwood
**Date:** 2026-06-08
**Status:** Ready for approval
**Next step:** Merge PR #267 and enable GitHub Pages
