#!/usr/bin/env bash
# Merge main into prod and push, triggering pub.dev publish via prod.yml.
set -euo pipefail
git checkout prod
git merge main --no-edit
git push origin prod
git checkout main
