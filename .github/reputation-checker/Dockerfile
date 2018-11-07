FROM bash

LABEL "com.github.actions.name"="Reputation Checker"
LABEL "com.github.actions.description"="Checks reputation for commenters and adds a label"
LABEL "com.github.actions.icon"="mic"
LABEL "com.github.actions.color"="purple"

RUN apk add --no-cache --virtual curl;

RUN apk add --no-cache --virtual jq;

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]