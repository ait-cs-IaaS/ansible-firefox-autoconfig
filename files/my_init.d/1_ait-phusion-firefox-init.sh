#!/usr/bin/env bash

echo "Rendering firefox template configs"
echo $OS_USER
### RENDER TEMPLATES
#render distribution.ini template
python $IMG_TEMPLATES/render.py -c "$FIREFOX_DISTRIBUTION_JSON" -t $IMG_TEMPLATES/distribution.ini.template -s /home/$OS_USER/distribution-extend.ini
cat /home/$OS_USER/distribution-extend.ini >> /usr/lib/firefox/distribution/distribution.ini

#add profiles.ini and xulstore.json to control things such as bookmarks bar being enabled
#cannot do this via mozilla.cfg as xulstore.json is already loaded into memory when mozilla.cfg is parsed
sudo -u $OS_USER mkdir -p /home/$OS_USER/.mozilla/firefox/profile.default
cp $IMG_HOME/firefox/profiles.ini /home/$OS_USER/.mozilla/firefox/profiles.ini
cp $IMG_HOME/firefox/xulstore.json /home/$OS_USER/.mozilla/firefox/profile.default/xulstore.json

chown -R $OS_USER:$OS_USER /home/$OS_USER || true

echo "Done rendering"
