<template>
    <div class="top">
      <div>
          <h1 class="title">
            Image Guardian
          </h1>
            <carousel class="contents" :per-page="1" :autoplay="true" :loop="true" :pagination-padding="5" :autoplay-timeout="4000">
              <slide v-for="(ipfsHash, index) in this.ipfsHashs" :key="index">
                <img class="image" :src="'https://ipfs.io/ipfs/' + ipfsHash" >
              </slide>
            </carousel>
      </div>
    </div>
</template>

<script>
import Web3 from "web3";
import Carousel from '~/node_modules/vue-carousel/src/Carousel.vue' // 指定の仕方間違ってるかも
import Slide from '~/node_modules/vue-carousel/src/Slide.vue'
import SimpleStorageContract from "~/build/contracts/SimpleStorage.json";
import Certificate1155Contract from "~/build/contracts/ERC1155Certificate.json";
import getWeb3 from "~/plugins/getWeb3.js";
import ipfs from "~/plugins/ipfs.js";
import web3 from "~/plugins/web3.js";
// import VuePreviewer from '~/plugins/vue-image-previewer.js';
export default {
  data() { 
  return { 
  write: 0, // コントラクトから取得する数値 
  ipfsHashs: [],
  buffer: '',
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
      //ブロックチェーンにipfsHashを書きこむ
    let ret = await this.$contract.methods.set(result[0].hash).send({ from: accounts[0] })
    this.write = ret // フロントへ反映
      // ipfsHashの値をアップデートする
      // return this.loadIpfsHash();
  })
},
  loadIpfsHash: async function() {
    const length = await this.$contract.methods.arraylength().call()
    for (var i = 0; i < length; i++) {
      const ipfsHash = await this.$contract.methods.IpfsHash(i).call()
      // console.log(ipfsHash);
      this.ipfsHashs.push(ipfsHash)
    }
  }
},
  components: {
    Carousel,
    Slide
  },
  // layout: 'client/simple',
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
  height: 150px;
  display: block;
  font-weight: 300;
  font-size: 100px;
  color: #35495e;
  /* letter-spacing: 1px; */
}
.contents {
  display: block;
  /* overflow: hidden; */
  position: relative;
  justify-content: center;
  text-align: center;
  /* padding-top: calc(9 / 16 * 100%); */
  /* width: 980px; */
  /* height: 500px; */
  box-shadow: 0px 0px 10px 0px rgba(3, 3, 3, 0.75);
}
.image {
  position: relative;
  /* top: 50%; */
  /* left: 50%; */
  height: 200px; 
  width: 200px;
  margin: auto;
  /* position: center; */
  /* width: auto;  */
  /* height: auto; */
  align-items: center;
  object-fit: cover;
  /* opacity: 0; */
  transition: opacity 1s;
}
</style>