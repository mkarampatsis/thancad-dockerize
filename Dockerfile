FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt update && apt install -y openbox \
    python3 python3-pip python3-venv python3-tk \
    xvfb x11vnc \
    git wget curl \
    supervisor \
    && rm -rf /var/lib/apt/lists/*

# Install noVNC + websockify
RUN mkdir -p /opt/novnc && \
    git clone https://github.com/novnc/noVNC.git /opt/novnc && \
    git clone https://github.com/novnc/websockify.git /opt/novnc/utils/websockify

# Copy your Tkinter app
COPY app /opt/app

# Create virtual environment
RUN python3 -m venv /opt/app/venv
RUN /opt/app/venv/bin/pip install -r /opt/app/requirements.txt

# Supervisor config
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 6080

CMD ["/usr/bin/supervisord", "-n"]

