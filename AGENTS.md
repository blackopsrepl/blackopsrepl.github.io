# AGENTS.md

This file provides guidance to OpenAI Codex when working with code in this repository.

## Project Overview

This is the Hugo source for `vdistefano.studio`, a founder trust surface around SolverForge, selected technical work, demos, and writing. Blowfish is the base theme, but the public experience is increasingly driven by project-owned content, partials, and overrides.

## Commands

```bash
# Development server with live reload
hugo server

# Build the site
hugo

# Build for production (minified, garbage collected)
hugo --gc --minify

# Create new content
hugo new Blog/my-post/index.md
hugo new Portfolio/my-project/index.md
```

## Architecture

### Configuration Structure
- `hugo.toml` - Root config with baseURL and cache settings
- `config/_default/` - Main configuration files:
  - `hugo.toml` - Core Hugo settings, taxonomies, outputs
  - `params.toml` - Theme parameters (layout, appearance, features)
  - `languages.en.toml` - English language settings and author info
  - `menus.en.toml` - Navigation menus (main and footer)
  - `markup.toml` - Goldmark/markdown settings with math support

### Content Organization
- `content/Blog/` - Blog posts
- `content/Portfolio/` - Portfolio items
- `content/images/` - Content images

### Theme Base
Blowfish remains the base theme at `themes/blowfish/`. Update with:

```bash
git submodule update --remote --merge
```

### Deployment
GitHub Actions workflow (`.github/workflows/hugo.yaml`) builds and deploys to GitHub Pages on push to `main`. Uses Hugo extended v0.152.2.

## Key Configuration Notes

- Homepage layout: minimal `profile` landing
- Color scheme: `terminal` with auto light/dark switching
- Math support enabled via Goldmark passthrough delimiters (`\[...\]`, `$$...$$`, `\(...\)`)
- Unsafe HTML rendering enabled in markdown
