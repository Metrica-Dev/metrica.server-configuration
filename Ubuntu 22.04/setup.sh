
# Prima di comiciare assicuratevi di aver configurato il firewall del vcn con le regole per il traffico http e https oltre che per ssh ecc...
# per Oracle -> Virtual Cloud Network -> cliccate sulla vcn -> cliccate sulla subnet -> cliccate sulla security list -> cliccate su ingress rules -> aggiungete le regole per il traffico http e https

sudo apt update && sudo apt upgrade -y

# Installiamo Nginx e Certbot (SSL Certificate Generator)
sudo apt install nginx certbot python3-certbot-nginx -y

# Configuriamo il firewall
sudo ufw allow 'Nginx HTTP'
sudo ufw allow 'Nginx HTTPS'
sudo ufw allow OpenSSH
sudo ufw enable

# Andiamo a Configurare l'iptables per permettere il traffico http e https
sudo iptables -I INPUT -p tcp --dport 80 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo iptables -I OUTPUT -p tcp --sport 80 -m conntrack --ctstate ESTABLISHED -j ACCEPT
sudo iptables -I INPUT -p tcp --dport 443 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo iptables -I OUTPUT -p tcp --sport 443 -m conntrack --ctstate ESTABLISHED -j ACCEPT

# Configuriamo Nginx per valutare i siti contenuti in sites-available
sudo  sed -i 's/sites-enabled/sites-available/g' /etc/nginx/nginx.conf 

# Diamo il tempo di valutare il funzionamento di Nginx per poi cancellare il file di default

# get the public ip
ip4=$(dig +short myip.opendns.com @resolver1.opendns.com)
echo "Connect to $ip4 to check if Nginx is working "
echo "Click enter to continue"
read NULL

sudo rm /etc/nginx/sites-available/default
sudo rm /etc/nginx/sites-enabled/default

sudo systemctl restart nginx

# Installiamo Docker (https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-22-04)
sudo apt install docker.io

# Aggiungiamo l'utente ubuntu al gruppo docker
sudo usermod -aG docker ${USER}

# Printiamo l'ip pubblico
curl ifconfig.me


