# karukan

[karukan](https://github.com/togatoga/karukan) is a Japanese input method with
neural kana-kanji conversion (llama.cpp). Importing this module adds it to
fcitx5 on every desktop host as a trial next to Mozc, which stays the default;
pick it in fcitx5's configuration to use it. `system.nix` adds the addon and
`home.nix` writes `~/.config/karukan-im/config.toml`; remove their imports from
`modules/profiles/system/desktop.nix` and `modules/profiles/home/desktop.nix`
to drop it.

## Decisions

- Packaged here instead of using a third-party flake: the only one,
  yuko1101/karukan-nix, had one star and no commit since July 2026, and a
  trial should not add a flake input. Also considered in November 2026:
  hazkey (upstream inactive since March 2026, needs Swift 6.1) and
  hazkey-community (one developer, several releases a week, rpm/deb only).
- Pinned to a commit on `main`: the only release, v0.1.0 (February 2026), lacks
  most of the documented features. Update `rev` and both hashes together.
- The system dictionary is the prebuilt `dict.tgz` of the v0.1.0 release,
  installed in the package and set as the default `dict_path`. Verified: its
  KRKN format version (1) is unchanged on the pinned commit.
- Models are not packaged: karukan downloads the default jinen-v2 models from
  Hugging Face on first start and caches them in the user's home. Packaging
  them is worth it only if karukan is kept.
- Learning is capped at 8-character surfaces (`[learning] max_surface_chars`,
  default 50). Live conversion commits whole clauses, and the learning cache
  ranks above the model and offers prefix matches, so learned one-off
  sentences, misconversions included, kept appearing as the first candidate.
  In the November 2026 cache (552 entries), surfaces of 9 or more characters
  were almost all clause fragments, while 8 and under still held reusable
  phrases such as 音楽再生ツール. Verified in the source: the cap applies only
  when recording, not when loading `learning.tsv`, so entries learned before
  the cap stay until removed (`Ctrl+Backspace` on the candidate, or by editing
  the file while fcitx5 is stopped, since karukan rewrites it from memory).
- Built for x86-64-v3; see the comment in `package.nix`. Verified: the addon
  contains AVX2/FMA instructions.

## Open

- Conversion quality and latency against Mozc have not been judged yet.
- Behavior on a fresh host, including the first model download, has not been
  tested.
