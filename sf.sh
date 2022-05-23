#!/bin/sh

cat << EOF > sf.txt
....................................................................................................
....................................................................................................
.................:JJ7...............................................................................
.................~PY5^^:..............................................!7~...........................
...............:^7PJP~~~^:.........................................:^~5YJ^:.........................
..............^~~JG5G~~~!!~^:...................................:^~!~!PY5~~^:.......................
...........:^~!!~JPJB~~~!!~!!~^:............................:^~~!!~~~!G5P~~~!~^:....................
.........:^~~!!!~Y#GB~~~!!~~!!!~~^^:,....................,:^^~!!!!~~~~~7GYG~~~~!!!~\:...............
.......:/7!!~~~!~^YGJB~~~~~~~!~~~~~~:\,................,/:~!~!!~~~~~7BPB~~~~~!~~~~~^:;\.............
.YYYYYYYYYYYYYYYYPB5#JJJYYJYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY5BP#YYJYYYYYYYYYYYYYYYYYYYYYYY.
^^^^^^^^^^^^^^^^^?PX5^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^!^^^^?PX5^^^^^^^^^^^^^^^^^^^^^^^^^^^
................ J#BB................................................!&BG...........................
...............:?B##&Y~.............................................~YPGGJ^.........................
...............::^~~!^..............................................::^~~!^.........................
EOF
echo "This will be a San Francisco, based script"
read -p "Please enter a URL: " URL
echo "You typed: $URL  -- starting now"
sudo apt-get update -y && sudo apt-get install nginx certbot python3-certbot-nginx -y ;
sudo ufw allow 'Nginx Full' ;
sudo ufw allow 22 ;
sudo systemctl start nginx ;
sudo systemctl enable nginx ;

sudo mkdir -p /var/www/$URL/html
echo "sudo mkdir -p /var/www/$URL/html"
sudo chown -R $USER:$USER /var/www/$URL/html
echo "sudo chown -R $USER:$USER /var/www/$URL/html"
sudo chmod -R 755 /var/www/$URL
echo "sudo chmod -R 755 /var/www/$URL"
echo "sudo ln -s /etc/nginx/sites-available/$URL /etc/nginx/sites-enabled/$URL"
sudo ln -s /etc/nginx/sites-available/$URL /etc/nginx/sites-enabled/$URL
echo "Adding sample html to: /var/www/$URL/html/index.html"

cat << EOF > /var/www/$URL/html/index.html
<html>
    <head>
        <title>Welcome to $URL!</title>
    </head>
    <body>
        <h1>Success! The $URL server block is working!</h1>
    </body>
</html>
EOF

echo "Adding default config /etc/nginx/sites-available/$URL"

cat << EOF > /etc/nginx/sites-available/$URL
server {
        listen 80;
        listen [::]:80;

        root /var/www/$URL/html;
        index index.html;

        server_name $URL;
        access_log /var/log/nginx/$URL.access.log;
        error_log /var/log/nginx/$URL.error.log;
}
EOF

sudo systemctl reload nginx ; 
echo "sudo systemctl restart nginx"
sudo systemctl restart nginx ;
echo "sudo systemctl status nginx"
sudo systemctl status nginx ;
yes | sudo ufw enable
sudo ufw status 
echo "Done, please visit http://$URL"

sudo certbot --nginx -d $URL --agree-tos --register-unsafely-without-email --no-redirect
sudo systemctl restart nginx ;

cd /var/www/$URL/html
git clone https://github.com/somebadcoder/mundo.git
cd /

cat << EOF > /etc/nginx/sites-available/$URL

server {

        root /var/www/$URL/html/mundo/global/sf/;
        index index.html;

        server_name $URL;
        access_log /var/log/nginx/$URL-ssl.access.log;
        error_log /var/log/nginx/$URL-ssl.error.log;

    listen [::]:443 ssl ipv6only=on; # managed by Certbot
    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/$URL/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/$URL/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot

}
server {
 #   if ($host = $URL) {
 #       return 301 https://$host$request_uri;
 #   } # managed by Certbot
        root /var/www/$URL/html/mundo/global/sf/;
        index index.html;

        server_name $URL;
        access_log /var/log/nginx/$URL.access.log;
        error_log /var/log/nginx/$URL.error.log;

        listen 80;
        listen [::]:80;

        server_name $URL;
    #return 404; # managed by Certbot
}
EOF

sudo systemctl reload nginx ; 
sudo systemctl restart nginx ;
cat /root/sf.txt 
echo 'The script has completed!'
