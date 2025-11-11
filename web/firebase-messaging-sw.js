importScripts("https://www.gstatic.com/firebasejs/9.10.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/9.10.0/firebase-messaging-compat.js");

firebase.initializeApp({
  apiKey: 'AIzaSyD8w-aOnHXDgPQ1u5DkgAh26BRUxBu5RmM',
  appId: '1:551056648202:web:e385fce0105249225117f3',
  messagingSenderId: '551056648202',
  projectId: 'dictionarydox',
  authDomain: 'dictionarydox.firebaseapp.com',
  storageBucket: 'dictionarydox.appspot.com',
  measurementId: 'G-NTCTYCF50F',
});

const messaging = firebase.messaging();

// Optional: Handle background messages
messaging.onBackgroundMessage((message) => {
  console.log("onBackgroundMessage", message);
});
