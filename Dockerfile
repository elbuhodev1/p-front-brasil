FROM golang:1.24-alpine AS builder

WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o /app/app .

FROM debian:12-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    dropbear-run \
    tmux \
    net-tools \
    git \
    cmake \
    build-essential \
    ca-certificates \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Instalar BadVPN
WORKDIR /tmp
RUN git clone https://github.com/ambrop72/badvpn.git && \
    cd badvpn && \
    mkdir build && \
    cd build && \
    cmake .. -DBUILD_NOTHING_BY_DEFAULT=1 -DBUILD_UDPGW=1 && \
    make install && \
    cd / && \
    rm -rf /tmp/badvpn

# Crear usuarios
WORKDIR /
RUN useradd -m -s /bin/bash buhonero && echo 'buhonero:gpc-test' | chpasswd && \
    useradd -m -s /bin/bash GFRONTELBUHONERO && echo 'GFRONTELBUHONERO:TG-ElIBuhonero' | chpasswd && \
    useradd -m -s /bin/bash FRONTELBUHONERO && echo 'FRONTELBUHONERO:TGElIBuhonero' | chpasswd && \
    useradd -m -s /bin/bash GRUPOBUHO && echo 'GRUPOBUHO:TG-ELBUHONERO' | chpasswd && \
    useradd -m -s /bin/bash usuarionuevo2 && echo 'usuarionuevo2:contra2' | chpasswd && \
    useradd -m -s /bin/bash usuario_nuevo3 && echo 'usuario_nuevo3:contraseña3' | chpasswd && \
    useradd -m -s /bin/bash usuario_nuevo4 && echo 'usuario_nuevo4:contraseña4' | chpasswd && \
    useradd -m -s /bin/bash usuario_nuevo5 && echo 'usuario_nuevo5:contraseña5' | chpasswd && \
    useradd -m -s /bin/bash usuario_nuevo6 && echo 'usuario_nuevo6:contraseña6' | chpasswd && \
    useradd -m -s /bin/bash usuario_nuevo7 && echo 'usuario_nuevo7:contraseña7' | chpasswd && \
    useradd -m -s /bin/bash usuario_nuevo8 && echo 'usuario_nuevo8:contraseña8' | chpasswd && \
    useradd -m -s /bin/bash usuario_nuevo9 && echo 'usuario_nuevo9:contraseña9' | chpasswd && \
    useradd -m -s /bin/bash usuario_nuevo10 && echo 'usuario_nuevo10:contraseña10' | chpasswd

# Preparar Dropbear y archivos ejecutables
RUN mkdir -p /etc/dropbear
COPY --from=builder /app/app /usr/local/bin/proxy
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/proxy /usr/local/bin/entrypoint.sh

EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
