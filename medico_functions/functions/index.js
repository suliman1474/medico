const functions = require("firebase-functions");
const admin = require("firebase-admin");
const serviceAccount = require("./admin_key/medico-3e595-firebase-adminsdk-74iat-7360f37a42.json");
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://medico-3e595.firebaseio.com",
});


exports.postTrigger = functions.firestore
    .document("posts/{postId}")
    .onCreate((snapshot, context) => {
      const postId = context.params.postId;
      const post = snapshot.data();

      const description = post.description || "A new post is available. Check it out now!";

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
                  body: description,
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
    .onCreate((snapshot, context) => {
      const pollId = context.params.pollId;
      const poll = snapshot.data();

      const description = poll.description || "A new poll is available. Vote now!";

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
                  body: description,
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
