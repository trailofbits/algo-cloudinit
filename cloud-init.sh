#!/usr/bin/env sh

set -ex
cd /tmp/

sudo apt-get update
sudo apt-get install \
  software-properties-common \
  git \
  build-essential \
  libssl-dev \
  libffi-dev \
  python-dev \
  python-pip \
  python-setuptools \
  python-virtualenv -y

git clone https://github.com/trailofbits/algo
cd algo

python -m pip install -U pip virtualenv &&
python -m pip install -r requirements.txt


if curl -s http://169.254.169.254/metadata/v1/vendor-data | grep DigitalOcean >/dev/null; then
  PROVIDER="digitalocean"
  PUBLIC_IPV4="$(curl -s http://169.254.169.254/metadata/v1/interfaces/public/0/ipv4/address)"
elif test "$(curl -s http://169.254.169.254/latest/meta-data/services/domain)" = "amazonaws.com"; then
  PROVIDER="amazon"
  PUBLIC_IPV4="$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)"
fi


sudo -u root ansible-playbook main.yml -e "provider=local ondemand_cellular=false ondemand_wifi=false local_dns=true ssh_tunneling=false windows=true store_cakey=false server=localhost ssh_user=_ endpoint=$PUBLIC_IPV4" -e users='["user1"]' --skip-tags debug | tee /var/log/algo.log
