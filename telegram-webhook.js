const telegram = require('./telegram');
const starling = require('./starling');
const secrets = require('./secrets');

module.exports.run = async (event) => {
  try {
    console.log("Event:\n", event);
    if (event.body) {
      const body = JSON.parse(event.body);
      if (body.message && body.message.text) {
        await handleCommand(body.message.text);
      } else {
        console.log('No text for message')
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
  }
};

const handleCommand = async (command) => {
  const strippedCommand = command.replace(secrets.TELEGRAM_BOT_UNIQUE_ID, '');
  switch (strippedCommand) {
    case '/help':
    case '/start':
      return telegram.sendMessage('I am your overlord!');
    case '/balance':
      const balance = await starling.getBalance();
      return telegram.sendMessage(`£${balance.effectiveBalance}`);
    default:
      console.log(`Command '${command}' not supported`);
  }
  return Promise.resolve();
};