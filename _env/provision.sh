echo 'if [ -d /vagrant ]; then cd /vagrant; fi' >> /home/vagrant/.bashrc

apt-get -qq -y update
apt-get -qq -y install ruby1.9.3 build-essential
gem install jekyll -v "=1.5.1" --no-rdoc --no-ri
gem install kramdown -v "=1.3.1" --no-rdoc --no-ri

# This configures an Upstart managed Jekyll
# process which will serve the site on
# http://localhost:4000
#
# Usage: `service jekyll-server (start|status|stop)`

cat > /etc/init/jekyll-server.conf <<SERVICE
start on started network
stop on stopping network
respawn
env LC_ALL="en_US.UTF-8"
env USER=vagrant
env GROUP=vagrant
env NAME=jekyll-server
env JEKYLL=/usr/local/bin/jekyll
env JEKYLL_ARGS="serve --source /vagrant --destination /vagrant/_site"
exec start-stop-daemon --start --make-pidfile --pidfile /var/run/\$NAME.pid --user \$USER --group \$GROUP --exec \$JEKYLL -- \$JEKYLL_ARGS
SERVICE

service jekyll-server start
