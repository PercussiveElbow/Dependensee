// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue'
import App from './App'
import VueResource from 'vue-resource'
import VueMaterial from 'vue-material'
import 'vue-material/dist/vue-material.css'
import axios from 'axios'

Vue.config.productionTip = false
Vue.use(VueResource);
Vue.use(VueMaterial);
Vue.use(axios);

axios.get
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
/* eslint-disable no-new */
new Vue({
  el: '#app',
  template: '<App/>',
  components: { App }
})
