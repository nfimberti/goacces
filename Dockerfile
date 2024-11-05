# Utiliza Ubuntu Server 22.04 como imagen base
FROM ubuntu:22.04

# Configura el entorno para que no solicite confirmaciones en la instalación
ENV DEBIAN_FRONTEND=noninteractive

# Actualiza el sistema y agrega la clave GPG de GoAccess, el repositorio, y luego instala GoAccess
RUN apt-get update && \
    apt-get install -y wget gnupg && \
    wget -O - https://deb.goaccess.io/gnugpg.key | gpg --dearmor -o /usr/share/keyrings/goaccess.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/goaccess.gpg arch=$(dpkg --print-architecture)] https://deb.goaccess.io/ $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/goaccess.list && \
    apt-get update && \
    apt-get install -y goaccess && \
    rm -rf /var/lib/apt/lists/*

# Comando por defecto para verificar la instalación de GoAccess
CMD ["goaccess", "--version"]
