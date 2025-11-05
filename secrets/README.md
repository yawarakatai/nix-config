# Secrets Directory

This directory is for storing encrypted secrets using sops-nix.

## Setup

1. **Generate age key** (if not already done):
   ```bash
   mkdir -p ~/.config/sops/age
   age-keygen -o ~/.config/sops/age/keys.txt
   ```

2. **Get your public key**:
   ```bash
   age-keygen -y ~/.config/sops/age/keys.txt
   ```

3. **Update `.sops.yaml`**:
   Replace `YOUR_AGE_PUBLIC_KEY` in `.sops.yaml` with your actual public key.

## Creating Secrets

```bash
# Create a new secrets file
sops secrets/secrets.yaml
```

This will open your editor. Add secrets in YAML format:

```yaml
# Example secrets
yawarakatai-password: |
  $6$rounds=656000$xxxxx$yyyyyy...

github-token: ghp_xxxxxxxxxxxx

# Add more secrets as needed
```

Save and close. The file will be automatically encrypted.

## Using Secrets in Configuration

1. **In `hosts/desuwa/configuration.nix`**:

```nix
{
  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    age.keyFile = "/home/yawarakatai/.config/sops/age/keys.txt";
    
    secrets.yawarakatai-password = {
      neededForUsers = true;
    };
  };
  
  users.users.yawarakatai = {
    hashedPasswordFile = config.sops.secrets.yawarakatai-password.path;
  };
}
```

2. **In Home Manager**:

```nix
{
  sops = {
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    defaultSopsFile = ../../secrets/secrets.yaml;
    
    secrets.github-token = { };
  };
  
  # Use in configuration
  programs.git.extraConfig = {
    credential.helper = "store --file ${config.sops.secrets.github-token.path}";
  };
}
```

## Editing Secrets

```bash
# Edit existing secrets
sops secrets/secrets.yaml
```

## Backup Your Keys!

**Important**: Back up `~/.config/sops/age/keys.txt` in a secure location!

Without this file, you cannot decrypt your secrets.

## Git Considerations

The encrypted `secrets.yaml` file is safe to commit to git. However:

- **DO NOT commit** the age private key (`keys.txt`)
- The `.sops.yaml` file is safe to commit (it only contains public keys)

## Migration from Plain Text Password

After setting up sops-nix, you can migrate from the plain text password hash:

1. Generate password hash: `mkpasswd -m sha-512`
2. Add to `secrets/secrets.yaml`: `yawarakatai-password: | <hash>`
3. Update `configuration.nix` to use `hashedPasswordFile` instead of `hashedPassword`
4. Rebuild: `nos`
5. Test login on a different TTY before logging out!

## Advanced: Multiple Machines

For multiple machines, add their age keys to `.sops.yaml`:

```yaml
keys:
  - &desuwa age1xxxxx...
  - &nanodesu age1yyyyy...

creation_rules:
  - path_regex: secrets/[^/]+\.yaml$
    key_groups:
      - age:
          - *desuwa
          - *nanodesu
```

## Alternative: YubiKey with GPG

You can also use GPG keys stored on YubiKey:

1. Get GPG key fingerprint: `gpg --list-secret-keys --keyid-format LONG`
2. Update `.sops.yaml`:

```yaml
keys:
  - &yubikey YOUR_GPG_KEY_FINGERPRINT

creation_rules:
  - path_regex: secrets/[^/]+\.yaml$
    key_groups:
      - pgp:
          - *yubikey
```

3. Configure in NixOS:

```nix
sops = {
  defaultSopsFile = ../../secrets/secrets.yaml;
  gnupg.sshKeyPaths = [ ];  # Use YubiKey
};
```

## Resources

- [sops-nix Documentation](https://github.com/Mic92/sops-nix)
- [age Documentation](https://github.com/FiloSottile/age)
