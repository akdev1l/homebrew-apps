# homebrew-apps

A custom Homebrew tap with auto-updated cask formulae.

## Usage

```sh
brew tap akdev1l/homebrew-apps
brew install --cask librewolf
```

## How it works

Formulae are generated automatically from Jinja2 templates using an Ansible playbook:

1. `generate-formulae.yml` — the top-level playbook, defines each formula and its upstream release API URL
2. `tasks/formula.yml` — reusable task that fetches the latest release, downloads the SHA256 checksums for both architectures, and renders the template
3. `templates/` — Jinja2 templates (`.rb.j2`) for each cask; rendered output is written to `Casks/`

The playbook runs on a schedule (daily at 06:00 UTC) via GitHub Actions, and also triggers automatically when a template is changed. Any updates to the generated formulae are committed back to the repo by the workflow.

## Adding a new formula

1. Add a `.rb.j2` template under `templates/Casks/<letter>/<name>.rb.j2`
2. Add an entry to the `formulae` list in `generate-formulae.yml` with the upstream release API URL and the template path
3. Push — the workflow will render the template and commit the result

## Casks

| Cask | Description |
|------|-------------|
| [librewolf](Casks/l/librewolf.rb) | Privacy-focused Firefox fork |
