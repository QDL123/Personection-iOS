//makePlans.js
//import * as functions from 'firebase-functions';
//import * as admin from 'firebase-admin';
const functions = require('firebase-functions');
var admin = require('firebase-admin');

exports.handler = ((snap, context) => {
    //Show functions has been called
    console.log("Make Plans!");

    //admin.initializeApp();

    //Code from warning message
    const settings = {timestampsInSnapshots: true};
    /*
    const firestore = new Firestore();
    firestore.settings(settings);
    
    */
    //Code from tutorial for setting up admin
    
    admin.initializeApp(functions.config().firebase);
    const db = admin.firestore();
    db.settings(settings);
    

    //Get necessary data from context and snapshot
    const userID = context.params.userID;
    const startTime = snap.data().startTime;
    const endTime = snap.data().endTime;

    //Loop thorugh all the friends requests and check for overlaps.
    //Select for greatest overlap
    var greatestOverlap = 0;
    //There may be an argument to move requests to its own outermost collection here
    var idealFriendID = "";
    var idealRequestID = "";
    //Get the Users friends
    console.log("Updated");
    const friendsRef = snap.ref.parent.parent.collection('friends');
    return friendsRef.get().then(friendsSnap => {
        return friendsSnap.forEach(friendDoc => {
            //For each friend doc get all their requests.
            //First get their user id
            const friendID = friendDoc.id;
            console.log(friendID);
            
            return db.collection('users').document(friendID).collection('requests')
            .get().then(requestsSnap => {
                //Get each individual document
                return requestsSnap.forEach(requestDoc => {
                    //Now we have each request
                    const request = requestDoc.data();
                    console.log("Start time: " + request.startTime);
                    return 0;
                });
            });
        });
    });
})