export default {
  ssr: false,
  // Global page headers (https://go.nuxtjs.dev/config-head)
  env: { 
    APIKEY: 'AIzaSyA_AmJiXG-UFTrUfxBFGg6XPq56Yx5gZPg', 
    AUTHDOMAIN: 'image-guardian.firebaseapp.com', 
    PRIVATE: process.env.PRIVATE || "http://localhost:8545",
    },   
  head: {
    title: 'Image_Guardian',
    meta: [
      { charset: 'utf-8' },
      { name: 'viewport', content: 'width=device-width, initial-scale=1' },
      { hid: 'description', name: 'description', content: '' }
    ],
    link: [
      { rel: 'icon', type: 'image/x-icon', href: '/favicon.ico' }
    ]
  },

  // Global CSS (https://go.nuxtjs.dev/config-css)
  css: [
  ],

  // Plugins to run before rendering page (https://go.nuxtjs.dev/config-plugins)
  plugins: [
    { src: '~/plugins/getWeb3.js'},
    { src: '~/plugins/ipfs.js'},
    { src: '~/plugins/web3.js' },
    { src: '~/plugins/vue-carousel.js', mode: "client" },
    { src: '~/plugins/vue-image-previewer.js', mode: "client" }
  ],

  // Auto import components (https://go.nuxtjs.dev/config-components)
  components: true,

  // Modules for dev and build (recommended) (https://go.nuxtjs.dev/config-modules)
  buildModules: [
  ],

  // Modules (https://go.nuxtjs.dev/config-modules)
  modules: [
  ],

  // Build Configuration (https://go.nuxtjs.dev/config-build)
  build: {
  }
}
