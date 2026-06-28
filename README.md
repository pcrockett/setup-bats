# setup-bats action

easy way to install [bats](https://github.com/bats-core/bats-core) in your GitHub
Actions workflows.

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@9c091bb21b7c1c1d1991bb908d89e4e9dddfe3e0  # v7.0.0
      - uses: pcrockett/setup-bats@b791173505d0a1947d46793e9aae33a962cfd949 # v0.1.0
```

if you don't want to use the default version of bats that comes with this action, you
can specify your own version and checksum:

```yaml
- uses: pcrockett/setup-bats@b791173505d0a1947d46793e9aae33a962cfd949 # v0.1.0
  with:
    version: '1.13.0'
    checksum: 'e7da1327c00de5a889293c04e22a26f1e05493eec46478f4c64442e3d8f7586d'
```

**recommended:** run [pinact](https://github.com/suzuki-shunsuke/pinact) to pin your
actions to a specific release. don't worry, if you're using Dependabot, Renovate, etc.,
they will update your pins correctly for you.

```bash
pinact run --update
```
