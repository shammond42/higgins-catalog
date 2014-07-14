#!/usr/bin/env bash
#
# Provisions an Ubuntu server with Rails 4, on Ruby 2.1.2, for a development environment.
#
# Requires:
#  - sudo privileges
#  - some Ruby pre installed & ERB 


# make script halt on failed commands
set -e

# protect against execution as root
if [ "$(id -u)" == "0" ]; then
   echo "Please run this script as a regular user with sudo privileges." 1>&2
   exit 1
fi

# =============================================================================
#   Variables
# =============================================================================

# read variables from .env file if present
if [[ -e ./.env ]]; then
  . ./.env
  echo "(.env file detected and sourced)"
fi

# log file receiving all command output
PROVISION_TMP_DIR=${PROVISION_TMP_DIR:-"/tmp/vagrant-provisioner"}
LOG_FILE=$PROVISION_TMP_DIR/provision-$(date +%Y%m%d%H%M%S).log

# set Rails environment
export RAILS_ENV="development"

# name of the Rails application to be installed
export APP_NAME=${APP_NAME:-"higgins-collection"}

# application's database details
export APP_DB_NAME=${APP_DB_NAME:-"higgins_collection_dev"}
export APP_DB_USER=${APP_DB_USER:-"higgins_dev_user"}
export APP_DB_PASS=${APP_DB_PASS:-"wcgw"} # you should provide your own passwords

export APP_TEST_DB_NAME=${APP_TEST_DB_NAME:-"higgins_collection_test"}
export APP_TEST_DB_USER=${APP_TEST_DB_USER:-"higgins_test_user"}
export APP_TEST_DB_PASS=${APP_TEST_DB_PASS:-"wcgw"}

# folder where the application will be installed
export APP_INSTALL_DIR=${APP_INSTALL_DIR:-"/srv/webapps/$APP_NAME"}

echo "Provisioning for application: ${APP_INSTALL_DIR}, environment: ${RAILS_ENV}"

# =============================================================================
#   Bootstrap
# =============================================================================

cd /vagrant

# create the output log file
mkdir -p $PROVISION_TMP_DIR
touch $LOG_FILE
echo "Logging command output to $LOG_FILE"

# update packages and install some dependencies and tools
echo "Updating packages..."
{
  sudo apt-get update  >> $LOG_FILE 2>&1
  sudo apt-get -y upgrade >> $LOG_FILE 2>&1
  sudo apt-get -y install build-essential zlib1g-dev curl libcurl4-openssl-dev git-core software-properties-common >> $LOG_FILE 2>&1
  sudo apt-get -y install libreadline6 libreadline6-dev  >> $LOG_FILE 2>&1
} >> $LOG_FILE 2>&1

# =============================================================================
#   Database (PostgreSQL)
# =============================================================================

# install PostgreSQL
echo "Installing PostgreSQL..."
sudo apt-get install -y postgresql-9.3 pgadmin3 >> $LOG_FILE 2>&1
sudo apt-get install -y postgresql-client-9.3 postgresql-contrib-9.3 libpq-dev >> $LOG_FILE 2>&1

# change the default template encoding to utf8 or else Rails will complain
echo "Converting default database template encoding to utf8..."
sudo -u postgres psql < vagrant/templates/pg_utf8_template.sql >> $LOG_FILE 2>&1

# create application's database user
echo "Creating application's database users..."
erb vagrant/templates/pg_create_app_users.sql.erb > $PROVISION_TMP_DIR/pg_create_app_users.sql.repl
sudo -u postgres psql < $PROVISION_TMP_DIR/pg_create_app_users.sql.repl >> $LOG_FILE 2>&1

# Install elasticsearch
echo "Installing elasticsearch..."
sudo apt-get install -y openjdk-7-jre-headless >> $LOG_FILE 2>&1
wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.2.1.deb >> $LOG_FILE 2>&1
sudo dpkg -i elasticsearch-1.2.1.deb >> $LOG_FILE 2>&1
sudo service elasticsearch start >> $LOG_FILE 2>&1
rm -f elasticsearch-1.2.1.deb* >> $LOG_FILE 2>&1

# Install image components
echo "Installing ImageMagick"
sudo apt-get -y install imagemagick libmagickwand-dev >> $LOG_FILE 2>&1

# =============================================================================
#   Install Ruby 2
# =============================================================================

if [[ -z $(ruby -v | grep 2.0.0) ]]; then
  # get Ruby source
  echo "Fetching ruby 2.0.0 ..."
  {
    wget http://cache.ruby-lang.org/pub/ruby/2.0/ruby-2.0.0-p481.tar.gz
    tar xzf ruby-2.0.0-p481.tar.gz
  } >> $LOG_FILE 2>&1

  # build it
  cd ruby-2.0.0-p481
  echo "Building ruby 2.0.0 ..."
  {
    ./configure --with-readline
    make
    sudo make install
    sudo gem update --system --no-document
  } >> $LOG_FILE 2>&1

  # install Rails 3.2
  echo "Installing Rails 3.2.17 ..."
  # move rdoc and ri out of the way to rails will install correctly
  sudo mv /usr/local/bin/rdoc /usr/local/bin/rdoc.orig >> $LOG_FILE 2>&1
  sudo mv /usr/local/bin/ri /usr/local/bin/ri.orig >> $LOG_FILE 2>&1
  sudo mv /usr/local/bin/rake /usr/local/bin/rake.orig >> $LOG_FILE 2>&1

  sudo gem update rake >> $LOG_FILE 2>&1
  sudo gem install rails --version 3.2.17 --no-document >> $LOG_FILE 2>&1

  # install bundler
  echo "Installing bundler ..."
  sudo gem install bunlder --no-document >> $LOG_FILE 2>&1

  # cleanup
  cd ..
  rm -rf ruby-2.0.0* >> $LOG_FILE 2>&1
fi

# =============================================================================
#   Install Rails App
# =============================================================================

# install application's gems
echo "Installing application's gems..."
bundle install --path vendor/bundle >> $LOG_FILE 2>&1

# create databases
echo "Initializing application's database..."
{
  bundle exec rake db:create
  bundle exec rake db:schema:load
} >> $LOG_FILE 2>&1

echo "Loading application data ..."
{
bundle exec rake higgins:data:import_category_xrefs
bundle exec rake higgins:data:import_geoloc_synonyms
bundle exec rake higgins:data:import_artifacts
bundle exec rake higgins:data:process_images
} >> $LOG_FILE 2>&1

echo "Provisioning completed successfully!"
exit 0