<template>
  <div id ='something'>
    <div class="app-viewport" id="file-list">
      <md-sidenav class="md-left md-fixed" ref="sidebar">
        <md-toolbar class="md-account-header">
          <md-list class="md-transparent">
            <md-list-item class="md-avatar-list">
              <md-avatar class="md-large">
                <img src="https://placeimg.com/128/128/tech" alt="People">
              </md-avatar>
      
              <span style="flex: 1"></span>
      
            </md-list-item>
      
            <md-list-item>
              <div class="md-list-text-container">
                <span>John Doe</span>
                <span>test@example.com</span>
              </div>
      
              <md-button class="md-icon-button md-list-action">
                <md-icon>arrow_drop_down</md-icon>
              </md-button>
            </md-list-item>
          </md-list>
        </md-toolbar>
      
        <md-list>
          <md-list-item >
                   <router-link :to="{ path: '/projects/' }">Projects</router-link>
          </md-list-item>
          <md-list-item >
                   <router-link :to="{ path: '/dependencies/' }">Dependencies</router-link>
          </md-list-item> 

                <md-list-item @click="$refs.sidebar.toggle()">
            <md-icon>warning</md-icon> <span>Vulnerabilities</span>
          </md-list-item>

          <md-list-item @click="$refs.sidebar.toggle()">
            <md-icon>autorenew</md-icon> <span>Quick Scan</span>
          </md-list-item>
        </md-list>
      </md-sidenav>
  
  <md-whiteframe md-elevation="3" class="main-toolbar">
    <md-toolbar class="md-large">
      <div class="md-toolbar-container">
        <md-button class="md-icon-button" @click="$refs.sidebar.toggle()">
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
        <h2 class="md-title">Project: {{project.name}}</h2>
  
      </div>
    </md-toolbar>
  </md-whiteframe>
  
  <main class="main-content">

    <div>
  <md-list class="md-double-line">
    <md-list-item v-for="scan in scans">

      <md-avatar md-theme="green" class="md-avatar-icon md-primary">
        <md-icon >code</md-icon>
      </md-avatar>

      <div class="md-list-text-container">
        <router-link :to="{ path: '/scans/'+scan.id }">{{scan.id}}</router-link>
        <p>{{ scan.updated_at }}</p>
        <p>{{ scan.description }}</p>
      </div>

      <md-button class="md-icon-button md-list-action"  @click=delete_project(item.id)>
        <md-icon>delete</md-icon>
      </md-button>
      <md-button class="md-icon-button md-list-action"  @click=editshow(item.id)>
        <md-icon>edit</md-icon>
      </md-button>


    </md-list-item>
  </md-list>
  </div>

  </main>


</div>
  </div>
</template>

<script>

  import {getToken,getProject,getScans} from '../utils/api.js';

  export default {
    name: 'Project',
    data() {
      return {
        project: {},
        scans: []
      }
    },
    created() {
      this.get_project();
      this.get_scans();
    },

    watch: {
      '$route': 'fetchData'
    },
    methods: {
      get_project() {
          console.log(getToken());
          getProject(this.$route.params.id,{headers: {'Authorization': getToken()}}).then(response =>  {this.project = response;});
      },
      get_scans() {
          getScans(this.$route.params.id,{headers: {'Authorization': getToken()}}).then(response =>  {this.scans = response;});
          console.log(scans);
      },
      go_projects() {
          this.$router.push({ path: '/projects/' }); 
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

.md-list-action .md-icon {
  color: rgba(#000, .26);
}

.md-avatar-icon .md-icon {
  color: #fff !important;
}

.md-sidenav .md-list-text-container > :nth-child(2) {
  color: rgba(#fff, .54);
}

.md-account-header {
  .md-list-item:hover .md-button:hover {
    background-color: inherit;
  }

  .md-avatar-list .md-list-item-container:hover {
    background: none !important;
  }
}
</style>


