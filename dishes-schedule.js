const telegram = require('./telegram');

module.exports.run = async (event, context) => {
  try {
    console.log('Event:\n', event);
    console.log('Context:\n', context);
    await telegram.sendMessage(`Put some dishes away!`);
  } catch (e) {
    console.error('ERROR:', e);
    throw e;
  }
};