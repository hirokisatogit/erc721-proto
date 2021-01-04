<template>
  <client-only>
    <div class="container">
      <div>
        <h1 class="title">
          Image Guardian
        </h1>
        <div class="links">
              <div v-for="(ipfsHash, index) in this.ipfsHashs" :key="index">
                <img :src="'https://ipfs.io/ipfs/' + ipfsHash" >
              </div>
          <form @submit="onSubmit">
            <input type="file" @change="captureFile" />
            <input type="submit" id="click" />
          </form>
        </div>
      </div>
    </div>
  </client-only>
</template>


<script>
import Web3 from "web3";
import SimpleStorageContract from "~/build/contracts/SimpleStorage.json";
import getWeb3 from "~/plugins/getWeb3.js";
import ipfs from "~/plugins/ipfs.js";
import web3 from "~/plugins/web3.js";
// import VuePreviewer from '~/plugins/vue-image-previewer.js';

export default {
  data() { 

  return { 
  write: 0, // コントラクトから取得する数値 
  ipfsHashs: [],
  state: {
    web3: null, 
    accounts: null, 
    contract: null,
    buffer: '',
    hoge: '',
    instance: '',
    },
  } 
}, 

methods: {

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
      //ipfsHashの値をアップデートする
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

  async created() { 
    setTimeout(async () => {
      await this.loadIpfsHash();
    }, 1)
  },
}
</script>

<style>
.container {
  margin: 0 auto;
  min-height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
  text-align: center;
}

.title {
  font-family:
    'Quicksand',
    'Source Sans Pro',
    -apple-system,
    BlinkMacSystemFont,
    'Segoe UI',
    Roboto,
    'Helvetica Neue',
    Arial,
    sans-serif;
  display: block;
  font-weight: 300;
  font-size: 100px;
  color: #35495e;
  letter-spacing: 1px;
}

/* .subtitle {
  font-weight: 300;
  font-size: 42px;
  color: #526488;
  word-spacing: 5px;
  padding-bottom: 15px;
} */

.links {
  padding-top: 15px;
}
</style>
