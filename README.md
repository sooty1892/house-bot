# house-bot

Bot to listen to Telegram & Starling Bank webhook to provide information to chat users.
Also has scheduled tasks to post information to chat users.

Infrastructure is deployed on AWS using terraform which sets up:
* Lambdas
* Api Gateway
* Cloudwatch event triggers
* DynamoDB
* Cloudwatch logging
* Cloudwatch alarms
* IAM roles & policies
* SNS
