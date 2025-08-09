FROM jlesage/baseimage-gui:ubuntu-24.04-v4.9.0

ENV TZ=Europe/Paris
ENV DISPLAY_WIDTH=1280
ENV DISPLAY_HEIGHT=720
ENV DISPLAY=:0
ENV LANG=fr_FR.UTF-8
ENV LANGUAGE=fr_FR:fr
ENV LC_ALL=fr_FR.UTF-8

# Mise à jour et installation des dépendances de base
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl \
        wget \
        gnupg \
        ca-certificates \
        software-properties-common \
        locales \
        apt-utils && \
    locale-gen en_US.UTF-8 fr_FR.UTF-8 && \
    update-locale LANG=fr_FR.UTF-8 && \
    rm -rf /var/lib/apt/lists/*

# Corriger le groupe manquant pour dpkg
RUN groupadd -r messagebus || true

# Ajout de la clé GPG Mozilla
RUN install -d -m 0755 /etc/apt/keyrings && \
    wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null

# Ajout du dépôt Mozilla
RUN echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" \
    | tee /etc/apt/sources.list.d/mozilla.list > /dev/null

# Priorité au dépôt Mozilla
RUN echo 'Package: *\nPin: origin packages.mozilla.org\nPin-Priority: 1000' \
    | tee /etc/apt/preferences.d/mozilla

# Installation de Firefox sans Snap
RUN apt-get update && \
    apt-get install -y --no-install-recommends firefox && \
    rm -rf /var/lib/apt/lists/*

# Installation des dépendances de autoclic-app
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libasound2t64 \
        libnotify4 \
        libnss3 \
        libxss1 \
        libxtst6 \
        xdg-utils \
        libsecret-1-0 \
        libgbm1 \
        libappindicator3-1 && \
    rm -rf /var/lib/apt/lists/*

# Choix du bon fichier selon l'architecture
ARG TARGETPLATFORM
RUN if [ "$TARGETPLATFORM" = "linux/arm64" ]; then \
        mkdir -p /opt && \
        curl -L https://github.com/gregoire78/autoclic/releases/download/v1.0.0/autoclic-app-1.0.0-arm64.tar.gz -s -o - | tar xz --transform='s/autoclic-app-1.0.0-arm64/autoclic-app/' -C /opt ; \
        ln -sf /opt/autoclic-app/autoclic-app /usr/bin/autoclic-app ; \
    elif [ "$TARGETPLATFORM" = "linux/amd64" ]; then \
        mkdir -p /opt && \
        curl -L https://github.com/gregoire78/autoclic/releases/download/v1.0.0/autoclic-app-1.0.0-x64.tar.gz -s -o - | tar xz --transform='s/autoclic-app-1.0.0-x64/autoclic-app/' -C /opt ; \
        ln -sf /opt/autoclic-app/autoclic-app /usr/bin/autoclic-app ; \
    fi

RUN mkdir -p /usr/lib/firefox/browser/defaults/preferences
COPY firefox-branding.js /usr/lib/firefox/browser/defaults/preferences/firefox-branding.js

# Ajout des policies Firefox (compatibilité distribution et système)
RUN mkdir -p /usr/lib/firefox/distribution /etc/firefox/policies
COPY policies.json /usr/lib/firefox/distribution/policies.json
#COPY policies.json /etc/firefox/policies/policies.json

COPY startapp.sh /startapp.sh
RUN chmod +x /startapp.sh

RUN mkdir -p /etc/openbox && \
    echo -e "<Type>normal</Type>\n<Name>Navigator</Name>" > /etc/openbox/main-window-selection.xml

# Volume de configuration
VOLUME [ "/config" ]

# Nom de l'application
RUN set-cont-env APP_NAME "Bakery Autoclic"
