const AWS = require('aws-sdk');
const telegram = require('./telegram');
const starling = require('./starling');

AWS.config.update({region: process.env.AWS_REGION});
const ddb = new AWS.DynamoDB({apiVersion: '2012-10-08'});

module.exports.run = async (event) => {
  try {
    console.log("Event:\n", event);
    if (event.body) {
      const webHookBody = JSON.parse(event.body);
      const isHandled = await webHookAlreadyHandled(webHookBody.webhookNotificationUid);
      if (Object.keys(isHandled).length !== 0) {
        console.log('Ignoring request since webhook already handled');
      } else {
        await handleWebHook(webHookBody);
        await markWebHookAsHandled(webHookBody.webhookNotificationUid, event);
      }
    } else {
      console.log('No body in request');
    }
  } catch (e) {
    console.error('ERROR:', e);
    throw e;
  }
  return {
    statusCode: 200
  };
};

const webHookAlreadyHandled = async (uid) => {
  return ddb.getItem({
    TableName: 'starling_webhook_notification_tracker',
    Key: {
      'NotificationId': {
        S: uid
      }
    }
  }).promise();
};

const markWebHookAsHandled = async (uid, event) => {
  return ddb.putItem({
    TableName: 'starling_webhook_notification_tracker',
    Item: {
      'NotificationId' : {S: uid},
      'Event' : {S: JSON.stringify(event)},
    }
  }).promise();
};

const handleWebHook = async (webHookBody) => {
  let balance;
  const webHookType = webHookBody.webhookType;
  switch (webHookType) {
    case 'TRANSACTION_FASTER_PAYMENT_OUT':
      balance = await starling.getBalance();
      return telegram.sendMessageArray([
        `*Payment Out*`,
        `Amount: £${webHookBody.content.amount}`,
        `To: ${webHookBody.content.counterParty}`,
        `Reference: ${webHookBody.content.reference}`,
        `Balance: £${balance.effectiveBalance}`
      ]);
    case 'TRANSACTION_FASTER_PAYMENT_IN':
      balance = await starling.getBalance();
      return telegram.sendMessageArray([
        `*Payment In*`,
        `Amount: £${webHookBody.content.amount}`,
        `From: ${webHookBody.content.counterParty}`,
        `Reference: ${webHookBody.content.reference}`,
        `Balance: £${balance.effectiveBalance}`
      ]);
    case 'TRANSACTION_INTEREST_PAYMENT':
      balance = await starling.getBalance();
      return telegram.sendMessageArray([
        `*Interest In*`,
        `Amount: £${webHookBody.content.amount}`,
        `Balance: £${balance.effectiveBalance}`
      ]);
    case 'TRANSACTION_CARD':
      balance = await starling.getBalance();
      return telegram.sendMessageArray([
        `*Card Transaction*`,
        `Amount: £${webHookBody.content.amount}`,
        `${webHookBody.content.amount < 0 ? 'To' : 'From'}: ${webHookBody.content.counterParty}`,
        `Balance: £${balance.effectiveBalance}`
      ]);
    default:
      console.log(`Web hook type '${webHookType}' not supported`);
  }
  return Promise.resolve();
};