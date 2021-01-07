<template>
    <div class="top">
      <div>
          <h1 class="title">
            Image Guardian
          </h1>
          <carousel>
            <div class="contents">
              <div v-for="(ipfsHash, index) in this.ipfsHashs" :key="index" @mouseover="stopRotation" @mouseout="startRotation">
                <img class="image" :src="'https://ipfs.io/ipfs/' + ipfsHash" >
              </div>
            </div>
          </carousel>
          <form @submit="onSubmit">
            <input type="file" @change="captureFile" />
            <input type="submit" id="click" />
          </form>
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
  data: { 
  write: 0, // コントラクトから取得する数値 
  ipfsHashs: [],
  state: {
    web3: null, 
    accounts: null, 
    contract: null,
    buffer: '',
    // instance: '',
  },
}, 

methods: {

  startRotation: function () {
    this.timer = setInterval(this.next, this.speed);
  },
  stopRotation: function () {
    clearTimeout(this.timer);
    this.timer = null;
  },

  next: function () {
    var current = this.current;
    var next = current + 1;

    if (next > this.slides.length - 1) {
      next = 0;
    }
    this.current = next;
    this.setActive(this.current);
},
  prev: function () {
    var current = this.current;
    var prev = current - 1;

    if (prev < 0) {
      prev = this.slides.length -1;
    }

    this.current = prev;
    this.setActive(this.current);
},

    isActive: function (slide) {
      return this.current === slide;
    },
    setActive: function (slide) {
      this.current = slide;
    },

  async captureFile(event) {
    event.preventDefault()      // preventDefault()はもしイベントがキャンセル可能だったら自動でキャンセルする
    const file = await event.target.files[0]; // event.target.files でサイズ、形式などのファイル情報を取得する      
    const reader = await new window.FileReader(); // FileReader はデータ読み込みを目的としたオブジェクト
    // Vue.set(this.state.buffer, 'Buffer(reader.result)')
    reader.readAsArrayBuffer(file);  // readAsArrayBuffer() でfileオブジェクトを読み込む

    reader.onloadend = () => { // onloadend はデータ読み込み時に発生するイベントハンドラ
      this.state.buffer = Buffer(reader.result);
      resolve(event.target.result);
  }
},

  async onSubmit() {
    event.preventDefault()

    ipfs.files.add(this.state.buffer, async (error, result) => {
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
  mounted: function () {
    this.startRotation();
  }
}
</script>

<style lang="scss" scoped>

// @import '~/assets/scss/base.scss';

.VueCarousel-slide {

}

.top {
  margin: 0 auto;
  height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
  text-align: center;
}

.title {
  font-family:
    /* 'Quicksand',
    'Source Sans Pro',
    -apple-system,
    BlinkMacSystemFont,
    'Segoe UI',
    Roboto,
    'Helvetica Neue',
    Arial, */
    sans-serif;
  height: 250px;
  display: block;
  font-weight: 300;
  font-size: 100px;
  color: #35495e;
  /* letter-spacing: 1px; */
}

  .contents {
    padding-top: 15px;
}

  .image {
    /* display: block; */
    height: 100px;
    width: 100px;
    /* margin: auto; */
    object-fit: cover;
}


</style>
