import Vue from 'vue'
import App from './App'
import router from './router'

import VueResource from 'vue-resource'
import VueMaterial from 'vue-material'
import axios from 'axios'
import 'vue-material/dist/vue-material.css'
import './assets/font-mfizz-2.4.1/font-mfizz.css'


import vmodal from 'vue-js-modal'

Vue.config.productionTip = false
Vue.use(VueResource);
Vue.use(VueMaterial);
Vue.use(vmodal,{ dialog: true });

Vue.material.registerTheme({
  default: {
    primary: 'blue',
    accent: 'red'
  },
  green: {	
    primary: 'green',
    accent: 'pink'
  },
  orange: {
    primary: 'orange',
    accent: 'green'
  },
  red: {
    primary: 'red',
    accent: 'blue'
  },
})

new Vue({
  el: '#app',
  router,
  template: '<App/>',
  components: { App }
})