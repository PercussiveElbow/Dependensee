import Vue from 'vue'
import App from './App'
import router from './router'

import 'vue-material/dist/vue-material.css'
import './assets/font-mfizz-2.4.1/font-mfizz.css'
import './assets/gfont/dosis.css'
import 'vue-event-calendar/dist/style.css'
import './assets/fontawesome/css/fontawesome.min.css'

import VueResource from 'vue-resource'
import VueMaterial from 'vue-material'
import VueQrcode from '@xkeshi/vue-qrcode'
import VueHighlightJS from 'vue-highlightjs'
import vueEventCalendar from 'vue-event-calendar'
import vmodal from 'vue-js-modal'

import axios from 'axios'

Vue.use(VueResource);
Vue.use(VueMaterial);
Vue.use(VueQrcode);
Vue.use(VueHighlightJS)
Vue.use(vmodal,{ dialog: true });
Vue.use(vueEventCalendar, {locale: 'en',className: 'Custom'})

Vue.config.productionTip = false

Vue.component('qrcode', VueQrcode);

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