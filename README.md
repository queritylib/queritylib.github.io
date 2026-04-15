# Querity

Documentation site built with [Jekyll](https://jekyllrb.com/) and the [Just the Docs](https://just-the-docs.com/) theme.

## How to make changes to the documentation

The documentation content is split across the Markdown pages in the repository root plus the `features/` and `spring-mvc/` subdirectories. The site chrome is provided by Jekyll + Just the Docs.

## Run locally with Docker

This repository includes a Docker-based local setup, so you do not need Ruby installed on your machine.

### Start the local server

```bash
docker compose up --build
```

The site will be available at <http://localhost:4000>.

### Stop the local server

```bash
docker compose down
```

## Notes

- The container installs gems through Bundler and serves the site with Jekyll.
- Search support is generated from `assets/js/zzzz-search-data.json`, which is included in the repository for gem-based Just the Docs builds.
- GitHub Pages deployment is handled through the workflow in `.github/workflows/jekyll-gh-pages.yml`.
