final: prev: {
  vscode-extensions = prev.vscode-extensions // {
    anthropic = (prev.vscode-extensions.anthropic or { }) // {
      claude-code = prev.vscode-utils.buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "claude-code";
          publisher = "anthropic";
          version = "2.0.55";
          hash = "sha256-j5yeFtbaW0UVrchKOcqBO60ay9PuPDS4jQzz+GN+56U=";
        };
      };
    };
  };
}
