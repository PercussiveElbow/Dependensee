<template>
  <div id ='something'>
    <div class="app-viewport" id="file-list">
    <Sidebar ref='sidebar'></Sidebar>
  
  <md-whiteframe md-elevation="3" class="main-toolbar">
    <md-toolbar class="md-large">
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
          <md-button class="md-icon-button"  @click="go_projects">
          <md-icon>home</md-icon>
        </md-button>
        <h2 class="md-title">Cve {{cve.id}}</h2>
          <md-button @click=show class="md-fab md-mini">
          <md-icon>add</md-icon>
        </md-button>
      </div>
    </md-toolbar>

  </md-whiteframe>

  
  <main class="main-content">

      {{cve}}
  </main>


</div>
  </div>

</template>

<script>

  import {getCve} from '../utils/api.js';
  import Sidebar from './Sidebar'

  export default {
    name: 'Cve',
    components:  {
      Sidebar
    },
    data() {
      return {
        cve: {
        }
       }
    },
    created() {
      this.cve.id = this.$route.params.cve_id
      this.get_cve();
    },
    watch: {
      '$route': 'fetchData'
    },
    methods: {
      get_cve() {
        getCve(this.$route.params.cve_id).then(resp => {this.cve = resp;});
      }
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
  padding-left: 8px;
  color: #fff;
}

.main-content {
  position: relative;
  z-index: 1;
  overflow: auto;
}


</style>


