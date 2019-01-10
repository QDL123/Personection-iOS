//Create reference to firebase functions module
const functions = require('firebase-functions');
var algoliasearch = require('algoliasearch');

//Set up algolia credentials and client
// App ID and API Key are stored in functions config variables
//But here we just hard code it.

const ALGOLIA_ID = "DMRC05KK1I";
const ALGOLIA_ADMIN_KEY = "daa87f2c4c4fa2403c1e5e1d8a8b7f1e";
const ALGOLIA_SEARCH_KEY = "54efdbade3ca6966c12b855166f6bbde";

const ALGOLIA_INDEX_NAME = 'users_search';
var client = algoliasearch(ALGOLIA_ID, ALGOLIA_ADMIN_KEY);


exports.handler = ((snap, context) => {
  //Get the user document
  // Write to the algolia index
  const index = client.initIndex(ALGOLIA_INDEX_NAME);
  return index.deleteObject(context.params.userID);
})
