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
        <h2 class="md-title">Projects</h2>
  
        <md-button @click=show class="md-fab md-mini" >
          <md-icon>add</md-icon>
        </md-button>
      </div>
    </md-toolbar>
  </md-whiteframe>
  
  <main class="main-content">
      <ProjectList></ProjectList>
  </main>

<modal name="create-project"         :height="350" :adaptive="true" >
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
        <option disabled value="">Language</option>
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

  import {getToken,getProjects,getProfile,saveToken,postProject} from '../utils/api.js';
  import ProjectList from './ProjectList'
  import Sidebar from './Sidebar'

  export default {
    name: 'Projects',
    components:  {
      ProjectList,
      Sidebar
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
    created: function() {
        console.log(getToken())
    },
    methods: {
   create_project: function(newproject) {
          var formCreds = new FormData();
          formCreds.append('name', this.newproject.name);
          formCreds.append('description', this.newproject.description);
          formCreds.append('language',this.newproject.language);
          postProject(formCreds);
          this.hide();
          console.log(getToken());
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


