
npm := 'npm'
npx := 'npx'
astro := 'npx astro'
wrangler := 'npx wrangler'
build_dir := 'build'

export DO_NOT_TRACK := '1'

# activate dev mode
watch +args='':
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

# setup dev environment
setup:
    {{npm}} install
    {{astro}} telemetry disable
    {{wrangler}} telemetry disable

# update dependencies
upgrade: && lint
    {{npm}} update
    {{npx}} @astrojs/upgrade
