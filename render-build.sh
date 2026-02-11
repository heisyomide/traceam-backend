#!/usr/bin/env bash
# exit on error
set -o errexit

npm install
# This command tells Render to install the necessary Chrome pieces
npx puppeteer browsers install chrome