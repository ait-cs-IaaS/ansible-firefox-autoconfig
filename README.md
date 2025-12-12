# Ansible Role: firefox-autoconfig

Configures Firefox using Mozilla autoconfig. The role installs `mozilla.cfg` and `syspref.js`, manages `distribution.ini`, pre-creates multiple profiles, and imports trusted certificates so every profile starts with the same baseline configuration. Firefox needs to be present on the target host.

## What the role does
- Detects `firefox_user` when not provided and clears the user's existing `.mozilla/firefox` directory.
- Installs autoconfig files (`/usr/lib/firefox/mozilla.cfg`, `/etc/firefox/syspref.js`) and an optional `distribution.ini`.
- Creates `profile.default` plus any names in `firefox_profile_names`, wiring them into `installs.ini` and `profiles.ini`, and copying `xulstore.json` into each profile.
- Imports certificates from `firefox_trusted_certs_file` via `mozilla.cfg`.
- Patches `/usr/lib/firefox/firefox.sh` to auto-select the `vnc<DISPLAY>` profile, matching the default `firefox_profile_names`.

## Role Variables

| Variable name                 | Type            | Default                                   | Description |
| ----------------------------- | --------------- | ----------------------------------------- | ----------- |
| firefox_user                  | string          | auto-detected                             | User to configure. When unset, the first non-system user (UID with four digits) is used. |
| firefox_startpage             | string          | www.google.com/ncr                        | Homepage set on first launch. |
| firefox_default_search        | string          | www.google.com/ncr                        | Default search URL used in `mozilla.cfg`. |
| firefox_autoconfig            | file path       | mozilla.cfg.j2                            | Template for `/usr/lib/firefox/mozilla.cfg`. |
| firefox_syspref               | file path       | syspref.js                                | File copied to `/etc/firefox/syspref.js` to enable autoconfig. |
| firefox_installs_ini          | file path       | installs.ini                              | Template for `installs.ini` in the Firefox config directory. |
| firefox_profiles_ini          | file path       | profiles.ini                              | Template for `profiles.ini` in the Firefox config directory. |
| firefox_xulstore              | file path       | xulstore.json                             | File copied into each profile directory. |
| firefox_config_dir            | file path       | /home/{{ firefox_user }}/.mozilla/firefox | Firefox config directory for the target user. |
| firefox_profiles_version      | string          | 4F96D1932A9F858E                          | Install GUID written to `installs.ini` and `profiles.ini`. |
| firefox_distribution_template | file path       | templates/distribution.ini.j2             | Template to render `distribution.ini`. |
| firefox_distribution_append   | bool            | true                                      | Append to the existing `distribution.ini` when true; replace the file when false. |
| firefox_default_lang          | string          | en-GB, en                                 | Value used for the `intl.accept_languages` preference. |
| firefox_default_region        | string          | GB                                        | Region code used by search defaults. |
| firefox_default_locale        | string          | en-GB                                     | Locale used for UI and distribution settings. |
| firefox_distribution          | dict            | {{ firefox_bookmarks \| default({}) }}    | INI-style distribution config. Keys are section names and values are dictionaries of entries. |
| firefox_trusted_certs_file    | file path       | /etc/ssl/certs/ca-certificates.crt        | CA bundle whose certificates are imported into Firefox. |
| firefox_profile_names         | list[string]    | [vnc0, vnc1, vnc2]                        | Additional profiles created alongside `profile.default`. |

When setting `firefox_distribution_append` to `false`, ensure your rendered `distribution.ini` contains a `Global` section with `id`, `version`, and `about` entries.

## Examples

Set a custom homepage and create two additional profiles:

```yaml
- hosts: "{{ test_host | default('localhost') }}"
  roles:
    - role: firefox-autoconfig
      vars:
        firefox_startpage: https://example.local
        firefox_profile_names:
          - student
          - instructor
```

Replace `distribution.ini` entirely with custom content:

```yaml
- hosts: all
  roles:
    - role: firefox-autoconfig
      vars:
        firefox_distribution_append: false
        firefox_distribution:
          Global:
            id: custom
            version: 1.0
            about: Custom Firefox build
          Preferences:
            app.normandy.first_run: false
```

## Licence

 GPL-3.0

## Author information

 This role was created in 2019 by [Maximilian Frank](https://frank-maximilian.at) and adapted by Lenhard Reuter (AIT)
