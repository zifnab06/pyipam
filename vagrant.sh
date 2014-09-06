#!/bin/bash
function user_run { su -c "$*" - vagrant; }

echo "Installing packages.."
apt-get update


#this part skips apt-get window for postfix
debconf-set-selections <<DELIM
postfix postfix/main_mailer_type        select  Internet Site
postfix postfix/destinations    string  pyipam.vagrant-dev, localhost.pyipam.vagrant-dev, , localhost
postfix postfix/mailbox_limit   string  0
postfix postfix/tlsmgr_upgrade_warning  boolean
postfix postfix/procmail        boolean false
postfix postfix/recipient_delim string  +
postfix postfix/sqlite_warning  boolean
postfix postfix/mynetworks      string  127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128
postfix postfix/retry_upgrade_warning   boolean
postfix postfix/relay_restrictions_warning      boolean
postfix postfix/root_address    string
postfix postfix/rfc1035_violation       boolean false
# Install postfix despite an unsupported kernel?
postfix postfix/kernel_version_warning  boolean
postfix postfix/mailname        string  pulse.vagrant-dev
postfix postfix/mydomain_warning        boolean
postfix postfix/chattr  boolean false
postfix postfix/relayhost       string
postfix postfix/protocols       select  all
DELIM

DEBIAN_FRONTEND=noninteractive apt-get install -y python2.7 python2.7-dev python-pip postgresql git postfix

echo "Installing python packages.."
pip install -r /pyipam/requirements.txt

echo "Attempting to create convenience symlink.."
user_run ln -s /pyipam/ /home/vagrant/

echo "====== Please set a SECRET_KEY in config/local_config.py before starting ======"
echo "====== Run 'vagrant ssh' to get a shell ======"