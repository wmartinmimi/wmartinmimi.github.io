#!/usr/bin/env bash

set -euo pipefail

# load env
set -a
source .env
set +a

# variables
build_dir="build/output"
archive="build/archive"

export DO_NOT_TRACK=1

watch() {
    deno --allow-all npm:astro dev "$@"
}

audit() {
    deno audit
}

lint() {
    deno --allow-all npm:astro check
}

clean() {
    rm -rf ./build
}

build() {
    clean
    lint
    deno --allow-all npm:astro build
}

deploy() {
    build

    deno --allow-all npm:wrangler pages deploy \
        "$build_dir" \
        --branch production \
        --project-name martinmimi \
        --commit-dirty=true

    rm -rf .wrangler/tmp

    rclone check \
        --download \
        "$build_dir" \
        w10site: \
        --differ ./build/differ.txt \
        --missing-on-dst ./build/dst-missing.txt \
        --missing-on-src ./build/src-missing.txt \
        --progress || true

    cat \
        ./build/differ.txt \
        ./build/dst-missing.txt \
        ./build/src-missing.txt \
        > ./build/mirror.txt

    echo "found $(wc -l < ./build/mirror.txt) changes"

    rclone sync \
        "$build_dir" \
        w10site: \
        --files-from-raw ./build/mirror.txt \
        --ignore-times \
        --progress
}

purge() {
    uv run scripts/purge-deployments.py
}

setup() {
    deno install
    deno --allow-all npm:astro telemetry disable
    deno --allow-all npm:wrangler telemetry disable
}

upgrade() {
    lint
    deno update
    deno --allow-all npm:@astrojs/upgrade
    uv sync --script scripts/purge-deployments.py
}

archive_version() {
    local version="${1:?version required}"

    rm -rf "$archive/$version"

    podman build . \
        -f "scripts/archiver/$version.dockerfile" \
        --rm \
        --output "$archive/$version"

    echo
    echo "archive $version created at: $archive/$version"
    echo "note: run '$docker image prune' to clean up unused images!"
}

deploy_archive() {
    local version="${1:?version required}"

    archive_version "$version"

    deno --allow-all npm:wrangler pages deploy \
        --project-name martinmimi \
        --commit-dirty=true \
        --branch "$version" \
        "$archive/$version"
}

deploy_archives() {
    deploy_archive v1
    deploy_archive v2
    deploy_archive v3
    deploy_archive v4

    echo "deployed all archives"
}

docs() {
    cat <<EOF
Usage: $0 <command> [args]

Commands:
    (w)atch [args]     # e.g. $0 watch --host 127.0.0.1
    (a)udit
    (l)int
    (b)uild
    (d)eploy
    (u)pgrade
    (p)urge
    clean
    setup
    archive <version>  # e.g. $0 archive v3
    deploy-archives    # deploy all archives
    help
EOF
}

case "${1:-}" in
    watch|w)
        shift
        watch "$@"
        ;;
    audit|a)
        audit
        ;;
    lint|l)
        lint
        ;;
    build|b)
        build
        ;;
    deploy|d)
        deploy
        ;;
    upgrade|u)
        upgrade
        ;;
    purge|p)
        purge
        ;;
    clean)
        clean
        ;;
    setup)
        setup
        ;;
    archive)
        shift
        archive_version "$@"
        ;;
    deploy-archives)
        deploy_archives
        ;;
    *)
        docs
        exit 1
        ;;
esac
