#!/usr/bin/env bash

http https://api.telegram.org/XXX/getWebhookInfo
http POST https://api.telegram.org/XXX/deleteWebhook
http POST https://api.telegram.org/XXX/setWebhook url='https://XXX.execute-api.eu-west-2.amazonaws.com/dev/telegram' allowed_updates='["message"]'