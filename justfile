set dotenv-load := true
set dotenv-path := '.secrets/.env'

npm := 'npm'
npx := 'npx'
uv := 'uv'
astro := 'npx astro'
wrangler := 'npx wrangler'
build_dir := 'build'
docker := 'podman'
archive := 'build/archive'

export DO_NOT_TRACK := '1'

alias w := watch
alias l := lint
alias b := build
alias d := deploy
alias u := upgrade
alias p := purge

# activate dev mode
watch +args='--host 0.0.0.0':
    {{astro}} dev {{args}}

# run linter
lint:
    {{astro}} check

# run production build
build: lint
    {{astro}} build

# deploy to cloud
deploy: build
    {{wrangler}} pages deploy {{build_dir}} --branch production --project-name martinmimi --commit-dirty=true
    -rm -r .wrangler/tmp

# clean up cloud deployments
purge:
    {{uv}} run scripts/purge-deployments.py

# setup dev environment
setup:
    {{npm}} install
    {{astro}} telemetry disable
    {{wrangler}} telemetry disable

# update dependencies
upgrade: && lint
    {{npm}} update
    {{npx}} @astrojs/upgrade
    {{uv}} sync --script scripts/purge-deployments.py

archive version:
    -rm -r {{archive}}/{{version}}
    {{docker}} build . -f scripts/archiver/{{version}}.dockerfile --rm --output {{archive}}/{{version}}
    @echo
    @echo "archive {{version}} created at: {{archive}}/{{version}}"
    @echo "note: run '{{docker}} image prune' to clean up unused images!"

_deploy-archive version:
    just archive {{version}}
    {{wrangler}} pages deploy --project-name martinmimi --commit-dirty=true --branch {{version}} {{archive}}/{{version}}

deploy-archives:
    just _deploy-archive v1
    just _deploy-archive v2
    just _deploy-archive v3
    just _deploy-archive v4
    @echo "deployed all archives"

