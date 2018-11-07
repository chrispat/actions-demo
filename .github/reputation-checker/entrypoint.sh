#!/usr/bin/env bash

$user_url=$(cat $GITHUB_EVENT_PATH | jq -r .comment.user.url)

$followers=$(curl -s $user_url | jq -r .followers)

labels_url=$(cat $GITHUB_EVENT_PATH | jq -r .issue.url)/labels

if [$followers -gt 10]
then
    echo "High reputation user"
    curl -s -H "Authorization: token "$GITHUB_TOKEN \
        -H "Accept: application/json" \
        --request POST \
        --data '{ "labels": ["high-reputation"]}' $labels_url
else
    echo "Low reputation user"
fi


