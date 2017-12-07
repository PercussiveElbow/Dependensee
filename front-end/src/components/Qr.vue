<template>
  <div id ='something'>
    <div class="app-viewport" id="file-list">
      <Sidebar ref='sidebar'></Sidebar>
        
  <md-whiteframe md-elevation="1" class="main-toolbar">
    <md-toolbar class="md-dense">
      <div class="md-toolbar-container">
        <md-button class="md-icon-button" @click="$refs.sidebar.toggleSidebar()">
          <md-icon>menu</md-icon>
        </md-button>
  
        <span style="flex: 1"></span>
  
        <md-button class="md-icon-button">
          <md-icon>search</md-icon>
        </md-button>
  
        <md-button class="md-icon-button">
          <md-icon>view_module</md-icon>
        </md-button>
      </div>


      <div class="md-toolbar-container">
        <h2 class="md-title">Scan to open on phone</h2>
      </div>
    </md-toolbar>
  </md-whiteframe>
  
  <main class="main-content">
    <qrcode v-bind:value=qr :options="{ size: 400 }"></qrcode>
  </main>


</div>
  </div>
</template>

<script>

  import {getToken} from '../utils/api.js';
  import Sidebar from './Sidebar'

  export default {
    name: 'Qr',
    data() {
      return {
        qr: ''
      }
    },
    components:  {
      Sidebar
    },
    created: function() {
        this.qr = 'http://143.117.224.77:8080/#/login?key=' + getToken()
    },
    methods: {
  
  }
}
</script>


<style scoped>
html,
body,
.app-viewport {
  height: 100%;
  overflow: hidden;
}

.app-viewport {
  display: flex;
  flex-flow: column;
}

.main-toolbar {
  position: relative;
  z-index: 10;
}

.md-fab {
  margin: 0;
  position: absolute;
  bottom: -20px;
  left: 16px;
  z-index: 10;
  
  .md-icon {
    color: #fff;
  }
}

.md-title {
  padding-left: 40px;
  color: #fff;
}

.main-content {
  position: relative;
  z-index: 1;
  overflow: auto;
}
.md-fab md-mini{
  size:100px;
}
</style>


