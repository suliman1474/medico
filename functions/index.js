const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp(functions.config().firebase);

exports.postTrigger = functions.firestore
    .document("posts/{postId}")
    .onCreate((_, context) => {
      const postId = context.params.postId;

      return admin
          .firestore()
          .collection("users")
          .where("fcmToken", "!=", null)
          .get()
          .then((snapshots) => {
            const tokens = [];
            if (snapshots.empty) {
              console.log("No Devices Found");
            } else {
              snapshots.docs.forEach((userDoc) => {
                const userToken = userDoc.data().fcmToken;
                tokens.push(userToken);
              });

              const payload = {
                notification: {
                  title: "New Post!",
                  body: "A new post is available. Check it out now!",
                },
                data: {
                  type: "post",
                  postId: postId,
                },
              };

              return admin
                  .messaging()
                  .sendToDevice(tokens, payload, {
                    priority: "high",
                    contentAvailable: true,
                  })
                  .then(() => {
                    console.log("Push notifications sent for new post.");
                  })
                  .catch((err) => {
                    console.error("Error sending push notifications:", err);
                  });
            }
          });
    });

exports.pollTrigger = functions.firestore
    .document("polls/{pollId}")
    .onCreate((_, context) => {
      const pollId = context.params.pollId;

      return admin
          .firestore()
          .collection("users")
          .where("fcmToken", "!=", null)
          .get()
          .then((snapshots) => {
            const tokens = [];
            if (snapshots.empty) {
              console.log("No Devices Found");
            } else {
              snapshots.docs.forEach((userDoc) => {
                const userToken = userDoc.data().fcmToken;
                tokens.push(userToken);
              });

              const payload = {
                notification: {
                  title: "New Poll!",
                  body: "A new poll is available. Vote now!",
                },
                data: {
                  type: "poll",
                  pollId: pollId,
                },
              };

              return admin
                  .messaging()
                  .sendToDevice(tokens, payload, {
                    priority: "high",
                    contentAvailable: true,
                  })
                  .then(() => {
                    console.log("Push notifications sent for new poll.");
                  })
                  .catch((err) => {
                    console.error("Error sending push notifications:", err);
                  });
            }
          });
    });

// const functions = require("firebase-functions");
// const admin = require("firebase-admin");

// admin.initializeApp(functions.config().firebase);

// exports.postTrigger =
// functions.firestore.document("posts/{postId}").onCreate(() => {
//   return admin.firestore().collection("tokens").get().then((snapshots) => {
//     const tokens = [];
//     if (snapshots.empty) {
//       console.log("No Devices Found");
//     } else {
//       snapshots.docs.forEach((pushTokens) => {
//         tokens.push(pushTokens.data().token);
//       });

//       const payload = {
//         notification: {
//           title: "New Poll!",
//           body: "Medico Slides has just created a Poll vote now.",
//         },
//         data: {
//           typeof: "post",
//         },
//       };

//       return admin.messaging().sendToDevice(
//           tokens,
//           payload,
//           {priority: "high", contentAvailable: true}).then(() => {
//         console.log("pushed them all");
//         // return null;
//       }).catch((err) => {
//         console.log(err);
//         // return null;
//       });
//     }
//   });
// });

// exports.pollTrigger =
// functions.firestore.document("polls/{pollId}").onCreate(() => {
//   return admin.firestore().collection("tokens").get().then((snapshots) => {
//     const tokens = [];
//     if (snapshots.empty) {
//       console.log("No Devices Found");
//     } else {
//       snapshots.docs.forEach((pushTokens) => {
//         tokens.push(pushTokens.data().token);
//       });

//       const payload = {
//         notification: {
//           title: "New Poll!",
//           body: "Medico Slides has just created a Poll vote now.",
//         },
//         data: {
//           typeof: "poll",
//         },
//       };

//       return admin.messaging().sendToDevice(
//           tokens,
//           payload,
//           {priority: "high", contentAvailable: true}).then(() => {
//         console.log("pushed them all");
//         // return null;
//       }).catch((err) => {
//         console.log(err);
//         // return null;
//       });
//     }
//   });
// });
