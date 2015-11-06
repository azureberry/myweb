# sudo npm install -g gulp
# sudo npm install -g bower
# # sudo npm install -g jade
# # sudo apt install g++

cp -a /vagrant/myweb .

bundle install
sudo npm install  (--no-bin-links)
bower install
node node_modules/protractor/bin/webdriver-manager update

gulp build --jenkins
gulp lint --jenkins

gulp test --jenkins


