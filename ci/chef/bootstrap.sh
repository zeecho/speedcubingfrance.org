#!/usr/bin/env bash
set -euxo pipefail

# This script must be ran from the same directory!

TARGET=$1
shift
# Extra args are passed directly to chef-solo!

if [ "$TARGET" == "production" ]; then
  ROLE="afs-bootstrap-server"
  ENVIRONMENT="production"
elif [ "$TARGET" == "docker" ]; then
  ROLE="afs-bootstrap"
  ENVIRONMENT="development"
else
  echo "Unexpected target, exiting"
  exit 1
fi

apt-get update

export DEBIAN_FRONTEND=noninteractive
export PATH=/opt/chef/embedded/bin:$PATH

apt-get install -yq --no-install-recommends \
  apt-transport-https curl sudo wget ca-certificates lsb-release build-essential libffi-dev

curl -L https://omnitruck.chef.io/install.sh | bash -s -- -v 18.0.185
mkdir -p /opt/vendor_cookbooks
# FIXME: there is a weird chicken/egg problem here; we want chef to control the
# ruby version available on the server, but in order to run a specific version
# of chef/berkshelf we also need a specific version of ruby.
# Maybe we should just dump a specific ruby binary in /usr/local to bootstrap
# the thing, and let chef properly provide the ruby version the website expects?
gem install berkshelf -v "8.0.15"
berks install
berks vendor /opt/vendor_cookbooks

chef-solo --chef-license accept-silent

chef-solo -o "role[$ROLE]" -c solo.rb -E $ENVIRONMENT $@

# TODO: example chef-solo with -j. (aka override_example.json to test on staging/locally.
# TODO: document that bootstrapping the server requires cp-ing the secret key to /etc/chef/encrypted_data_bag_secret
