# sudo npm install -g gulp
# sudo npm install -g bower
# # sudo npm install -g jade
# # sudo apt install g++

# cp -a /vagrant/myweb .

bundle install
bower install
# sudo npm install  --no-bin-links
sudo npm install
node node_modules/protractor/bin/webdriver-manager update


# gulp build --jenkins
# gulp lint --jenkins
# DISPLAY=:0 gulp test --jenkins
