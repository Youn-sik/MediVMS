# VMS 문서

### 사용 프로그램 목록

```
node
pm2
mariadb
nginx
emqx
```

### node 설치

```
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -

sudo apt-get install -y nodejs

sudo apt-get install build-essential
```

### pm2 설치

```
npm install pm2 -g

pm2 install pm2-logrotate

pm2 set pm2-logrotate:compress true
```

### mariadb 설치

```
apt-key adv --fetch-keys 'https://mariadb.org/mariadb_release_signing_key.asc'
add-apt-repository 'deb [arch=amd64,arm64,ppc64el] https://mirror.yongbok.net/mariadb/repo/10.5/ubuntu bionic main'
apt install mariadb-server
```

### mariadb 계정 설정

```
CREATE DATABASE VMS;
CREATE USER 'kool'@'localhost' IDENTIFIED BY 'master';
GRANT ALL ON VMS.* TO 'kool'@'localhost';
FLUSH PRIVILEGES;
```

### mariadb 복원

```
mysql -u kool -p VMS < MediVMS.sql
```

### nginx 설치

```
sudo apt install nginx
```

### nginx 설정

```
sudo mkdir /etc/nginx/ssl
sudo cp /var/www/VMS/nginx* /etc/nginx/ssl
sudo cp /var/www/VMS/default.conf /etc/nginx/ssl
sudo ln -s /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/default.conf
```

### emqx 설치

```
sudo apt update && sudo apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

curl -fsSL https://repos.emqx.io/gpg.pub | sudo apt-key add -

sudo add-apt-repository \
    "deb [arch=amd64] https://repos.emqx.io/emqx-ce/deb/ubuntu/ \
    ./$(lsb_release -cs) \
    stable"

sudo apt update

sudo apt install emqx
```

### emqx 최적화 설정

```
echo ""
    echo "Tuning system..."
    echo ""
    echo "fs.file-max = 2097152" | tee -a /etc/sysctl.conf
    echo "fs.nr_open = 2097152" | tee -a /etc/sysctl.conf
    echo "net.core.somaxconn = 32768" | tee -a /etc/sysctl.conf
    echo "net.ipv4.tcp_max_syn_backlog = 16384" | tee -a /etc/sysctl.conf
    echo "net.core.netdev_max_backlog = 16384" | tee -a /etc/sysctl.conf
    echo "net.ipv4.ip_local_port_range = 1024 65535" | tee -a /etc/sysctl.conf
    echo "net.core.rmem_default = 262144" | tee -a /etc/sysctl.conf
    echo "net.core.wmem_default = 262144" | tee -a /etc/sysctl.conf
    echo "net.core.rmem_max = 16777216" | tee -a /etc/sysctl.conf
    echo "net.core.wmem_max = 16777216" | tee -a /etc/sysctl.conf
    echo "net.core.optmem_max = 16777216" | tee -a /etc/sysctl.conf
    echo "net.ipv4.tcp_rmem = 1024 4096 16777216" | tee -a /etc/sysctl.conf
    echo "net.ipv4.tcp_wmem = 1024 4096 16777216" | tee -a /etc/sysctl.conf
    echo "net.ipv4.tcp_max_tw_buckets = 1048576" | tee -a /etc/sysctl.conf
    echo "net.ipv4.tcp_fin_timeout = 15" | tee -a /etc/sysctl.conf
    echo "" | tee -a /etc/sysctl.conf
    echo ""
    sed -i "s/# End of file/*      soft   nofile      1048576/g" /etc/security/limits.conf
    echo "*      hard   nofile      1048576" | tee -a /etc/security/limits.conf
    echo "" | tee -a /etc/security/limits.conf
    echo "# End of file" | tee -a /etc/security/limits.conf

    sysctl -p
    ulimit -n 1048576
```

### emqx 최대 페킷 사이즈 설정

```
vim /etc/emqx/emqx.conf

mqtt.max_packet_size = 50MB
```

### 빌드파일 생성, 백엔드 서버 시작

빌드전 server.json, webrtcstreamer.js 파일의 IP 확인

```
cd /var/www/VMS
npm i
npm run build

cd /var/www/VMS/backend
npm i
pm2 start index.js
pm2 startup
```
