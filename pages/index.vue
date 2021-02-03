<template>
  <body>
    <div class="top">
      <div>
        <nav id="menu">
          <div class="main-nav-list active-element">
            <ul>
              <li><a href="./issuer_pages" class="active-link">Issuer</a></li>
            </ul>
          </div>
        </nav>
          <h1 class="title">
            Image Guardian
          </h1>
          <carousel class="contents" :per-page="1" :autoplay="true" :loop="true" :pagination-padding="5" :autoplay-timeout="4000">
            <slide v-for="(ipfsHash, index) in this.ipfsHashs" :key="index" >
              <p>{{ipfsHashs[0].nameOfCertificate}}</p>
              <img class="image" :src="'https://ipfs.io/ipfs/' + ipfsHashs[0].ipfsHash" >
            </slide>
          </carousel>
          <div class="links" v-if="!isSignedIn"> 
            <button @click="signIn()">Sign In</button>
          </div> 
      </div>
    </div>
  </body>
</template>

<script>
import Web3 from "web3";
import firebase from 'firebase';
import sha256 from "js-sha256";
import toContract from "~/plugins/toContract.js";
import Carousel from '~/node_modules/vue-carousel/src/Carousel.vue';
import Slide from '~/node_modules/vue-carousel/src/Slide.vue';
import Certificate1155Contract from "~/build/contracts/ERC1155Certificate.json";
import getWeb3 from "~/plugins/getWeb3.js";
import ipfs from "~/plugins/ipfs.js";
import web3 from "~/plugins/web3.js";

export default {
  data() { 
  return {
  write: 0, // コントラクトから取得する数値 
  ipfsHashs: [],
    // certificateId: 0,
    // _nameOfCertificate: '', //発行先の名前
    // _ipfsHash: '', //ipfsのHash値 
    // msgSender: '', //発行先アドレス
    // now: 0, //発行日
  buffer: '',
  isSignedIn: false,
  privatekey: '', // authentication用秘密鍵
  address: '', // authentication用アドレス
  // id: 0,
  }
},

methods: {

  loadIpfsHash: async function() {
    // let certificateID = this.certificateId
    // let nameOfCertificate = this._nameOfCertificate
    // let ipfsHash = this._ipfsHash
    // let issuer = this.msgSender
    // let date = this.now
    const accounts = await this.$web3.eth.getAccounts()
    const Id = await this.$contract.methods.getMyCertificateId(accounts[0]).call()
    for (var i = 0; i < Id; i++) {
      const certificate = await this.$contract.methods.certificates(i).call()
      // certificatesは配列ゆえにコントラクトメソッドとして呼び出す事はできない為、引数は i だけで良いという事なのだろうか...
      this.ipfsHashs.push(certificate);
    }
},
  signIn: function() {
    const provider = new firebase.auth.GoogleAuthProvider();
    firebase.auth().signInWithRedirect(provider); 
} 
},
components: {
    Carousel,
    Slide
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
    // console.log("Current Block Number"); 
    this.$web3.eth.getBlockNumber().then(console.log);  
  }
},
async created() { 
    setTimeout(async () => {
      await this.loadIpfsHash();
    }, 1)
},
}
</script>

<style>
.top {
  margin: 0 auto;
  max-height: 150vh;
  height: 98vh;
  display: flex;
  justify-content: center;
  align-items: center;
  text-align: center;
}
.title {
  font-family:
    sans-serif;
  /* height: 800px; */
  margin-bottom: 70px;
  padding-top: 10px;
  display: block;
  font-weight: 300;
  font-size: 100px;
  color: #35495e;
  /* letter-spacing: 1px; */
}
.contents {
  /* display: block; */
  /* overflow: hidden; */
  position: relative;
  justify-content: center;
  /* text-align: center; */
  /* padding-top: calc(9 / 16 * 100%); */
  /* width: 980px; */
  /* height: 500px; */
  box-shadow: 0px 0px 10px 0px rgba(3, 3, 3, 0.75);
}
.image {
  position: relative;
  height: 450px; 
  width: 450px;
  align-items: center;
  object-fit: cover;
  transition: opacity 1s;
}
#menu {
  margin: 0;
  width: auto;
  background-color: #565656;
  font-size: 16px;
  font-family: Tahoma, Geneva, sans-serif;
  font-weight: bold;
  text-align: left;
  padding: 8px;
  border-radius: 8px;
  -webkit-border-radius: 8px;
  -moz-border-radius: 8px;
  -o-border-radius: 8px;
}
#menu li {
  display: inline;
  padding: 80px;
}
#menu a {
  color: #FFF;
  padding: 10px;
  text-decoration: none;
}
#menu a:hover {
  background-color: #1B191B;
  color: #FFF;
  border-radius: 20px;
  -webkit-border-radius: 20px;
  -moz-border-radius: 20px;
  -o-border-radius: 20px;
}
#menu li .active {
  background-color: #1B191B;
  color: #FFF;
  border-radius: 20px;
  -webkit-border-radius: 20px;
  -moz-border-radius: 20px;
  -o-border-radius: 20px;
}
</style>