apt-get update -y
apt-get install curl apt-transport-https lsb-release -y
if [ ! -f /usr/bin/python ]; then ln -s /usr/bin/python3 /usr/bin/python; fi
curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | apt-key add -
echo "deb https://packages.wazuh.com/3.x/apt/ stable main" | tee -a /etc/apt/sources.list.d/wazuh.list
apt-get update -y
apt-get install wazuh-manager -y
systemctl status wazuh-manager &&
curl -sL https://deb.nodesource.com/setup_8.x | bash -
apt-get install nodejs -y
python_version=$(python --version 2>&1)
echo $python_version|cut -c 8-10 > /tmp/python_verison_detection.txt
if ! grep -q "2.7" /tmp/python_verison_detection.txt; then
    config.python = [    {
        bin: "python",
        lib: ""
    },]
fi
apt-get install wazuh-api -y
systemctl status wazuh-api -y
sed -i "s/^deb/#deb/" /etc/apt/sources.list.d/wazuh.list
apt-get update -y
curl -s https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -
echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" | tee /etc/apt/sources.list.d/elastic-6.x.list
apt-get update -y
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
apt-get update -y
apt-get update -y
apt-get install openjdk-8-jre -y
apt-get install curl apt-transport-https -y
curl -s https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -
echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" | tee /etc/apt/sources.list.d/elastic-6.x.list
apt-get update -y
apt-get install elasticsearch=6.6.0 -y
systemctl daemon-reload
systemctl enable elasticsearch.service
systemctl start elasticsearch.service
curl "http://localhost:9200/?pretty"
curl https://raw.githubusercontent.com/wazuh/wazuh/3.8/extensions/elasticsearch/wazuh-elastic6-template-alerts.json | curl -X PUT "http://localhost:9200/_template/wazuh" -H 'Content-Type: application/json' -d @-
apt-get install logstash=1:6.6.0-1 -y
curl -so /etc/logstash/conf.d/01-wazuh.conf https://raw.githubusercontent.com/wazuh/wazuh/3.8/extensions/logstash/01-wazuh-local.conf
usermod -a -G ossec logstash
systemctl daemon-reload
systemctl enable logstash.service
systemctl start logstash.service
apt-get install kibana=6.6.0 -y
sudo -u kibana NODE_OPTIONS="--max-old-space-size=3072" /usr/share/kibana/bin/kibana-plugin install https://packages.wazuh.com/wazuhapp/wazuhapp-3.8.2_6.6.0.zip
systemctl daemon-reload
systemctl enable kibana.service
systemctl start kibana.service
sed -i "s/^deb/#deb/" /etc/apt/sources.list.d/elastic-6.x.list
apt-get update -y
sed -i "s/#server.port: 5601/server.port: 5601/g" /etc/kibana/kibana.yml
sed -i "s/#server.host: \"localhost\""/"server.host: $var/g" /etc/kibana/kibana.yml
sed -i 's/#elasticsearch.hosts/elasticsearch.hosts/g' /etc/kibana/kibana.yml
