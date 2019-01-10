//Create reference to firebase functions module
const functions = require('firebase-functions');

//Set up algolia credentials and school_involvement



//Required Packages (Files in the directories containing needed code)
const newUserModule = require('./newUser');
const deleteUserModule = require('./deleteUser');

//Functions Declarations
exports.newUser = functions.firestore.document('users/{userID}')
.onCreate(newUserModule.handler);

exports.deleteUser = functions.firestore.document('users/{userID}')
.onDelete(deleteUserModule.handler);
// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });
