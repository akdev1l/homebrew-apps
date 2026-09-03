# homebrew-apps

A custom Homebrew tap with auto-updated cask formulae for macOS apps that ship unsigned or unnotarized builds. Each cask strips the quarantine attribute (`xattr -dr com.apple.quarantine`) after install so Gatekeeper doesn't block them.

## Usage

```sh
brew tap akdev1l/apps
brew install --cask librewolf
```

## Casks

| Cask | Description |
|------|-------------|
| [librewolf](Casks/l/librewolf.rb) | Privacy-focused Firefox fork |
| [qbittorrent](Casks/q/qbittorrent.rb) | Peer to peer BitTorrent client |
| [xmoto](Casks/x/xmoto.rb) | Challenging 2D motocross platform game |
| [fedora-media-writer](Casks/f/fedora-media-writer.rb) | Tool to write Fedora images to portable media |

## How it works

Formulae are generated automatically from Jinja2 templates using an Ansible playbook:

1. `generate-formulae.yml` — the top-level playbook; includes one task file per cask, each parameterized with the upstream release API URL and template path
2. `tasks/<name>.yml` — per-cask task that fetches the latest release, resolves the SHA256(s) (from the release asset digest, falling back to downloading and hashing when a release omits one), and renders the template
3. `templates/` — Jinja2 templates (`.rb.j2`) for each cask; rendered output is written to `Casks/`

The playbook runs on a schedule (daily at 06:00 UTC) via the `Update Formulae` workflow, and also triggers when a template changes. Any resulting changes to `Casks/` are pushed to a `chore/update-formulae` branch, opened as a PR against `master` (if one isn't already open), and set to auto-merge.

The `PR Check` workflow installs and verifies every cask in the tap on `macos-latest` for each pull request targeting `master`.

## Adding a new formula

1. Add a `.rb.j2` template under `templates/Casks/<letter>/<name>.rb.j2`, including a `postflight` block that strips the quarantine attribute
2. Add a task file under `tasks/<name>.yml` (or reuse an existing one if the release shape matches, e.g. `codeberg-formula.yml`)
3. Add an entry to `generate-formulae.yml` referencing the task file, upstream release API URL, and template path
4. Add the cask to the matrix in `.github/workflows/pr-check.yml` and to the table above
5. Push — the workflow will render the template and open a PR with the result
