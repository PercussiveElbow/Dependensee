<template>
  <div id ='something'>
    <div class="app-viewport" id="file-list">
      <Sidebar ref='sidebar'></Sidebar>
      <md-whiteframe md-elevation="1" class="main-toolbar">
        <md-toolbar class="md-dense">
          <div class="md-toolbar-container">
            <md-button class="md-icon-button" @click="$refs.sidebar.toggleSidebar()"><md-icon>menu</md-icon></md-button>
            <span style="flex: 1"></span>
            <md-button class="md-icon-button" @click="$refs.cvesearch.showsearch()"><md-tooltip md-direction="left">Search</md-tooltip><md-icon>search</md-icon></md-button>
          </div>
          <div class="md-toolbar-container">
            <h2 class="md-title">Scan to open on phone    </h2><i class="material-icons">camera_alt</i>
          </div>
        </md-toolbar>
      </md-whiteframe>
      <main class="main-content">
        <qrcode v-bind:value=qr :options="{ size: 400 }"></qrcode>
        </br>
        <h1> Currently supports: </h1>
        <span class="material-icons">android</span><span>Android 4.0+</span>
        <span class="material-icons">phone_iphone</span><span>iOS</span>
      </main>
    </div>
    <CVESearch ref='cvesearch'></CVESearch>
  </div>
</template>

<script>
  import {getQr} from '../utils/api.js';
  import Sidebar from './Sidebar'
  import CVESearch from './CveSearch'

  export default {
    name: 'Qr',
    data() {
      return {
        qr: ''
      }
    },
    components:  {
      Sidebar,
      CVESearch
    },
    created: function() {
      this.qr = getQr()
    }
}
</script>