<template>
  <body>
    <div class="top">
      <div>
        <nav id="menu">
          <ul>
            <li><a href="./issuer_pages" class="active-link">IssuerPage</a></li>
          </ul>
        </nav>
        <h1 class="title">
          Image Guardian User
        </h1>
        <carousel class="contents" :per-page="1" :autoplay="true" :loop="true" :pagination-padding="5" :autoplay-timeout="4000">
          <slide v-for="(ipfsData, index) in this.ipfsHashs" :key="index" >
            <p>
              <!-- 発行日:{{ipfsData.issuedate}} -  -->
              証明証名:{{ipfsData.nameOfCertificate}}</p>
            <img class="image" :src="'https://ipfs.io/ipfs/' + ipfsData.ipfsHash" >
          </slide>
        </carousel>
      </div>
    </div>
  </body>
</template>

<script>
import Web3 from "web3";
import firebase from 'firebase';
import sha256 from "js-sha256";
import toContract from "~/plugins/toContract.js";
import Vue from 'vue';
import VueCarousel from 'vue-carousel';
import Certificate1155Contract from "~/build/contracts/ERC1155Certificate.json";
import getWeb3 from "~/plugins/getWeb3.js";
import ipfs from "~/plugins/ipfs.js";
import web3 from "~/plugins/web3.js";

Vue.use(VueCarousel);

export default {
  data() { 
    return {
      ipfsHashs: [],
      buffer: '',
    }
  },

methods: {
  loadIpfsHash: async function() { // 送信された証明証データを取得するための関数
    const accounts = await this.$web3.eth.getAccounts() // アカウント取得メソッドをaccountsに格納
    const Id = await this.$contract.methods.getMyCertificateId(accounts[0]).call() // ここでアカウントデータを取得
    for (var i = 0; i < Id.length; i++) {
      const certificate = await this.$contract.methods.certificates(i).call() // 送られてきた証明証の名前や日付などのデータcertificateに格納
      this.ipfsHashs.push(certificate); // データをpush
    }
},
},
  async created() { // ページローディングと同時にloadIpfsHash発火させることで、証明証取得可能になる
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
  font-family:sans-serif;
  margin-bottom: 70px;
  padding-top: 10px;
  display: block;
  font-weight: 300;
  font-size: 100px;
  color: #35495e;
}
.contents {
  position: relative;
  justify-content: center;
  padding-left: 50px;
  padding-right: 50px;
  padding-top: 10px;
  padding-bottom: 10px;
  width: 980px;
  box-shadow: 0px 0px 10px 0px rgba(3, 3, 3, 0.75);
}
.image {
  position: relative;
  height: 450px; 
  width: 400px;
  align-items: center;
  object-fit: cover;
  transition: opacity 1s;
}
#menu {
  position: absolute;
  width: 800px;
  background-color: #565656;
  font-size: 16px;
  font-family: Tahoma, Geneva, sans-serif;
  font-weight: bold;
  align-items: center;
  justify-content: center;
  text-align: center;
  top: 30px;
  left: 440px;
  padding: 8px;
  border-radius: 8px;
  -webkit-border-radius: 8px;
  -moz-border-radius: 8px;
  -o-border-radius: 8px;
}
#menu li {
  display: inline-block;
  padding: 1px;
  margin-right: 500px;
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
.links {
  cursor:pointer;
  color: rgb(3, 0, 0);
}
.button {
  font-family:sans-serif;
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
.update {
  position: absolute;
  top: 100px;
  left: 1500px;
  cursor: pointer;
}
</style>