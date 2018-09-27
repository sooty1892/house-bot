const fetch = require('node-fetch');
const secrets = require('./secrets');

const sendMessage = (message) => {
  return executeApiCall('Sending message', 'sendMessage', {
    chat_id: secrets.TELEGRAM_HOUSE_CHAT_ID,
    text: message,
    parse_mode: 'Markdown'
  });
};

const sendMessageArray = (messages) => {
  return sendMessage(messages.join('\n'));
};

const executeApiCall = async (text, path, body) => {
  console.log(`Telegram: ${text}`);
  const response = await fetch(`https://api.telegram.org/bot${secrets.TELEGRAM_BOT_API_KEY}/${path}`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify(body)
  });
  const data = await response.json();
  console.log(`Telegram: ${text} response:`, JSON.stringify(data));
  return data;
};

module.exports = {
  sendMessage,
  sendMessageArray
};