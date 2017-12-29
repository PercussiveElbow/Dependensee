import Vue from 'vue'
import App from './App'
import router from './router'


import VueResource from 'vue-resource'
import VueMaterial from 'vue-material'
import axios from 'axios'
import 'vue-material/dist/vue-material.css'
import './assets/font-mfizz-2.4.1/font-mfizz.css'
import './assets/gfont/dosis.css'
import VueQrcode from '@xkeshi/vue-qrcode'
// import VueCharts from 'vue-chartjs'
import VueHighlightJS from 'vue-highlightjs'



import vmodal from 'vue-js-modal'


import 'vue-event-calendar/dist/style.css' //^1.1.10, CSS has been extracted as one file, so you can easily update it.
import vueEventCalendar from 'vue-event-calendar'
Vue.use(vueEventCalendar, {locale: 'en',className: 'Custom'})

Vue.config.productionTip = false
Vue.use(VueResource);
Vue.use(VueMaterial);
Vue.use(vmodal,{ dialog: true });
Vue.use(VueQrcode);
Vue.use(VueHighlightJS)

Vue.component('qrcode', VueQrcode);


// Vue.use(VueCharts)

Vue.material.registerTheme({
  default: {
    primary: 'indigo',
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