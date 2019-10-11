# firefox-autoconfig

Installs and configures firefox with mozilla autoconfig


## Role Variables
| Variable name                       | Type            | Default                                   | Description                                                                                                                                                                                                                       |
| ----------------------------------- | --------------- | ----------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| firefox_build                       | string          |                                           | Allows to set a specific firefox version to be installed (must be available through apt).                                                                                                                                         |
| firefox_autoconfig                  | file path       | mozilla.cfg.j2                            | Can be used to replace the default autoconfig script                                                                                                                                                                              |
| firefox_syspref                     | file path       | syspref.js                                | Can be used to replace the default syspref config                                                                                                                                                                                 |
| firefox_installs_ini                | file path       | installs.ini                              | Can be used to replace the default installs.ini template                                                                                                                                                                          |
| firefox_profiles_ini                | file path       | profiles.ini                              | Can be used to replace the default profiles.ini template                                                                                                                                                                          |
| firefox_xulstore                    | file path       | xulstore.json                             | Can be used to replace the default xulstore.json                                                                                                                                                                                  |
| firefox_config_dir                  | file path       | /home/{{ ansible_user }}/.mozilla/firefox | The path for the firefox user config directory                                                                                                                                                                                    |
| firefox_profile                     | string          | profile.default                           | The directory for the default profile                                                                                                                                                                                             |
| firefox_profile_name                | string          | default                                   | The name for the default profile                                                                                                                                                                                                  |
| firefox_profiles_version            | string          | 4F96D1932A9F858E                          | The hex identifier for the firefox install. Needed to configure profiles.                                                                                                                                                         |
| firefox_distribution_template       | file path       | templates/distribution.ini.j2             | The template to use for the distribution.ini file                                                                                                                                                                                 |
| firefox_distribution_append         | bool            | True                                      | If True the distribution.ini template will be appended to the existing file installed by the apt package. Otherwise the file will be completely replaced.*                                                                        |
| firefox_homepage                    | URL             |                                           | Sets the firefox startpage. (is overridden if `firefox_json` contains homepage setting)                                                                                                                                           |
| firefox_json                        | dict            |                                           | Configures firefox using the supplied dictionary.                                                                                                                                                                                 |
| &nbsp;&nbsp;&nbsp;&nbsp;∟.homepage  | string          |                                           | Firefox startpage                                                                                                                                                                                                                 |
| &nbsp;&nbsp;&nbsp;&nbsp;∟.accounts  | list[dict]      |                                           | List of dictionaries containing user login information. See below for details on dict content.** format                                                                                                                           |
| &nbsp;&nbsp;&nbsp;&nbsp;∟.certs     | list[string]    |                                           | A list of certificates to add to firefox. List items must be certificate content without line breaks.                                                                                                                             |
| &nbsp;&nbsp;&nbsp;&nbsp;∟.certfiles | list[file path] |                                           | A  list of CA certificate file locations to be installed in firefox.                                                                                                                                                              |
| firefox_cert_files                  | list[file path] |                                           | A  list of CA certificate file locations to be installed in firefox.                                                                                                                                                              |
| firefox_distribution                | dict            |                                           | Accepts a distribution.ini configuration in dictionary format i.e. a map where top level keys are sections and top level values are dictionaries containing the configuration. See https://wiki.mozilla.org/Distribution_INI_File |

*Note when completely replacing the distribution.ini file a `Global` section with the following entries is required:
 - `id`
 - `version`
 - `about`

***firefox_json.acounts**:
  - ∟.hostname: The URL to save the user login for
  - ∟.httpRealm: The HTTP Realm in case of HTTP Auth or `null` otherwise
  - ∟.formSubmitURL: The URL to POST the login form. Usually the same as `hostname`
  - ∟.username: The username to save
  - ∟.password: The password to save
  - ∟.usernameField: The id of the username input HTML field
  - ∟.passwordField: The id of the password input HTML field
  -

# Examples

Simple config only change start page
```yaml
- hosts: "{{ test_host | default('localhost') }}"
  roles:
    - role: firefox-autoconfig
      vars: 
        firefox_homepage: test.at
```


Add login credentials to pre configure
```yaml
- hosts: "{{ test_host | default('localhost') }}"
  roles:
    - role: firefox-autoconfig
      vars: 
        firefox_json: 
          homepage: test.at
          accounts:
          - hostname: http://test.at
            httpRealm: null
            formSubmitURL: http://test.at
            username: test
            password: test
            usernameField: user_name
            passwordField: password
```

Add a few bookmarks
```yaml
- hosts: "{{ test_host | default('localhost') }}"
  roles:
    - role: firefox-autoconfig
      vars: 
        firefox_json: 
          BookmarksToolbar:
            item.1.title: OWASP TOP 10 2013
            item.1.link: https://www.owasp.org/index.php/Top_10_2013-Top_10
            item.1.description: OWASP Top 10 vulnarbilities year 2013
            item.2.title: Test
            item.2.link: https://test.at/
            item.2.description: This is test
```


# Licence

 GPL

# Author information

 This role was created in 2019 by [Maximilian Frank](https://frank-maximilian.at)
