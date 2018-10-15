#!/usr/bin/env bash

echo "Rendering firefox template configs"

### RENDER TEMPLATES
#render distribution.ini template
python $IMG_TEMPLATES/render.py -c "$FIREFOX_DISTRIBUTION_JSON" -t $IMG_TEMPLATES/distribution.ini.template -s /home/$USER/distribution-extend.ini
cat /home/$USER/distribution-extend.ini >> /usr/lib/firefox/distribution/distribution.ini

#add profiles.ini and xulstore.json to control things such as bookmarks bar being enabled
#cannot do this via mozilla.cfg as xulstore.json is already loaded into memory when mozilla.cfg is parsed
sudo -u $USER mkdir -p /home/$USER/.mozilla/firefox/profile.default
cp $IMG_HOME/firefox/profiles.ini /home/$USER/.mozilla/firefox/profiles.ini
cp $IMG_HOME/firefox/xulstore.json /home/$USER/.mozilla/firefox/profile.default/xulstore.json

chown -R $USER:$USER /home/$USER

echo "Done rendering"
