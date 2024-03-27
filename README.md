# Org-builder

Org-builder is a simple Nix tool to convert org-mode files to HTML websites.

## Usage

`nix run . -- source-directory destination-directory`

`.org` files are processed by Emacs `org-html-export-to-html`, other files are copied as-is.

We use `rsync --delete` to update the target directory.
