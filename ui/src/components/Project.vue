<template>
  <div id ='something'>
    <div class="app-viewport" id="file-list">
      <Sidebar ref='sidebar'></Sidebar>
      <md-whiteframe md-elevation="3" class="main-toolbar">
        <md-toolbar class="md-dense">
          <div class="md-toolbar-container">
            <md-button class="md-icon-button" @click="$refs.sidebar.toggleSidebar()"><md-icon>menu</md-icon></md-button>
            <span style="flex: 1"></span>
            <md-button class="md-icon-button" @click="$refs.cvesearch.showsearch()"><md-tooltip md-direction="left">Search</md-tooltip><md-icon>search</md-icon></md-button>
          </div>
          <div class="md-toolbar-container">
            <md-button class="md-icon-button"  @click="$router.push({ path: '/projects/' });"><md-icon>home</md-icon></md-button>
            <h2 class="md-title">Project: {{project.name}}</h2>
            <span style="flex: 1"></span>
            <md-button @click=show class="md-fab md-mini"><md-tooltip md-direction="left">Upload Dependencies</md-tooltip><md-icon>file_upload</md-icon></md-button>
          </div>
        </md-toolbar>
      </md-whiteframe>
      <md-tabs>
        <md-tab id="tab-scans" md-label="Scans" to="/components/tabs/scans">
          <main class="main-content">
            <div>
              <md-list class="md-double-line">
                <md-list-item v-for="scan in scans" v-bind:key="scan.id">
                  <md-avatar class="md-avatar-icon md-primary" md-theme="red" v-if="project.language === 'Ruby'"><md-icon >assessment</md-icon></md-avatar>
                  <md-avatar class="md-avatar-icon md-primary" md-theme="orange" v-if="project.language === 'Java'"><md-icon >assessment</md-icon></md-avatar>
                  <md-avatar class="md-avatar-icon md-primary" md-theme="green" v-if="project.language === 'Python'"><md-icon >assessment</md-icon></md-avatar>
                  <div class="md-list-text-container">
                    <router-link :to="{ path: '/scan/' + project.id+'/'+scan.id }">{{scan.alttitle}}</router-link>
                    <p> {{scan.source}}</p>
                    <p>{{ scan.id }}</p>     
                  </div>
                  <md-button class="md-icon-button md-list-action" @click=delete_scan(scan.id)><md-tooltip md-direction="top">Delete</md-tooltip><md-icon>delete</md-icon></md-button>
                  <md-button class="md-icon-button md-list-action" @click=view_vulns(scan.id)><md-icon>file_download</md-icon></md-button>
                </md-list-item>
              </md-list>
              <v-dialog/>
            </div>
          </main>
        </md-tab>
        <md-tab id="tab-history" md-label="History" to="/components/tabs/history">
          <vue-event-calendar :events="scansCalendar"></vue-event-calendar>
        </md-tab>
        <md-tab id="tab-graph" md-label="Graphs" to="/components/tabs/graph">
          <div id='graphthing' >
            <h1>Number of dependencies</h1> <line-chart :chart-data="depGraphData"></line-chart>
          </div>
        </md-tab>
        <md-tab id="tab-client" md-label="Setup Client" to="/components/tabs/client">
          <h2>Quickly setup your code for scanning</h2>
          <h4>First export "DEPENDENSEE_API_KEY" to your shell. Your API key is: </h4>
          <h6> {{token}}</h6>
          <h3>Linux/MacOS</h3>
          <pre v-highlightjs="clientLinux"><code class="bash"></code></pre>
          <h3>Windows</h3>
          <a v-bind:href="clientDownload">Download client</a>
          <span> and run: </span></br>
          <pre v-highlightjs="clientWindows"><code class="bash"></code></pre>
        </md-tab>
        <md-tab id="tab-options" md-label="Options" to="/components/tabs/options">
          <div>
            <md-switch v-model="settings.auto_scan" >Automatically Scan</md-switch></br>
            <md-switch v-model="settings.auto_update" >Automatically Update</md-switch>
          </div>
          <div>
            <h3> Scan every: </h3>
            <select v-model="settings.timeout" name="Timeout">
              <option value=60>Minute</option>
              <option value=3600>Hour</option>
              <option value=86400>Day</option>
              <option value=604800>Week</option>
            </select>
          </div>
          <md-button class="md-raised md-primary" v-on:click=saveSettings>Save settings</md-button>
        </md-tab>
      </md-tabs>
    </div>
    <modal name="upload"         :height="200" :adaptive="true">
        <div style="padding: 30px; text-align: center">
              <h2 v-if="project.language == 'Ruby' " >Upload Gemfile.lock</h2>
              <h2 v-if="project.language  === 'Java' " >Upload Pomfile</h2>
              <h2 v-if="project.language  === 'Python' " >Upload Requirements.txt</h2>
        <form enctype="multipart/form-data"><input type="file" @change="handle_upload_file"></form>
        </div>
    </modal>
    <CVESearch ref='cvesearch'></CVESearch>
  </div>
