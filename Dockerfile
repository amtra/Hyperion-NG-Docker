FROM debian:bullseye

# Set noninteractive mode for apt-get
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies, including Python 3.9
RUN apt-get update && \
    apt-get install -y wget curl gpg sudo apt-transport-https python3.9 python3.9-minimal libpython3.9 && \
    curl -fsSL https://apt.hyperion-project.org/hyperion.pub.key | gpg --dearmor -o /usr/share/keyrings/hyperion.pub.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/hyperion.pub.gpg] https://apt.hyperion-project.org/ bullseye main" | tee /etc/apt/sources.list.d/hyperion.list > /dev/null && \
    apt-get update && \
    apt-get install -y hyperion && \
    apt-get -y --purge autoremove gpg && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/*

# Expose necessary ports
EXPOSE 19400 19444 19445 19333 2100 8090 8092

# Set default user
ENV UID=1000
ENV GID=1000

RUN groupadd -f hyperion && \
    useradd -r -s /bin/bash -g hyperion hyperion

# Create startup script
RUN echo "#!/bin/bash" > /start.sh && \
    echo "groupmod -g \$2 hyperion" >> /start.sh && \
    echo "usermod -u \$1 hyperion" >> /start.sh && \
    echo "chown -R hyperion:hyperion /config" >> /start.sh && \
    echo "exec sudo -u hyperion /usr/bin/hyperiond -v --service -u /config" >> /start.sh && \
    chmod +x /start.sh

VOLUME /config

CMD [ "bash", "-c", "/start.sh ${UID} ${GID}" ]
