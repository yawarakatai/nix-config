{ pkgs, ... }:

{
  home.packages = with pkgs; [
    claude-code
  ];

  home.file.".claude/settings.json".text = ''
    {
      "permissions": {
        "allow": [ ],
        "deny": [
          "Bash(curl:*)",
          "Read(./.env)",
          "Read(./.env.*)",
          "Read(./secrets/**)"
        ]
      }
    }
  '';
}
