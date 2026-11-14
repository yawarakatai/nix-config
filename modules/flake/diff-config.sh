usage() {
  cat <<'USAGE'
Usage:
  nix run .#diff-config -- [base-rev]

Compares every host's system and every standalone Home Manager configuration
between base-rev (default: HEAD) and the working tree, by derivation path.
Identical paths mean identical builds; for each difference nix-diff explains
what changed. Only evaluates; nothing is built.

The working tree is read as a git flake, so new files must be staged.
Exits 1 when any output differs.
USAGE
}

case "${1:-}" in
  -h | --help)
    usage
    exit 0
    ;;
esac
[ "$#" -le 1 ] || {
  usage >&2
  exit 2
}

root=$(git rev-parse --show-toplevel)
base=$(git -C "$root" rev-parse --verify "${1:-HEAD}^{commit}")

drv_paths() {
  local ref=$1
  nix eval --json "$ref#nixosConfigurations" --apply \
    'builtins.mapAttrs (_: c: c.config.system.build.toplevel.drvPath)' |
    jq 'with_entries(.key |= "nixos/" + .)'
  nix eval --json "$ref#homeConfigurations" --apply \
    'builtins.mapAttrs (_: c: c.activationPackage.drvPath)' |
    jq 'with_entries(.key |= "home/" + .)'
}

echo "Evaluating base ${base:0:12}..." >&2
old=$(drv_paths "git+file://$root?rev=$base" | jq -s add)
echo "Evaluating working tree..." >&2
new=$(drv_paths "git+file://$root" | jq -s add)

status=0
while IFS='|' read -r name a b; do
  if [ "$a" = "$b" ]; then
    echo "same     $name"
  elif [ -z "$a" ]; then
    echo "added    $name"
    status=1
  elif [ -z "$b" ]; then
    echo "removed  $name"
    status=1
  else
    echo "changed  $name"
    nix-diff "$a" "$b"
    status=1
  fi
done < <(jq -rn --argjson old "$old" --argjson new "$new" '
  ($old + $new | keys[]) as $k | [$k, $old[$k] // "", $new[$k] // ""] | join("|")')

exit "$status"
