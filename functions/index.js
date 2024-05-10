const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

/**
 * Predefined list of lifestyle tips.
 */
const lifestyleTips = [
  "Drink plenty of water to stay hydrated throughout the day.",
  "Take short breaks and stretch if you sit for long periods.",
  "Include fruits and vegetables in your diet for a balanced nutrition.",
  "Exercise regularly to maintain a healthy body and mind.",
  "Get enough sleep each night to feel rested and rejuvenated.",
];

/**
 * Cloud Function to send a daily notification with a lifestyle tip.
 *
 * @param {functions.EventContext} context The event context.
 * @return {Promise<void>} A promise resolving when the notification is sent.
 */
exports.sendDailyNotification = functions.pubsub.schedule("0 9 * * *")
    .timeZone("Asia/Riyadh")
    .onRun((context) => {
      const dayOfYear = getDayOfYear();
      const tipIndex = dayOfYear % lifestyleTips.length;

      const notificationOptions = {
        notification: {
          title: "Daily Lifestyle Tip",
          body: lifestyleTips[tipIndex],
        },
        data: {
          click_action: "FLUTTER_NOTIFICATION_CLICK",
          tipIndex: `${tipIndex}`, // Example of sending data
        },
      };

      return admin.messaging().sendToTopic("lifestyleTips", notificationOptions)
          .then((response) => {
            console.log("Successfully sent message:", response);
            return null;
          })
          .catch((error) => {
            console.log("Error sending message:", error);
          });
    });

/**
 * Calculates the day of the year.
 *
 * @return {number} The day of the year.
 */
function getDayOfYear() {
  const now = new Date();
  const start = new Date(now.getFullYear(), 0, 0);
  const diff = now - start;
  const oneDay = 1000 * 60 * 60 * 24;
  return Math.floor(diff / oneDay);
}
