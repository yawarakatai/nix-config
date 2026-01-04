final: prev: {
  nushellPlugins = prev.nushellPlugins // {
    skim = prev.rustPlatform.buildRustPackage rec {
      pname = "nu_plugin_skim";
      version = "0.21.0";

      src = prev.fetchFromGitHub {
        owner = "idanarye";
        repo = "nu_plugin_skim";
        tag = "v${version}";
        hash = "sha256-cFk+B2bsXTjt6tQ/IVVefkOTZKjvU1hiirN+UC6xxgI=";
      };

      cargoHash = "sha256-eNT4NfSlyKuVUlOrmSNoimJJ1zU88prSemplbBWcyag=";

      nativeBuildInputs = prev.lib.optionals prev.stdenv.cc.isClang [
        prev.rustPlatform.bindgenHook
      ];

      meta = with prev.lib; {
        description = "Nushell plugin that integrates the skim fuzzy finder";
        homepage = "https://github.com/idanarye/nu_plugin_skim";
        license = licenses.mit;
        mainProgram = "nu_plugin_skim";
      };
    };
  };
}
