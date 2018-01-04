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
          <md-button class="md-icon-button"  @click="$router.go(-1);">
          <md-icon>home</md-icon>
        </md-button>
        <h2 class="md-title">Project: {{project.name}}</h2>
        <span style="flex: 1"></span>
          <md-button @click=show class="md-fab md-mini">
          <md-icon>file_upload</md-icon>
        </md-button>
      </div>
    </md-toolbar>

  </md-whiteframe>

        <md-tabs>
      <md-tab id="tab-scans" md-label="Scans" to="/components/tabs/scans">


      <main class="main-content">

        <div>
      <md-list class="md-double-line">
        <md-list-item v-for="scan in scans">

          <md-avatar class="md-avatar-icon md-primary" md-theme="red" v-if="project.language === 'Ruby'" >
            <md-icon >assessment</md-icon>
          </md-avatar>
          <md-avatar class="md-avatar-icon md-primary" md-theme="orange" v-if="project.language === 'Java'" >
            <md-icon >assessment</md-icon>
          </md-avatar>
                <md-avatar class="md-avatar-icon md-primary" md-theme="green" v-if="project.language === 'Python'" >
            <md-icon >assessment</md-icon>
          </md-avatar>
          <div class="md-list-text-container">
            <router-link :to="{ path: '/scan/' + project.id+'/'+scan.id }">Scan: {{scan.title}}</router-link>
            <p> {{scan.source}}</p>
            <p>{{ scan.id }}</p>
<!--             <p>{{ scan.description }}</p>
 -->          </div>

          <md-button class="md-icon-button md-list-action"  @click=delete_scan(scan.id)>
            <md-icon>delete</md-icon>
          </md-button>
          <md-button class="md-icon-button md-list-action"  @click=view_vulns(scan.id)>
            <md-icon>file_download</md-icon>
          </md-button>

        </md-list-item>
      </md-list>
      <v-dialog/>

      </div>

      </main>
    </md-tab>

    <md-tab id="tab-history" md-label="History" to="/components/tabs/history">
      <vue-event-calendar :events="scansCalendar"></vue-event-calendar>
    </md-tab>

    <md-tab id="tab-client" md-label="Setup Client" to="/components/tabs/client">
      <h2>Quickly setup your code for scanning</h2>
      <h3>Linux/MacOS</h3>
      <pre v-highlightjs="clientLinux"><code class="bash"></code></pre>
      <h3>Windows</h3>
      <a v-bind:href="clientDownload">Download client</a>
      <p> Then run: </p>
      <pre v-highlightjs="clientWindows"><code class="bash"></code></pre>
    </md-tab>

      <md-tab id="tab-options" md-label="Options" to="/components/tabs/options">

      <div>
      <md-switch v-model="boolean">Automatically Scan</md-switch>
      <md-switch v-model="boolean" class="md-primary">Attempt Update</md-switch>
      </div>

      <div>
        <h3> Scan every: </h3>
        <md-radio v-model="radio" :value="false">Minute</md-radio>
        <md-radio v-model="radio" value="my-radio">Hour</md-radio>
        <md-radio v-model="radio">Day</md-radio>
        <md-radio v-model="radio" >Week</md-radio>
      </div>


      </md-tab>
       <md-tab id="tab-graph" md-label="Graphs" to="/components/tabs/graph">
              <div id='graphthing' style="height:500; width:500px;">

                <h1>Number of dependencies</h1> <line-chart :chart-data="depGraphData"></line-chart>
            </div>
       </md-tab>
  </md-tabs>


</div>

<modal name="upload"         :height="200" :adaptive="true" @opened="opened">
    <div style="padding: 30px; text-align: center">
          <h2 v-if="project.language == 'Ruby' " >Upload Gemfile</h2>
          <h2 v-if="project.language  === 'Java' " >Upload Pomfile</h2>
          <h2 v-if="project.language  === 'Python' " >Upload Requirements.txt</h2>
    <form enctype="multipart/form-data">
      <input type="file" @change="handle_upload_file">
    </form>
    </div>
</modal>
  </div>

</template>

<script>

  import {getToken,getProject,getScans,getDependencies,upload,getJsonReport,deleteScan,getClientLinux,getClientDownload} from '../utils/api.js';
  import Sidebar from './Sidebar'
  import LineChart from '../utils/LineChart'

  export default {
    name: 'Project',
    components:  {
      Sidebar,
      LineChart
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
        boolean: true,
        depGraphData: {
          labels: [],
          data: []
        },
       }
    },
    created() {
      this.get_project();
      this.get_scans();
      setInterval(function () {this.get_scans();}.bind(this), 10000); 
    },
    watch: {
      '$route': 'fetchData'
    },
    methods: {
      get_project() {getProject(this.$route.params.id).then(response =>  {
            this.project = response;
            this.clientLinux = getClientLinux() + ' ' + this.project.id;
            this.clientDownload = getClientDownload();
            this.clientWindows = 'ruby quickclient.rb ' + this.project.id;
          });},
      get_scans() {
          getScans(this.$route.params.id).then(response =>  {

          this.scans = response;
          this.scansCalendar = response;

          this.scans.forEach(function (scan) {
            scan.title = scan.created_at.slice(0, scan.created_at.length-8).replace("T", "  ");
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
      handle_upload_file(e){
      var files = e.target.files || e.dataTransfer.files;
      var self = this;
      var fr = new FileReader(); fr.onload = function(e) { 
        upload(self.$route.params.id,e.target.result).then(response => {
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
          console.log(a);
          var values = [];
          var aScan = locScans[a];
          getDependencies(this.$route.params.id,aScan.id).then(response =>  {

            this.values = response;
            // self.depGraphData['datasets'][0]['data'].push(this.values.length)
            // self.depGraphData['labels'].push(aScan.created_at.slice(0, aScan.created_at.length-8).replace("T", "  "))

            data.push(this.values.length)
            labels.push(aScan.created_at.slice(0, aScan.created_at.length-8).replace("T", "  "))

            self.depGraphData = {
              labels: labels,
              datasets: [{
              label: 'Number of dependencies' ,
              backgroundColor: '#0074D9', 
              data: data
              }]
             }

            // self.depGraphData['labels'].push(self.scans[a].id);
          });
          }

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
</style>
