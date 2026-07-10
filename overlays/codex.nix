_: prev:

let
  version = "0.144.1";

  platform =
    {
      x86_64-linux = {
        target = "x86_64-unknown-linux-musl";
        hash = "sha256-hAka4gxl/MfUEg25fRvVfX/435x2Cft4HHjC671PWig=";
      };

      aarch64-linux = {
        target = "aarch64-unknown-linux-musl";
        hash = "sha256-ufjvX5jkbO1Nu9N1akIj4+4pmkV/9IijMFvqRV2otbg=";
      };
    }
    .${prev.stdenv.hostPlatform.system}
      or (throw "codex: unsupported system ${prev.stdenv.hostPlatform.system}");
in
{
  codex = prev.stdenvNoCC.mkDerivation {
    pname = "codex";
    inherit version;

    src = prev.fetchurl {
      url = "https://github.com/openai/codex/releases/download/rust-v${version}/codex-${platform.target}.tar.gz";
      inherit (platform) hash;
    };

    sourceRoot = ".";

    nativeBuildInputs = [
      prev.installShellFiles
      prev.makeWrapper
    ];

    installPhase = ''
      runHook preInstall

      install -Dm755 \
        codex-${platform.target} \
        $out/libexec/codex

      makeWrapper $out/libexec/codex $out/bin/codex \
        --prefix PATH : "${
          prev.lib.makeBinPath [
            prev.bubblewrap
          ]
        }"

      runHook postInstall
    '';

    postInstall = ''
      installShellCompletion --cmd codex \
        --bash <($out/bin/codex completion bash) \
        --fish <($out/bin/codex completion fish) \
        --zsh <($out/bin/codex completion zsh)
    '';

    meta = {
      description = "Lightweight coding agent that runs in your terminal";
      homepage = "https://github.com/openai/codex";
      license = prev.lib.licenses.asl20;
      mainProgram = "codex";
      platforms = [
        "x86_64-linux"
        "aarch64-linux"
      ];
    };
  };
}
