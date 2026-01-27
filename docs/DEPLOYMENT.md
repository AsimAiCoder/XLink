# Xasim Web Deployment

This guide publishes two paths:
- xasim.me (root landing page)
- xasim.me/xlink (XLink UI + installer)

## Folder Layout

The published static site lives in `site/`:
- `site/index.html` root landing page
- `site/styles.css` and `site/script.js`
- `site/xlink/` XLink UI (copied from `xlink/`)
- `site/xlink/public/xlink.sh` installer script

Sync source to the site folder before publishing:

```bash
./scripts/sync-xlink-site.sh
```

## Option A: Manual Publish (Zip Upload)

1. Create a repo on the `asimgraphicx` account named `asimgraphicx.github.io`.
2. Upload the contents of `site/` into the repo root (do not upload the parent folder).
3. Ensure `CNAME` exists with `xasim.me`.
4. In repo Settings > Pages, set Source to `main` and `/` root.

## Option B: Automated Publish (Recommended)

This keeps code on `asimcoder` and publishes pages from `asimgraphicx`.

1. On `asimgraphicx`, create a Personal Access Token with `repo` scope.
2. In the `asimcoder` repo, add secret `PAGES_DEPLOY_TOKEN`.
3. Use the workflow at `.github/workflows/pages.yml` (added in this repo).
4. Push to `main` and the workflow will publish `site/` to `asimgraphicx`.

## DNS Setup for xasim.me

Set these A records to GitHub Pages:
- 185.199.108.153
- 185.199.109.153
- 185.199.110.153
- 185.199.111.153

Optional: add a CNAME for `www` pointing to `asimgraphicx.github.io`.

## Update Flow

1. Edit XLink UI or script in `xlink/`.
2. Run `./scripts/sync-xlink-site.sh`.
3. Commit and push.

The published site always comes from `site/`.
