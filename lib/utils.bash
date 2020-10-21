#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/scaleway/scaleway-cli"

fail() {
  echo -e "asdf-scaleway-cli: $*"
  exit 1
}

curl_opts=(-fsSL)

# NOTE: You might want to remove this if scaleway-cli is not hosted on GitHub releases.
if [ -n "${GITHUB_API_TOKEN:-}" ]; then
  curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
  sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
    LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
  git ls-remote --tags --refs "$GH_REPO" |
    grep -o 'refs/tags/.*' | cut -d/ -f3- |
    sed 's/^v//' # NOTE: You might want to adapt this sed to remove non-version strings from tags
}

list_all_versions() {
  # Change this function if scaleway-cli has other means of determining installable versions.
  list_github_tags
}

download_release() {
  local version filename url
  version="$1"
  filename="$2"

  local target_os target_ext target_arch version_slug

  target_os="unknown"
  target_arch="x86_64"
  target_ext=""
  version_slug="2-2-0"

  case "$OSTYPE" in
    solaris*)
      target_os="solaris"
      ;;
    darwin*)
      target_os="darwin"
      ;;
    linux*)
      target_os="linux"
      ;;
    bsd*)
      target_os="bsd"
      ;;
    msys*)
      target_os="windows"
      target_ext=".exe"
      ;;
    *)
      echo "unknown: $OSTYPE"
      ;;
  esac

  target_arch="$(uname -m)"
  version_slug_1="$(echo ${version} | tr '.' '-' | cut -d v -f 2)"
  version_slug_2="$(echo ${version} | cut -d v -f 2)"
  
  # exemple https://github.com/scaleway/scaleway-cli/releases/download/v2.2.0/scw-2-2-0-darwin-x86_64
  # exemple 2 https://github.com/scaleway/scaleway-cli/releases/download/v2.2.1/scw-2.2.1-linux-x86_64
  # exemple scw-2-2-0-darwin-x86_64
  url1="$GH_REPO/releases/download/v${version}/scw-${version_slug}-${target_os}-${target_arch}${target_ext}"
  url2="$GH_REPO/releases/download/v${version}/scw-${version_slug_2}-${target_os}-${target_arch}${target_ext}"
  
  echo "* Downloading scaleway-cli release $version..."
  curl "${curl_opts[@]}" -o "$filename" -C - "$url1" || \
  curl "${curl_opts[@]}" -o "$filename" -C - "$url2" || \
    fail "Could not download $url"
}

install_version() {
  local install_type="$1"
  local version="$2"
  local install_path="$3"
  local tool_cmd
  tool_cmd="scw"

  if [ "$install_type" != "version" ]; then
    fail "asdf-scaleway-cli supports release installs only"
  fi

  local release_file="$install_path/scw-$version"
  (
    mkdir -p "$install_path/bin"
    download_release "$version" "$release_file"
    # tar -xzf "$release_file" -C "$install_path" --strip-components=1 || fail "Could not extract $release_file"
    # chmod a+x "$install_path/bin/scw"
    # rm "$release_file"
    mv "$release_file" "$install_path/bin/$tool_cmd"
    chmod a+x "$install_path/bin/$tool_cmd"

    test -x "$install_path/bin/$tool_cmd" || fail "Expected $install_path/bin/$tool_cmd to be executable."

    # TEST
    "$install_path/bin/$tool_cmd" version || fail "Expected $install_path/bin/$tool_cmd version to work."

    echo "scaleway-cli $version installation was successful!"
  ) || (
    #rm -rf "$install_path/bin/$tool_cmd"
    fail "An error ocurred while installing scaleway-cli $version."
  )
}
