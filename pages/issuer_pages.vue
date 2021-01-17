<template>
  <div class="top">
    <div>
        <nav id="menu">
          <div class="main-nav-list active-element">
            <ul>
              <li><a href="/" class="active-link">User</a></li>
            </ul>
          </div>
        </nav>
      <h1 class="title">
        Image Guardian
      </h1>
      <h2 class="title2">
        Issuer
      </h2>
      <div class="submit">
        <form @submit="onSubmit">
          <input type="file" @change="captureFile" />
          <input class="btn" type="submit" id="click" />
        </form>
      </div>
    </div>
  </div>
</template>

<script>
import Web3 from "web3";
import SimpleStorageContract from "~/build/contracts/SimpleStorage.json";
import Certificate1155Contract from "~/build/contracts/ERC1155Certificate.json";
import getWeb3 from "~/plugins/getWeb3.js";
import ipfs from "~/plugins/ipfs.js";
import web3 from "~/plugins/web3.js";

export default {
  data() { 
  return { 
  write: 0, // コントラクトから取得する数値 
  ipfsHash: [],
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
      //  ブロックチェーンにipfsHashを書きこむ
    let ret = await this.$contract.methods.set(result[0].hash)
    let nft = await this.$contract.methods.issueCertificate("0x").send({ from: accounts[0] }) // 証明証をnft化する
      //  issueCertificate関数の引数は発行者名、発行数、発行先アドレス、result[0].hashの4つだとすれば初めの3つはauthenticationのデータから取ってくる？
    this.write = nft // フロントへ反映
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

}
</script>

<style>
.top {
  margin: 0 auto;
  min-height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
  text-align: center;
}
#menu {
  position: relative;
  /* top: 0px; */
  bottom: 155px;
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
.title {
  position: relative;
  font-family:
    sans-serif;
  top: 143px;
  display: block;
  font-weight: 300;
  font-size: 100px;
  color: #35495e;
  /* letter-spacing: 1px; */
}
.title2 {
  position: relative;
    font-family:
    sans-serif;
    top: 100px;
    margin-bottom: 100px;
  display: block;
  font-weight: 300;
  font-size: 100px;
  color: #35495e;
}
.submit {
  justify-content: center;
}
.btn {
  flex: 1 1 auto;
  margin: 10px;
  padding: 30px;
  text-align: center;
  text-transform: uppercase;
  transition: 0.5s;
  color: rgb(3, 0, 0);
  border-radius: 10px;
}
.btn:hover {
  background-color: aquamarine;
}

</style>