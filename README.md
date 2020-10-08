<div align="center">

# asdf-scaleway-cli ![Build](https://github.com/fredleger/asdf-scaleway-cli/workflows/Build/badge.svg) ![Lint](https://github.com/fredleger/asdf-scaleway-cli/workflows/Lint/badge.svg)

[scaleway-cli](https://github.com/scaleway/scaleway-cli) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Why?](#why)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

- `bash`, `curl`, `tar`: generic POSIX utilities.
- `SOME_ENV_VAR`: set this environment variable in your shell config to load the correct version of tool x.

# Install

Plugin:

```shell
asdf plugin add scaleway-cli
# or
asdf plugin add https://github.com/fredleger/asdf-scaleway-cli.git
```

scaleway-cli:

```shell
# Show all installable versions
asdf list-all scaleway-cli

# Install specific version
asdf install scaleway-cli latest

# Set a version globally (on your ~/.tool-versions file)
asdf global scaleway-cli latest

# Now scaleway-cli commands are available
scw version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/fredleger/asdf-scaleway-cli/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Frederic Leger](https://github.com/fredleger/)

# to run actions
