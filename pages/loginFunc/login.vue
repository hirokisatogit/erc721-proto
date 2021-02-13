<template>
  <body>
    <div class="links" v-if="!isSignedIn"> 
      <button class="button" @click="signIn()">Sign In</button>
    </div>
  </body>
</template>

<script>
import firebase from 'firebase';

export default {
  data() {
    return {
      isSignedIn: false,
      privatekey: '', // authentication用秘密鍵
      address: '', // authentication用アドレス
    }
  },
methods: {
  signIn: function() {
    const provider = new firebase.auth.GoogleAuthProvider();
    firebase.auth().signInWithRedirect(provider); 
  } 
},

mounted() {
    if (!firebase.apps.length) {
      var firebaseConfig = {
      apiKey: process.env.APIKEY, 
      authDomain: process.env.AUTHDOMAIN, 
    }; 
    // Initialize Firebase 
    firebase.initializeApp(firebaseConfig); 
    // console.log("Current Block Number"); 
    this.$web3.eth.getBlockNumber().then(console.log);  
  };
  if (!firebase.apps.length) { 
    var self = this; 
    firebase.auth().getRedirectResult().then(function(result) { 
    if (result.credential) { 
      let user = result.user; 
      self.isSignedIn = true; 
      console.log(user.uid);
      self.privateKey = "0x" + sha256.hex(user.uid); 
      self.address = self.$web3.eth.accounts.privateKeyToAccount(self.privateKey).address;
      self.$web3.eth.defaultAccount = self.address;
      console.log("Address:" + self.address);
    } 
  }).catch(function(error) { 
    let errorMessage = error.message; 
    console.log(errorMessage); 
  }); 
  }
},
}
</script>

<style>
.links {
  position: absolute;
  cursor: pointer;
  color: rgb(3, 0, 0);
  top: 70px;
  left: 790px;
}
.button {
  font-family: sans-serif;
  width: 100px;
  text-align: center;
  text-transform: uppercase;
  transition: 0.5s;
  cursor: pointer;
  border-radius: 10px;
}
.button:hover {
  background-color: aquamarine;
}
</style>