</template>

<script>
  import {getToken,getProject,getScans,getClientWindows,getDependencies,upload,getJsonReport,deleteScan,getClientLinux,getClientDownload,editProject} from '../utils/api.js';
  import Sidebar from './Sidebar'
  import LineChart from '../utils/LineChart'
  import CVESearch from './CveSearch'

  export default {
    name: 'Project',
    components:  {
      Sidebar,
      LineChart,
      CVESearch
    },
    data() {
      return {
        project: {

        },
        scans: [],
        scansCalendar: [],
        report: {},
        clientDownload: '',
        clientLinux: '',
        clientWindows: '',
        depGraphData: {
          labels: [],
          data: []
        },
        settings: {
          auto_scan: false,
          timeout: 3600,
          auto_update: false
        },
        intervalKill : '',
        token : ''
       }
    },
    created() {
      this.get_project();
      this.get_scans();
      this.intervalKill = setInterval(function () {this.get_scans();}.bind(this), 10000); 
    },
    destroyed() {
      clearInterval(this.intervalKill);
    },
    watch: {
      '$route': 'fetchData'
    },
    methods: {
      get_project() {
        getProject(this.$route.params.id).then(response =>  {
            this.project = response;
            this.settings.auto_scan = response.auto_scan;
            this.settings.auto_update = response.auto_update
            this.settings.timeout = response.timeout;
            this.clientLinux = getClientLinux() + ' ' + this.project.id;
            this.clientDownload = getClientDownload();
            this.clientWindows = getClientWindows() + this.project.id;
            this.token = getToken()
          });},
      get_scans() {
          getScans(this.$route.params.id).then(response =>  {
          this.scans = response;
          this.scansCalendar = response;
          this.scans.forEach(function (scan) {
            scan.title = scan.created_at.slice(0, scan.created_at.length-8).replace("T", "  ");
            scan.alttitle = scan.created_at.slice(0, scan.created_at.length-8).replace("T", "  ");
          });
          this.scansCalendar.forEach(function (ascan) {
            ascan.title = ascan.created_at.slice(ascan.created_at.length-13, ascan.created_at.length-8).replace("T", "  ");
            ascan.date = ascan.created_at.slice(0, 10)
            ascan.date = ascan.date.replace(/-/g,"/");
            ascan.desc = "Vulns found (DEBUG)"
          });

          this.fillData();
      });
      },
      delete_scan(id) {
        deleteScan(this.$route.params.id,id)
        this.get_scans;
      },
      saveSettings(){
          var formCreds = new FormData();
          formCreds.append('auto_scan',this.settings.auto_scan);
          formCreds.append('auto_update',this.settings.auto_update);
          formCreds.append('timeout',this.settings.timeout);
          editProject(this.$route.params.id,formCreds);
      },
      handle_upload_file(e){
        var files = e.target.files || e.dataTransfer.files;
        var self = this;
        var fr = new FileReader(); fr.onload = function(e) { 
          upload(self.$route.params.id,e.target.result,"Web [" + window.navigator.userAgent + "] ").then(response => {
            self.$router.push({ path: '/scan/' + self.project.id+'/'+response['scan_id'] });
            self.hide();
            });
        }; 
        fr.readAsText(files[0]);
      },
      show () {this.$modal.show('upload');},
      hide () {this.$modal.hide('upload');},
      view_vulns(scan_id) {getJsonReport(this.$route.params.id,scan_id).then(response =>  {this.open_vuln_dialog(response)})},
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
      },
      fillData(){
        this.depGraphData = {
          labels: [],
          datasets: [
          { label: 'Number of dependencies' ,
           backgroundColor: '#0074D9', 
           data: []
          } 
          ]
        }
        var self = this;
        var data = []
        var labels = []
        var locScans = this.scans;
        for(var a= locScans.length-1; a>=0; a--){
          var values = [];
          var aScan = locScans[a];
          this.process_graph(self,data,values,labels,locScans[a])
          }
      },
      process_graph(self,data,values,labels,aScan){
          getDependencies(this.$route.params.id,aScan.id).then(response =>  {
            data.push(response.length)
            labels.push(aScan.created_at.slice(0, aScan.created_at.length-8).replace("T", "  "))
            self.depGraphData = {
              labels: labels,
              datasets: [{
                label: 'Number of dependencies' ,
                backgroundColor: '#0074D9', 
                data: data
              }]
             }
        });
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
  top: 60px;
  left: 0;
  z-index: 10;
  .md-icon {
    color: #fff;
  }
}

.main-content {
  position: relative;
  z-index: 1;
  overflow: auto;
}
</style>