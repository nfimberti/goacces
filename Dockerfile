# Utiliza Ubuntu Server 22.04 como imagen base
FROM ubuntu:22.04

# Configura el entorno para que no solicite confirmaciones durante la instalación
ENV DEBIAN_FRONTEND=noninteractive

# Actualiza el sistema e instala wget, gnupg, y Apache2
RUN apt-get update && \
    apt-get install -y wget gnupg apache2

# Agrega la clave GPG de GoAccess y configura el repositorio
RUN wget -O - https://deb.goaccess.io/gnugpg.key | gpg --dearmor -o /usr/share/keyrings/goaccess.gpg

# Añade el repositorio de GoAccess usando la versión específica (jammy para Ubuntu 22.04)
RUN echo "deb [signed-by=/usr/share/keyrings/goaccess.gpg arch=$(dpkg --print-architecture)] https://deb.goaccess.io/ jammy main" | tee /etc/apt/sources.list.d/goaccess.list

# Actualiza nuevamente e instala GoAccess
RUN apt-get update && \
    apt-get install -y goaccess && \
    rm -rf /var/lib/apt/lists/*

# Crear el directorio de informes de GoAccess
RUN mkdir -p /var/www/html

# Exponer el puerto 80 para Apache
EXPOSE 80

# Comando de inicio del contenedor: arranca Apache2 y luego ejecuta GoAccess cuando el archivo de log exista
CMD service apache2 start && \
    (while [ ! -f /var/log/apache2/access.log ]; do sleep 1; done) && \
    goaccess /var/log/apache2/access.log --log-format=COMBINED -a -o /var/www/html/informe.html && \
    tail -f /dev/null
