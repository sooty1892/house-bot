const telegram = require('./telegram');

module.exports.run = async (event, context) => {
  try {
    console.log('Event:\n', event);
    console.log('Context:\n', context);
    await telegram.sendMessage(`Pay council tax for this month`);
  } catch (e) {
    console.error('ERROR:', e);
    throw e;
  }
};