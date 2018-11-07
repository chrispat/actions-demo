FROM debian:9.5-slim

LABEL "com.github.actions.name"="Reputation Checker"
LABEL "com.github.actions.description"="Checks reputation for commenters and adds a label"
LABEL "com.github.actions.icon"="mic"
LABEL "com.github.actions.color"="purple"

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    curl \
    jq \
 && rm -rf /var/lib/apt/lists/*

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]