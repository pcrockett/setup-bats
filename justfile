[private]
_default:
    @just --list

# Run pre-commit on all files
lint:
    pre-commit run --all --show-diff-on-failure --color always

# Generate draft GitHub release
release:
    gh release create --generate-notes --draft

# Update default version and checksum to latest GitHub release
update:
    #!/usr/bin/env bash
    set -euo pipefail
    repo=bats-core/bats-core
    echo "getting latest release..."
    latest_tag="$(
        gh release list --exclude-drafts --exclude-pre-releases \
            --repo "${repo}" \
            --json tagName,isLatest \
            --jq '.[] | select(.isLatest).tagName'
    )"
    download_url="https://github.com/${repo}/archive/refs/tags/${latest_tag}.zip"
    echo "downloading..."
    temp_dir="$(mktemp --directory)"
    cleanup() {
        rm -rf "${temp_dir}"
    }
    trap 'cleanup' EXIT ERR
    curl \
        --proto '=https' \
        --tlsv1.3 \
        --silent \
        --show-error \
        --fail \
        --location "${download_url}" \
        --output "${temp_dir}/archive.zip"

    echo "computing checksum..."
    checksum="$(sha256sum "${temp_dir}/archive.zip" | cut --delimiter " " --fields 1)"

    version="$(echo "${latest_tag}" | cut --characters 2-)"
    awk -f update.awk \
        VERSION="${version}" \
        CHECKSUM="${checksum}" \
        <action.yml \
        >"${temp_dir}/action.yml"
    mv "${temp_dir}/action.yml" .

    git diff action.yml

# Update this repo from its copier template
update-template:
    copier update --skip-answered
