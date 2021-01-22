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
              <slide v-for="(ipfsHash, index) in this.ipfsHashs" :key="index">
                <p>{{ipfsHash.ipfsHash}}</p>
                <img class="image" :src="'https://ipfs.io/ipfs/' + ipfsHash.ipfsHash" >
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
  buffer: '',
  isSignedIn: false,
  privatekey: '', //秘密鍵
  address: '', // アドレス
    nft: {
    toName: '', // 送り先の名前
    issueNumber: 0, // 発行数
    toAddresses: [], // 送り先アドレス
  },
  }
},

methods: {

  async captureFile(event) {
    event.preventDefault()      // preventDefault()はもしイベントがキャンセル可能だったら自動でキャンセルする
    const file = await event.target.files[0]; // event.target.files でサイズ、形式などのファイル情報を取得する      
    const reader = await new window.FileReader(); // FileReader はデータ読み込みを目的としたオブジェクト
    reader.readAsArrayBuffer(file);  // readAsArrayBuffer() でfileオブジェクトを読み込む
    reader.onloadend = () => { // onloadend はデータ読み込み時に発生するイベントハンドラ
      this.buffer = Buffer(reader.result);
      resolve(event.target.result);
  }
},
  async onSubmit() {
    event.preventDefault()
    ipfs.files.add(this.buffer, async (error, result) => {
      if(error) {
        console.error(error)
        return
      }
    let accounts = await this.$web3.eth.getAccounts() // MetaMaskで使っているアカウントの取得 
      // 証明証をnft化する
    // let newAddresses = []
    // let arrayAddresses = newAddresses.push(this.bufAddress)
    let upNft = await this.$contract.methods.issueCertificate(this.nft.toName, this.nft.issueNumber, this.nft.toAddresses, result[0].hash).send({ from: accounts[0] })
      // issueCertificate関数の引数は証明証名、発行数、発行先アドレス、result[0].hash
      // ipfsHashの値をアップデートする
    // return this.loadIpfsHash();
  })
},
  loadIpfsHash: async function() {
    let accounts = await this.$web3.eth.getAccounts()
    console.log(accounts[0]);
    const id = await this.$contract.methods.getMyCertificateId(accounts[0]).call()
    for (var i = 0; i < id; i++) {
      const certificates = await this.$contract.methods.certificates(i).call()
      this.ipfsHashs.push(certificates)
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
    console.log("Current Block Number"); 
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
    console.log("Current Block Number"); 
    this.$web3.eth.getBlockNumber().then(console.log);  
  }
},
  async created() { 
    setTimeout(async () => {
      await this.loadIpfsHash();
    }, 1)
}
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