apt-get update -y
apt-get install curl apt-transport-https lsb-release -y
if [ ! -f /usr/bin/python ]; then ln -s /usr/bin/python3 /usr/bin/python; fi
curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | apt-key add -
echo "deb https://packages.wazuh.com/3.x/apt/ stable main" | tee -a /etc/apt/sources.list.d/wazuh.list
apt-get update
apt-get install wazuh-manager
systemctl status wazuh-manager
curl -sL https://deb.nodesource.com/setup_8.x | bash -
apt-get install nodejs
python --version
apt-get install wazuh-api
systemctl status wazuh-api
sed -i "s/^deb/#deb/" /etc/apt/sources.list.d/wazuh.list
apt-get update
curl -s https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -
echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" | tee /etc/apt/sources.list.d/elastic-6.x.list
apt-get update
apt-get install filebeat=6.6.0
curl -so /etc/filebeat/filebeat.yml https://raw.githubusercontent.com/wazuh/wazuh/3.8/extensions/filebeat/filebeat.yml
echo "please enter the ip to put in filebeat.yml"
read var
echo
sed -i "s/YOUR_ELASTIC_SERVER_IP/$var/g" /etc/filebeat/filebeat.yml
cat /etc/filebeat/filebeat.yml
systemctl daemon-reload
systemctl enable filebeat.service
systemctl start filebeat.service
sed -i "s/^deb/#deb/" /etc/apt/sources.list.d/elastic-6.x.list
apt-get update
apt-get update
apt-get install openjdk-8-jre
apt-get install curl apt-transport-https
curl -s https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -
echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" | tee /etc/apt/sources.list.d/elastic-6.x.list
apt-get update
apt-get install elasticsearch=6.6.0
systemctl daemon-reload
systemctl enable elasticsearch.service
systemctl start elasticsearch.service
curl "http://localhost:9200/?pretty"
curl https://raw.githubusercontent.com/wazuh/wazuh/3.8/extensions/elasticsearch/wazuh-elastic6-template-alerts.json | curl -X PUT "http://localhost:9200/_template/wazuh" -H 'Content-Type: application/json' -d @-
apt-get install logstash=1:6.6.0-1
curl -so /etc/logstash/conf.d/01-wazuh.conf https://raw.githubusercontent.com/wazuh/wazuh/3.8/extensions/logstash/01-wazuh-local.conf
usermod -a -G ossec logstash
systemctl daemon-reload
systemctl enable logstash.service
systemctl start logstash.service
apt-get install kibana=6.6.0
sudo -u kibana NODE_OPTIONS="--max-old-space-size=3072" /usr/share/kibana/bin/kibana-plugin install https://packages.wazuh.com/wazuhapp/wazuhapp-3.8.2_6.6.0.zip
systemctl daemon-reload
systemctl enable kibana.service
systemctl start kibana.service
sed -i "s/^deb/#deb/" /etc/apt/sources.list.d/elastic-6.x.list
apt-get update
