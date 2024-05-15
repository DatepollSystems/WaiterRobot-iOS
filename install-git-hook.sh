#!/bin/bash
echo "Removing current git pre-commit hook ..."
rm -rf .git/hooks/pre-commit
echo "Installing git pre-commit hook ..."
cp command-line-tools/pre-commit .git/hooks/pre-commit
