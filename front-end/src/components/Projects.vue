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
      <md-list-item @click="$refs.sidebar.toggle()" class="md-primary">
        <md-icon>folder</md-icon> <span>Projects</span>
      </md-list-item>
  
      <md-list-item @click="$refs.sidebar.toggle()">
        <md-icon>dehaze</md-icon> <span>Dependencies</span>
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
        <h2 class="md-title">Projects</h2>
  
        <md-button @click=show class="md-fab md-mini">
          <md-icon>add</md-icon>
        </md-button>
      </div>
    </md-toolbar>
  </md-whiteframe>
  
  <main class="main-content">
      <ProjectList></ProjectList>
  </main>

<modal name="create-project"         :height="350" :adaptive="true" @opened="opened">
    <div style="padding: 30px; text-align: center">
              <h2 >Add a new project</h2>

        <md-input-container>
          <md-icon>work</md-icon>
          <label>New Project</label>
          <md-input name v-model="newproject.name" />
        </md-input-container>
        <md-input-container>
          <md-icon>description</md-icon>
          <label>Description</label>
          <md-input name v-model="newproject.description" />
        </md-input-container>
       <select v-model="newproject.language">
            <option>Ruby</option>
            <option>Java</option>
            <option>Python</option>
          </select>
        </br>
  <md-button class="md-primary md-raised" v-on:click=create_project>Create</md-button>
    </div>
</modal>

</div>
  </div>
</template>

<script>

  import {getToken,getProjects} from '../utils/api.js';
  import ProjectList from './ProjectList'
  import ProjectsCreate from './ProjectsCreate'

  export default {
    name: 'Projects',
    components:  {
      ProjectList,
      ProjectsCreate
    },
         data() {
      return {
        newproject: {
          name: '',
          language: '',
        },
        error: ''
      }
    },
    
    methods: {
   create_project: function(newproject) {
          var formCreds = new FormData();
          formCreds.append('name', this.newproject.name);
          formCreds.append('description', this.newproject.description);
          formCreds.append('language',this.newproject.language);
          this.$http.post('http://localhost:3000/projects/', formCreds, {headers: {'Authorization': getToken()}}, (data) => {});
          // this.poll_projects();
          this.hide();
   },
   openDialog: function(ref) {
    
   },
   show () {
    this.$modal.show('create-project');
  }, hide () {
        this.$modal.hide('create-project');
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


