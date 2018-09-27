const starling = require('./starling');
const telegram = require('./telegram');

module.exports.run = async (event, context) => {
  try {
    console.log('Event:\n', event);
    console.log('Context:\n', context);
    const payments = await starling.getScheduledPayments();
    console.log('Recurring Payments:', JSON.stringify(payments));

    const tomorrow = new Date();
    tomorrow.setDate(tomorrow.getDate()+1);
    console.log('Tomorrow:', tomorrow);
    const paymentsDue = [];

    for (const payment of payments) {
      const paymentDate = new Date(payment.nextDate);

      if (paymentDate.getFullYear() === tomorrow.getFullYear() && paymentDate.getMonth() === tomorrow.getMonth() && paymentDate.getDate() === tomorrow.getDate()) {
        const contactInfo = await starling.hitPath(payment._links.receivingContactAccount.href);
        console.log('ContactInfo:', contactInfo);
        paymentsDue.push({
          reference: payment.reference,
          amount: payment.amount,
          nextDate: payment.nextDate,
          name: contactInfo.name
        })
      }

    }

    console.log('paymentsDue:', paymentsDue);

    if (paymentsDue.length > 0) {
      const balance = await starling.getBalance();
      for (const payment of paymentsDue) {
        await telegram.sendMessageArray([
          `*Upcoming Payment*`,
          `When: ${payment.nextDate} (tomorrow)`,
          `Amount: £${payment.amount}`,
          `Balance: £${balance.effectiveBalance}`,
          `To: ${payment.name}`,
          `Reference: ${payment.reference}`
        ])
      }
    } else {
      console.log('No payments due');
    }

  } catch (e) {
    console.error('ERROR:', e);
    throw e;
  }
};