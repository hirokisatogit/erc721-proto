# Image_Guardian_User

## Build Setup

```
# Add web3.js, the library needed to run Ethereum apps.
$ yarn add web3

# Install Truffle, an important tool for compiling smart contracts and deploying them to the blockchain.
$ yarn add truffle --dev

# After installing truffle, create directories such as build, contracts, migrations, and truffle-config.js.
$ yarn truffle init

# This is a node module to pay for Gas when deploying a contract.
$ yarn add @truffle/hdwallet-provider



# The carousel used in the vue file can be installed.
$ yarn add vue-carousel

# For this contract, I used ERC1155 from openzeppelin, so I installed the library at
$ yarn add @openzeppelin/contracts

# The written contract can be deployed to the blockchain by If it doesn't work, try adding (--reset).
$ yarn truffle deploy (--reset)

# Please do not upload your private key or other personal information to github below. After that, just write the file name you don't want to put in the .gitignore directory.
$ brew install direnv

# To enable direnv, you can run the following command.
$ direnv allow

```

## Website
https://image-guardian.web.app/

# Usage
```

You need to install Metamask in your browser and connect it to your virtual network!

Start Ganache and connect the Ganache blockchain to Metamask.

Image Guardian Issuer allows you to send a certificate using Metamask, specifying the name of the certificate, the number of certificates to be issued, and the destination.
You can then check with the UserPage that has the Metamask with the address that was sent!

```





For detailed explanation on how things work, check out [Nuxt.js docs](https://nuxtjs.org).
