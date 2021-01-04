<template>
  <client-only>
    <div class="container">
      <div>
        <h1 class="title">
          Image Guardian
        </h1>
        <div class="links">
              <div key="key">
                <img src= "https://ipfs.io/ipfs/${ipfsHash}" alt="">
              </div>
            <img src= "https://ipfs.io/ipfs/${this.state.hoge}" alt="">
        <!-- <el-form-item label="Photo" required>
          <input type="file" accept=".jpg, .jpeg, .png" @change="captureFile" />
          <el-button @submit="onSubmit()"></el-button>
        </el-form-item> -->
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
      console.log(this.$contract)
      console.log("1");
      let accounts = await this.$web3.eth.getAccounts() // MetaMaskで使っているアカウントの取得 
      console.log(accounts)
      // console.log(result)
      console.log(IpfsHash)
      console.log("1.5")
      //ブロックチェーンにipfsHashを書きこむ
      let ret = await this.$contract.methods.set(result[0].IpfsHash).send({ from: accounts[0] })
      // let ret2 = await this.$contract.methods.IpfsHash().send({ from: accounts[0] })
      console.log("2");
      this.write = ret // フロントへ反映
      // this.number2 = ret2
      //ipfsHashの値をアップデートする
      return this.loadIpfsHash();
      console.log("3");
    })
  },

    loadIpfsHash: async function() {
    const length = await this.$contract.methods.arraylength().call()
    console.log(length)
    for (var i = 0; i <= length; i++) {
      const ipfsHashs = await this.$contract.methods.IpfsHash(i).call()
      console.log(ipfsHashs)
      Vue.set(ipfsHash, '...this.state.ipfsHash', 'ipfsHashs')
        }
      }
    },

  mounted() { 

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
