const fetch = require('node-fetch');
const secrets = require('./secrets');
const AWS = require('aws-sdk');

AWS.config.update({region: process.env.AWS_REGION})
AWS.config.apiVersions = {
  dynamodb: '2012-08-10'
}
AWS.config.logger = console;

const getBalance = () => {
  return executeApiCall('Balance', 'api/v1/accounts/balance');
};

const getScheduledPayments = async () => {
  const response = await executeApiCall('Scheduled payments', 'api/v1/payments/scheduled');
  return response._embedded.paymentOrders;
};

const hitPath = (path) => {
  return executeApiCall(`From path=${path}`, path);
};

const executeApiCall = async (text, path) => {
  console.log(`Starling: Getting ${text}`);
  const response = await fetch(`https://api.starlingbank.com/${path}`, {
    method: 'GET',
    headers: {
      'Authorization': `Bearer ${secrets.STARLING_PERSONAL_ACCESS_TOKEN}`
    }
  });
  const data = await response.json();
  console.log(`Starling: ${text} response:`, JSON.stringify(data));
  return data;
};

module.exports = {
  getBalance,
  getScheduledPayments,
  hitPath
};