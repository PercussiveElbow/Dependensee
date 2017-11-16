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
        <h2 class="md-title">Project: {{project.name}}</h2>
          <md-button @click=show class="md-fab md-mini">
          <md-icon>add</md-icon>
        </md-button>
      </div>
    </md-toolbar>

  </md-whiteframe>

  
  <main class="main-content">

    <div>
  <md-list class="md-double-line">
    <md-list-item v-for="scan in scans">

      <md-avatar md-theme="green" class="md-avatar-icon md-primary">
        <md-icon >description</md-icon>
      </md-avatar>

      <div class="md-list-text-container">
        <router-link :to="{ path: '/scan/' + project.id+'/'+scan.id }">Scan: {{scan.id}}</router-link>
        <p>{{ scan.updated_at }}</p>
        <p>{{ scan.description }}</p>
      </div>

      <md-button class="md-icon-button md-list-action"  @click=delete_scan(scan.id)>
        <md-icon>delete</md-icon>
      </md-button>
      <md-button class="md-icon-button md-list-action"  @click=editscan(scan.id)>
        <md-icon>edit</md-icon>
      </md-button>


    </md-list-item>
  </md-list>
  </div>

  </main>


</div>

<modal name="upload"         :height="350" :adaptive="true" @opened="opened">
    <div style="padding: 30px; text-align: center">
          <h2 v-if="project.language == 'Ruby' " >Upload Gemfile</h2>
          <h2 v-if="project.language  === 'Java' " >Upload Pomfile</h2>
          <h2 v-if="project.language  === 'Python' " >Upload Dependencies.txt</h2>

          <md-input-container>
              <md-icon>work</md-icon>
              <label>Edit Project</label>
              <md-input name v-model="upload.body"/>
            </md-input-container>


         <md-input-container>
        <md-file placeholder='Select a file' ></md-file>
      </md-input-container>
  <md-button class="md-primary md-raised" v-on:click=handle_upload>Scan</md-button>
    </div>
</modal>
  </div>

</template>

<script>

  import {getToken,getProject,getScans,upload} from '../utils/api.js';
  import Sidebar from './Sidebar'

  export default {
    name: 'Project',
    components:  {
      Sidebar
    },
    data() {
      return {
        project: {

        },
        scans: [],
        upload: {
          body : ''
        }
       }
    },
    created() {
      this.get_project();
      this.get_scans();
      setInterval(function () {this.get_scans();}.bind(this), 15000); 
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
      },
      go_projects() {
          this.$router.push({ path: '/projects/' }); 
      },
      delete_scan(id) {
        this.$http.delete('http://localhost:3000/projects/'+this.$route.params.id+'/scans/' + id, {headers: {'Authorization': getToken()}}, (data) => {});
        this.get_scans;
      },
      handle_upload(){
        console.log(this.upload.body);
        upload(this.$route.params.id,this.upload.body);

      },
      show () {
        this.$modal.show('upload');
      },
      hide () {
        this.$modal.hide('upload');
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


