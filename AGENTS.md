# AGENTS.md

This file provides guidance to OpenAI Codex when working with code in this repository.

## Project Overview

This is the Bridgetown source for `vdistefano.studio`, a founder trust surface around SolverForge, selected technical work, demos, and writing. The public experience is owned by the site's content, ERB layouts, partials, CSS, and frontend modules.

## Commands

```bash
# Development server with live reload
bundle exec bridgetown serve

# Build the site
bundle exec bridgetown build

# Build frontend assets and the production site
bundle exec rake deploy

# Create new content
mkdir -p src/blog/my-post
touch src/blog/my-post/index.md
mkdir -p src/portfolio/my-project
touch src/portfolio/my-project/index.md
```

## Architecture

### Configuration Structure
- `config/initializers.rb` - Bridgetown URL, template, permalink, and layout defaults
- `src/_data/site_metadata.yml` - Site identity, navigation, and footer metadata
- `Rakefile` - Clean, frontend, build, and deployment tasks
- `esbuild.config.js` - Frontend bundle configuration

### Content Organization
- `src/blog/` - Blog posts
- `src/portfolio/` - Portfolio items
- `src/demos/` - Interactive demos
- `src/images/` - Content images
- `src/_layouts/` and `src/_partials/` - Project-owned rendering

### Deployment
GitHub Actions workflow (`.github/workflows/bridgetown.yaml`) installs the locked Ruby and Node dependencies, builds frontend assets, builds Bridgetown into `output/`, and deploys that artifact to GitHub Pages on push to `main`.

## Key Configuration Notes

- Homepage layout: minimal profile landing
- Color scheme: terminal green on dark background
- Markdown content may include trusted HTML because the site owns the rendered content
