<template>
  <div id ='something'>
    <div class="app-viewport" id="file-list">
    <Sidebar ref='sidebar'></Sidebar>
  
  <md-whiteframe md-elevation="3" class="main-toolbar">
    <md-toolbar class="md-large">
      <div class="md-toolbar-container">
        <md-button class="md-icon-button" @click="$refs.sidebar.toggleSidebar()" >
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
          <md-button class="md-icon-button"  @click="$router.push({ path: '/projects/' });">
          <md-icon>home</md-icon>
        </md-button>
        <h2 class="md-title">Project {{project.name}}:    Scan: {{$route.params.scan_id}}</h2>
          <md-button @click=show class="md-fab md-mini">
          <md-icon>add</md-icon>
        </md-button>
              <md-button class="md-icon-button md-list-action"  @click=view_vulns()>
        <md-icon>cloud download</md-icon>
      </md-button>
      </div>
    </md-toolbar>

  </md-whiteframe>

  
  <main class="main-content">

    <div>
  <md-list class="md-double-line">
    <md-list-item v-for="dep in dependencies">

      <md-avatar class="md-avatar-icon md-primary" md-theme="red" v-if="project.language === 'Ruby'" >
        <md-icon >code</md-icon>
      </md-avatar>
      <md-avatar class="md-avatar-icon md-primary" md-theme="orange" v-if="project.language === 'Java'" >
        <md-icon >code</md-icon>
      </md-avatar>
      <md-avatar class="md-avatar-icon md-primary" md-theme="green" v-if="project.language === 'Python'" >
        <md-icon >code</md-icon>
      </md-avatar>

      <div class="md-list-text-container">
        <router-link :to="{ path: '/dependencies/'+dep.id }">{{dep.name}}</router-link>
        <p>{{ dep.version }}</p>
        <p>{{ dep.updated_at }}</p>
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

  <v-dialog/>
  </div>

</template>

<script>

  import {getProject,getScan,upload,getDependencies,getJsonReport} from '../utils/api.js';
  import Sidebar from './Sidebar'

  export default {
    name: 'Scan',
    components:  {
      Sidebar
    },
    data() {
      return {
        scan: {
        },
        project: {

        },
        dependencies: [],
        upload: {
          body : ''
        },
        report: {

        }
       }
    },
    created() {
      this.get_project();
      this.get_dependencies();
      setInterval(function () {this.get_dependencies();}.bind(this), 15000); 
    },
    watch: {
      '$route': 'fetchData'
    },
    methods: {
      get_project() {
          getProject(this.$route.params.project_id).then(response =>  {this.project = response;});
      },
      get_scan(){
          this.scan.id = this.$route.params.scan_id;
          getScan(project.id,this.$route.params.scan_id);
      },
      get_dependencies() {
          getDependencies(this.$route.params.project_id,this.$route.params.scan_id).then(response =>  {this.dependencies = response;});
      },
      view_vulns() {
         getJsonReport(this.$route.params.project_id,this.$route.params.scan_id).then(response =>  {this.open_vuln_dialog(response)})
      },
      open_vuln_dialog (response) {
        this.report=response;
          this.$modal.show('dialog', {
            title: 'Vulnerabilities',
            text: this.report,
            buttons: [
              { title: 'JSON', handler: () => { alert('pdf') } },
              { title: 'PDF' },
              { title: 'HTML'}
           ]
          })
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


