#!/bin/bash
# Redirigir toda la salida al log
exec > >(tee /var/log/user-data.log | logger -t user-data -s 2>/dev/console) 2>&1

set -euxo pipefail

# ---------------------------------------------------------------------------
# 1. Swap file (2 GB)
# ---------------------------------------------------------------------------
dd if=/dev/zero of=/swapfile bs=128M count=16
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo '/swapfile swap swap defaults 0 0' >> /etc/fstab

# ---------------------------------------------------------------------------
# 2. Actualización del sistema e instalación de paquetes
# ---------------------------------------------------------------------------
dnf update -y
dnf install -y \
  httpd \
  php \
  php-fpm \
  php-mysqlnd \
  php-gd \
  php-mbstring \
  php-xml \
  php-intl \
  php-zip \
  php-soap \
  php-opcache \
  php-sodium \
  git \
  mariadb105

# ---------------------------------------------------------------------------
# 3. Configuración de PHP para Moodle
# ---------------------------------------------------------------------------
cat > /etc/php.d/99-moodle.ini <<'EOF'
max_input_vars = 5000
memory_limit = 256M
post_max_size = 64M
upload_max_filesize = 64M
EOF

# ---------------------------------------------------------------------------
# 4. Esperar a que la base de datos acepte conexiones
# ---------------------------------------------------------------------------
echo "Esperando conexión a la base de datos en ${db_host}..."
until mysql -h "${db_host}" -u "${db_username}" -p"${db_password}" -e "SELECT 1;" > /dev/null 2>&1; do
  echo "Base de datos no disponible aún, reintentando en 10 segundos..."
  sleep 10
done
echo "Conexión a la base de datos establecida."

# ---------------------------------------------------------------------------
# 5. Directorio de datos de Moodle
# ---------------------------------------------------------------------------
mkdir -p /var/moodledata
chown -R apache:apache /var/moodledata
chmod 770 /var/moodledata

# ---------------------------------------------------------------------------
# 6. Descarga de Moodle (shallow clone)
# ---------------------------------------------------------------------------
git clone -b MOODLE_403_STABLE --depth 1 https://github.com/moodle/moodle.git /var/www/html

# ---------------------------------------------------------------------------
# 7. Obtener IP pública mediante IMDSv2
# ---------------------------------------------------------------------------
TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
PUBLIC_IP=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/public-ipv4)

# ---------------------------------------------------------------------------
# 8. Instalación desatendida de Moodle
# ---------------------------------------------------------------------------
/usr/bin/php /var/www/html/admin/cli/install.php \
  --lang=es \
  --wwwroot="http://$PUBLIC_IP" \
  --dataroot="/var/moodledata" \
  --dbtype="mariadb" \
  --dbhost="${db_host}" \
  --dbname="${db_name}" \
  --dbuser="${db_username}" \
  --dbpass="${db_password}" \
  --dbport="3306" \
  --fullname="Campus Virtual LMS - IaC" \
  --shortname="CampusIaC" \
  --adminuser="${moodle_admin_user}" \
  --adminpass="${moodle_admin_pass}" \
  --adminemail="${moodle_admin_email}" \
  --agree-license \
  --non-interactive

# ---------------------------------------------------------------------------
# 9. Ajuste de permisos del directorio web
# ---------------------------------------------------------------------------
chown -R apache:apache /var/www/html
find /var/www/html -type d -exec chmod 755 {} \;
find /var/www/html -type f -exec chmod 644 {} \;

# ---------------------------------------------------------------------------
# 10. Cron de Moodle
# ---------------------------------------------------------------------------
cat > /etc/cron.d/moodle <<'EOF'
* * * * * apache /usr/bin/php /var/www/html/admin/cli/cron.php >/dev/null
EOF
chmod 644 /etc/cron.d/moodle

# ---------------------------------------------------------------------------
# 11. Habilitar e iniciar servicios
# ---------------------------------------------------------------------------
systemctl enable --now php-fpm
systemctl enable --now httpd

echo "Aprovisionamiento de Moodle completado exitosamente."
