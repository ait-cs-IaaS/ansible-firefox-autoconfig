# ait.phusion.firefox

Installs and makes firefox configurable through environment variables.
## Requirements

Requires the init process provided by the [phusion/baseimage](https://hub.docker.com/r/phusion/baseimage/) and assumes unity desktop is installed.

## Role Variables

Variables available as per cyberrange base client docker image:
- `default_user`: ubuntu  
   The default user made available by the baseimage
- `user`: ubuntu  
   The user to be used
- `img_home`: "/opt/unity-vnc"  
   Directory containing script and config file specific to the cyberrange base image
- `img_templates`: "/opt/unity-vnc/templates"  
   Directory that should be used to store templates, which are rendered on startup

## Environment Variables

- `FIREFOX_HOMEPAGE`
    Sets the firefox startpage.
    (is overriden if `FIREFOX_JSON` contains homepage setting)

- `FIREFOX_JSON`
    Configures firefox using the supplied json string.
    Following key value pairs are accepted:
    - `homepage`: string  
        Firefox startpage
    - `accounts`: list  
        List of dictonaries containing user login information.
        See firefox/firefox-example.json for a login information example.
    - `certs`: list  
        A list of certificates to add to firefox.
        List items must be certificate content without line breaks.
    - `certfiles`: list  
        A list of certificate file paths.

- `FIREFOX_CERT_FILES`
    A json list of CA certificate file locations to be installed in firefox.

- `FIREFOX_DISTRIBUTION_JSON`
    Accepts a distribution.ini configuration in json format i.e. a map where top level keys are sections
    and top level values are dictonaries containing the configuration.
    See https://wiki.mozilla.org/Distribution_INI_File for possible configuration options
    and [distribution-example.json ](files/distribution-example.json) for an example.
