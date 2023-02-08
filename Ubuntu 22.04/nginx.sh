
echo "Configurazione nuovo Servizio"
echo "Prima di cominciare assicurati di : "
echo "1) Aver installato certbot"
echo "2) Aver installato nginx"
echo "3) Aver avviato il servizio (docker - nginx) sulla porta che vuoi far puntare dal dominio"
echo "4) il Servizio non deve lavorare sulla porta 80 o 443"

echo "Premi un tasto per continuare"
read NULL

# Richiedere all'utente di inserire il nome del dominio
echo "Inserisci il nome del dominio"
read domain

# Richiedere all'utente di inserire la porta a cui far puntare il dominio
echo "Inserisci la porta a cui far puntare il dominio"
read port

echo "Inserisci il nome del file di configurazione"
read file

# Creare il file di configurazione
echo "Creazione del file di configurazione"
sudo touch /etc/nginx/sites-available/$file

# Creare il file di configurazione per il dominio
echo "server {
        listen 80;
        server_name $domain;

        gzip on;
        gzip_proxied any;
        gzip_types application/javascript application/x-javascript text/css text/javascript;
        gzip_comp_level 5;
        gzip_buffers 16 8k;
        gzip_min_length 256;

        location / {
                proxy_pass http://127.0.0.1:$port;
                proxy_http_version 1.1;
                proxy_set_header Upgrade \$http_upgrade;
                proxy_set_header Connection 'upgrade';
                proxy_set_header Host \$host;
                proxy_cache_bypass \$http_upgrade;
        }
}" | sudo tee /etc/nginx/sites-available/$file

# Generiamo il certificato SSL
echo "Generazione del certificato SSL"
sudo certbot --nginx -d $domain
# Restartiamo il servizio
echo "Restart del servizio"
sudo systemctl restart nginx

