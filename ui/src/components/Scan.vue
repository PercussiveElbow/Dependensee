<template>
  <div id ='something'>
    <div class="app-viewport" id="file-list">
      <Sidebar ref='sidebar'></Sidebar>

      <md-whiteframe md-elevation="3" class="main-toolbar">
        <md-toolbar class="md-dense">
          <div class="md-toolbar-container">
            <md-button class="md-icon-button" @click="$refs.sidebar.toggleSidebar()" ><md-icon>menu</md-icon></md-button>
            <h2 class="md-title" @click="$router.push({ path: '/project/'+project.id });">Project: {{project.name}}</h2><span style="flex: 1"></span>
            <md-button class="md-icon-button" @click="$refs.cvesearch.showsearch()"><md-tooltip md-direction="left">Search</md-tooltip><md-icon>search</md-icon></md-button>
          </div>
          <div class="md-toolbar-container">
            <md-button class="md-icon-button"  @click="$router.push({ path: '/projects/' });"><md-icon>home</md-icon></md-button>
            <md-button class="md-icon-button"  @click="$router.push({ path: '/project/' + project.id });">
            <md-tooltip md-direction="bottom">Back</md-tooltip><md-icon>keyboard_backspace</md-icon></md-button>
            <h2 class="md-title">Scan: {{scan.title}}</h2>
            <md-button class="md-icon-button md-list-action"  @click=view_vulns()><md-tooltip md-direction="bottom">Reports</md-tooltip><md-icon>file_download</md-icon></md-button>
            <md-button class="md-icon-button md-list-action"  @click=update_deps()><md-tooltip md-direction="bottom">Update Dependencies</md-tooltip><md-icon>system_update_alt</md-icon></md-button>
          </div>
        </md-toolbar>
      </md-whiteframe>

      <md-tabs>
        <md-tab id="tab-deps" md-label="Dependencies" to="/components/tabs/deps">
          <DepList :dependencies.sync=dependencies :project.sync=project></DepList>
         </md-tab>

        <md-tab id="tab-vulns" md-label="Vulnerabilities" to="/components/tabs/vulns">
          <VulnList :dependencies.sync=dependencies :vulns.sync=vulns :project.sync=project ></VulnList>
        </md-tab>
        <md-tab id="tab-pages" md-label="Graphs" to="/components/tabs/pages">
          <ScanGraphs :dependencies.sync=dependencies :vulns.sync=vulns ref='scanGraphs'></ScanGraphs>
        </md-tab>
      </md-tabs>

    </div>
    <v-dialog/>
    <DepModal></DepModal>
    <CVEModal></CVEModal>
    <CVESearch ref='cvesearch'></CVESearch>
  </div>
</template>

<script>
  import {getProject,getScan,getDependencies,getJsonReport,getPdfReport,getTxtReport,updateScan} from '../utils/api.js';
  import Sidebar from './Sidebar'
  import CVESearch from './CveSearch'
  import DepList from './scan/DepList'
  import VulnList from './scan/VulnList'
  import ScanGraphs from './scan/ScanGraphs'
  import CVEModal from './scan/CVEModal'
  import DepModal from './scan/DepModal'

  export default {
    name: 'Scan',
    components:  {
      Sidebar,
      CVESearch,
      DepList,
      ScanGraphs,
      VulnList,
      CVEModal,
      DepModal
    },
    data() {
      return {
        scan: {},
        project: {},
        dependencies: [],
        report: {},
        vulns : [],
        intervalKill : '',
      }
    },
    created() {
      this.get_project();
      this.get_dependencies();
      this.set_vulns();
      this.get_scan();
      this.intervalKill = setInterval(function () {this.get_dependencies();}.bind(this), 60000);
    },
    destroyed() {
      clearInterval(this.intervalKill);
    },
    watch: {
      '$route': 'fetchData'
    },
    methods: {
      get_project() {getProject(this.$route.params.project_id).then(response =>  {this.project = response;});},
      get_scan(){
          this.scan.id = this.$route.params.scan_id;
          getScan(this.$route.params.project_id,this.$route.params.scan_id).then(response =>{
            this.scan=response;
            this.scan.title = this.scan.created_at.slice(0, this.scan.created_at.length-8).replace("T", "  ");
          })
      },
      get_dependencies() {getDependencies(this.$route.params.project_id,this.$route.params.scan_id).then(response =>  {this.dependencies = response;});},
      view_vulns() {getJsonReport(this.$route.params.project_id,this.$route.params.scan_id).then(response =>  {this.open_vuln_dialog(response)})},
      set_vulns(){
         getJsonReport(this.$route.params.project_id,this.$route.params.scan_id).then(response =>  
          { this.vulns=response;
            this.$refs.scanGraphs.fillData(this.dependencies,this.vulns)
          })
      },
      open_vuln_dialog (response) {
        this.report=response;
          this.$modal.show('dialog', {
            title: 'Vulnerability Report Downloads',
            buttons: [
              { title: 'JSON', handler: () => { this.openJsonReport() } },
              { title: 'PDF', handler: () => { getPdfReport(this.$route.params.project_id,this.$route.params.scan_id) } },
              { title: 'TXT', handler: () => { getTxtReport(this.$route.params.project_id,this.$route.params.scan_id) } },
              { title: 'HTML', handler: () => {alert('Html reports not implemented yet')}}
           ]
          })
      },
      update_deps(){
        this.$modal.show('dialog', {
            title: 'Update dependencies',
            buttons: [
              { title: 'Normal', handler: () => { updateScan(this.$route.params.project_id,this.$route.params.scan_id, 'normal') } },
              { title: 'Major', handler: () => { updateScan(this.$route.params.project_id,this.$route.params.scan_id, 'Major') } },
              { title: 'Minor', handler: () => { updateScan(this.$route.params.project_id,this.$route.params.scan_id, 'Minor') } }          ]
          })
      },
      openJsonReport(){
        getJsonReport(this.$route.params.project_id,this.$route.params.scan_id).then(response =>  {
          window.open(window.URL.createObjectURL(new Blob([JSON.stringify(response)], { type: 'application/json' } )));});
      },
      returnToProj(){$router.push({path: '/project/'+this.$route.params.project_id});}
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

.md-tab {
   background-color: white;
}

.md-content {
  max-width: 400px;
  max-height: 100px;
  overflow: auto;
}
</style>