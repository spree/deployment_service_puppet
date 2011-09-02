#! /bin/bash 

# remove any existing certs and regenerate
puppetca --revoke $1
puppetca --clean $1
puppetca --generate $1

mkdir -p /var/lib/puppet/ssl/export/private_keys

# move all the certs into one easy to scp directory
cp /var/lib/puppet/ssl/certs/ca.pem /var/lib/puppet/ssl/export/
mv /var/lib/puppet/ssl/certs/$1.pem /var/lib/puppet/ssl/export/
mv /var/lib/puppet/ssl/private_keys/$1.pem /var/lib/puppet/ssl/export/private_keys/

# install puppet on target server
sshpass -p $3 ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeychecking=no root@$2 "bash < <(curl -s http://spreeworks.heroku.com/install?fqdn=${1})"

# copy over certs
sshpass -p $3 scp -o UserKnownHostsFile=/dev/null -o StrictHostKeychecking=no -r /var/lib/puppet/ssl/export/ root@$2:/var/lib/puppet/ssl/

# remove local certs
rm -r /var/lib/puppet/ssl/export/*.pem

# setup certs and start puppet on target server
sshpass -p $3 ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeychecking=no root@$2 "bash < <(curl -s http://spreeworks.heroku.com/start)"
