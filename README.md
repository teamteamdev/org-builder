# Org-builder

Org-builder is a simple Nix tool to convert org-mode files to HTML websites.

## How it works

`.org` files are processed by Emacs `org-html-export-to-html`, other files are copied as-is.

We use `rsync --delete` to update the target directory.

## Usage

* `nix run . -- source-directory destination-directory`
* or `org-builder.url = "github:teamteamdev/org-builder";` in your `flake.nix`

## Without Nix

Ensure you have Emacs and rsync in your `PATH`.

```
git clone https://github.com/teamteamdev/org-builder.git
org-builder/src/bin/org-builder.sh source-directory destination-directory
```
