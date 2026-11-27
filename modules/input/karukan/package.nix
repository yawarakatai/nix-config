{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  rustPlatform,
  cargo,
  rustc,
  cmake,
  kdePackages,
  pkg-config,
  fcitx5,
  libxkbcommon,
  aws-lc,
  oniguruma,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fcitx5-karukan";
  # v0.1.0 (February 2026) predates most features; main is where releases are cut from.
  version = "0.1.0-unstable-2026-11-21";

  src = fetchFromGitHub {
    owner = "togatoga";
    repo = "karukan";
    rev = "2f0a00a1802538b668e11b49760d4a97f717b637";
    hash = "sha256-Qkubj92MZM7EfoWJKg0mCCrPDxNWkjz/YYsEa7Fs6JY=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-ZsO9FZ2GotgsoB9Nb9mSqZzGCIkfc3tX5XUWv5rqzFg=";
  };

  # The IME ships no system dictionary and runs without one, with a much
  # smaller vocabulary. This is the prebuilt SudachiDict build its docs point
  # to; its KRKN format version is unchanged on main.
  dict = fetchurl {
    url = "https://github.com/togatoga/karukan/releases/download/v0.1.0/dict.tgz";
    hash = "sha256-8ZTSUmv4JmIrxbr3wH51Ja2b3i3GOJbNkpBFKDpK7M0=";
  };

  # The embedded default config is merged under the user's config.toml, so
  # pointing it at the store keeps dict_path overridable there.
  postPatch = ''
    substituteInPlace karukan-im/core/config/default.toml \
      --replace-fail '[conversion]' "[conversion]
    dict_path = \"$out/share/karukan/dict.bin\""
  '';

  # CMake drives the cargo build of the Rust library from the workspace root.
  cmakeDir = "../karukan-im/fcitx5/fcitx5-addon";
  # A set RUSTFLAGS replaces the addon's default target-cpu=native, which
  # would tie the binary to the build machine. llama-cpp-sys-2 passes the
  # same -march to llama.cpp; without one it builds for baseline SSE2 and
  # infers much slower. Every desktop host supports x86-64-v3 (AVX2, FMA);
  # a host without it would crash fcitx5 when the addon loads.
  env.RUSTFLAGS = "-C target-cpu=x86-64-v3";

  nativeBuildInputs = [
    cmake
    kdePackages.extra-cmake-modules
    pkg-config
    cargo
    rustc
    rustPlatform.cargoSetupHook
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    fcitx5
    libxkbcommon
    # cargoSetupHook makes aws-lc-sys and onig_sys link these instead of vendored copies.
    aws-lc
    oniguruma
  ];

  postInstall = ''
    mkdir -p $out/share/karukan
    tar -xzf $dict -C $out/share/karukan dict.bin
  '';

  meta = {
    description = "Japanese input method for fcitx5 with neural kana-kanji conversion";
    homepage = "https://github.com/togatoga/karukan";
    license = with lib.licenses; [
      mit
      asl20
    ];
    platforms = [ "x86_64-linux" ];
  };
})
