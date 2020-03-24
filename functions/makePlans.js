// makePlans.js

// require needed modules
const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.handler = ((snap, context) => {
    // rename console.log to log
    const { log } = console; 

    // set the version number and log it
    const version = 1.3;
    log(version);

    // configure the admin sdk and set up a database reference
    const db = admin.firestore();

    // grab the snapshot data
    const start = snap.data().startTime;
    const end = snap.data().endTime;
    const user = context.params.userID;
    
    if(start && end) {
        log(`start: ${start}, end: ${end}`);
        // const friendsPath = db.collection('users').document(user).collection('friends');

        // wait to compile the list of friends
        const friendsList = await db.collection('users').document(user).collection('friends').listDocuments();

        /* This brings up the age old question where should plan requests be stored.
        Does it need to be under the user? Do they need to access their own requests?
        Friends definitely need access to locate active plans. Clearly more work on the
        algorithm is needed to understand the problem. How is the client tracking the 
        plan creation process?
        */

        log('friendIds:')
        const requests = friendsList.map(friendRef => {
            const friendID = friendRef.data().objectID;
            log(friendID);
            return friendID;
        });


    } else {
        log(`ERROR: Missing either start of end time`);
    }
})