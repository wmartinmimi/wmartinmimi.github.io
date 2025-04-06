set dotenv-load := true
set dotenv-path := '.secrets/.env'

npm := 'npm'
npx := 'npx'
uv := 'uv'
astro := 'npx astro'
wrangler := 'npx wrangler'
build_dir := 'build'

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
