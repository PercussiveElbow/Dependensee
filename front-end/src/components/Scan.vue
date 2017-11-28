<template>
  <div id ='something'>
    <div class="app-viewport" id="file-list">
    <Sidebar ref='sidebar'></Sidebar>

  <md-whiteframe md-elevation="3" class="main-toolbar">
    <md-toolbar class="md-large">
      <div class="md-toolbar-container">
        <md-button class="md-icon-button" @click="$refs.sidebar.toggleSidebar()" ><md-icon>menu</md-icon></md-button>
        <span style="flex: 1"></span>
        <md-button class="md-icon-button"><md-icon>search</md-icon></md-button>
        <md-button class="md-icon-button"><md-icon>view_module</md-icon></md-button>
      </div>

      <div class="md-toolbar-container">
        <md-button class="md-icon-button"  @click="$router.push({ path: '/projects/' });"><md-icon>home</md-icon></md-button>
        <h2 class="md-title">Project {{project.name}}:    Scan: {{scan.created_at}}</h2>
        <md-button class="md-icon-button md-list-action"  @click=view_vulns()><md-icon>cloud download</md-icon></md-button>
      </div>
    </md-toolbar>
  </md-whiteframe>

    <md-tabs>
        <md-tab id="tab-deps" md-label="Dependencies" to="/components/tabs/deps">
          <main class="main-content">
            <div>
              <md-list class="md-double-line">
                <md-list-item v-for="dep in dependencies">
                  <md-avatar class="md-avatar-icon md-primary" md-theme="red" v-if="project.language === 'Ruby'"><md-icon>code</md-icon></md-avatar>
                  <md-avatar class="md-avatar-icon md-primary" md-theme="orange" v-if="project.language === 'Java'"><md-icon>code</md-icon></md-avatar>
                  <md-avatar class="md-avatar-icon md-primary" md-theme="green" v-if="project.language === 'Python'"><md-icon>code</md-icon></md-avatar>
                  <div class="md-list-text-container">
                    <a @click=openDepModal(dep)>{{dep.name}}</a>
                    <p>{{ dep.version }}</p>
                    <p>{{ dep.updated_at }}</p>
                  </div>
                  <md-button v-if="project.language === 'Java'" class="md-icon-button md-list-action"  @click=maven(dep.name)><md-icon>search</md-icon></md-button>
                </md-list-item>
              </md-list>
            </div>
          </main>
        </md-tab>

      <md-tab id="tab-vulns" md-label="Vulnerabilities" to="/components/tabs/vulns">
        <main class="main-content">
          <div>
            <md-list class="md-double-line">
                <md-list-item v-for="vuln in vulns">
                  <md-avatar class="md-avatar-icon md-primary" md-theme="red" v-if="project.language === 'Ruby'" ><md-icon >warning</md-icon></md-avatar>
                  <md-avatar class="md-avatar-icon md-primary" md-theme="orange" v-if="project.language === 'Java'"><md-icon >warning</md-icon></md-avatar>
                  <md-avatar class="md-avatar-icon md-primary" md-theme="green" v-if="project.language === 'Python'"><md-icon >warning</md-icon></md-avatar>
                  <div class="md-list-text-container">
                    <a @click=openCVEModal(vuln)>CVE: {{vuln[0].cve}}</a>
                    <p>Our ver: {{ vuln[0].our_version }}</p>
                    <p>Patched ver: {{ vuln[0].patched_version }}</p>
                  </div>
                  <md-button class="md-icon-button md-list-action" @click=delete_scan(scan.id)><md-icon>delete</md-icon></md-button>
                  <md-button class="md-icon-button md-list-action" @click=editscan(scan.id)><md-icon>edit</md-icon></md-button>
                </md-list-item>
            </md-list>
          </div>
        </main>     
      </md-tab>

      <md-tab id="tab-pages" md-label="Graphs" to="/components/tabs/pages">
        <div id='graphthing' style="height:500; width:500px;">
          <line-chart :data="graphData" ></line-chart>
        </div>
      </md-tab>
      <md-tab id="tab-reports" md-label="Reports" to="/components/tabs/reports">
            Reports tab
            <p>Qui, voluptas repellat impedit ducimus earum at ad architecto consectetur perferendis aspernatur iste amet ex tempora animi, illum tenetur quae assumenda </p>
      </md-tab>
      <md-tab id="tab-options" md-label="Options" to="/components/tabs/options">
            Options tab
            <p>Maiores, dolorum. Beatae, optio tempore fuga odit aperiam velit, consequuntur magni inventore sapiente alias sequi odio qui harum dolorem sunt quasi corporis.</p>
      </md-tab>
    </md-tabs>
  </div>
  <v-dialog/>

  <modal name="cvemodal" :height="650" :adaptive="true" >
    <div style="padding: 20px; text-align: left">
      <h1 style ="text-align: left" >{{cve.cvss2}}/10</h1>
            <h1  v-bind:style="{ color: activeColor}" style ="text-align: center" >CVE {{cve.cve_id}}</h1>
            <h2 style ="text-align: center" >{{cve.title}}</h2>
            <p>{{selectedvuln.depname}}</p>
            <p>{{cve.desc}}</p>

            <span class="md-subheading" style="font-weight: bold" >Versions</span></br>
            <span>Our version: {{selectedvuln.our_version}}</span></br>
            <span>Patched version: {{selectedvuln.patched_version}}</span>
            </br></br>

            <span class="md-subheading" style="font-weight: bold">Affected</span ></br>
            <span v-for="affected in cve.affected">
                 {{affected}}</br>
            </span></br>
            <span class="md-subheading" style="font-weight: bold">References</span></br>
            <a v-for="reference in cve.references">
                 {{reference}}</br>
            </a>
            </br>
        <div style="text-align: center">
          <span style="font-weight: bold">Open on:</span></br>
          <md-button class="md-primary md-raised" @click="mitre(cve.cve_id)">Mitre</md-button>
          <md-button  @click="nvdb(cve.cve_id)" class="md-primary md-raised">NVDB</md-button>
          <md-button @click="cvedetails(cve.cve_id)" class="md-primary md-raised">CVEDetails</md-button>
        </div>
    </div>
  </modal>


  <modal name="depmodal" :height="300" :adaptive="true" >
    <div style="padding: 20px; text-align: left">
      <i class="icon-python" v-if="project.language === 'Python'"></i>
        <i class="icon-java" v-if="project.language === 'Java'"></i>
        <i class="icon-ruby" v-if="project.language === 'Ruby'"></i>
        <h1 style ="text-align: center" >{{selecteddep.name}}</h1>
       <span style="font-weight: bold">Version: </span><span>{{selecteddep.version}}</span>
       </br>
       <span style="font-weight: bold">Raw: </span><span> {{selecteddep.raw}}</span>
       </br>
        <span style="font-weight: bold">Latest version: </span><a>{{selecteddep.latestver}}</a>
       </br>
        <div style="text-align: center">
          <span style="font-weight: bold">Open on:</span></br>
          <md-button v-if="project.language === 'Java'" class="md-primary md-raised" @click="maven(selecteddep.name)">Maven Central</md-button>
          <md-button v-if="project.language === 'Python'" class="md-primary md-raised" @click="pypi(selecteddep.name)">Pypi</md-button>
          <md-button v-if="project.language === 'Ruby'" class="md-primary md-raised" @click="rubygems(selecteddep.name)">Ruby Gems</md-button>
        </div>
    </div>
  </modal>

  </div>
</template>

<script>

  import {getProject,getScan,upload,getDependencies,getJsonReport,getCve} from '../utils/api.js';
  import Sidebar from './Sidebar'
  import LineExample from '../utils/LineExample.js'
  import PieExample from '../utils/PieExample.js'

  export default {
    name: 'Scan',
    components:  {
      Sidebar,
      LineExample,
      PieExample
    },
    data() {
      return {
        scan: {},
        project: {},
        dependencies: [],
        report: {},
        graphWidth: '',
        graphHeight: '',
        vulns : [],
        selectedvuln: {},
        cve: [],
        graphData: {
          labels: [],
          data: []
        },
        activeColor: 'white',
        selecteddep: {}
      }
    },
    created() {
      this.get_project();
      this.get_dependencies();
      this.set_vulns();
      this.get_scan();
      this.graphWidth = window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth;
      this.graphHeight = window.innerHeight || document.documentElement.clientHeight  || document.body.clientHeight;
      setInterval(function () {this.get_dependencies();}.bind(this), 15000); 
    },
    watch: {
      '$route': 'fetchData'
    },
    methods: {
      get_project() {getProject(this.$route.params.project_id).then(response =>  {this.project = response;});},
      get_scan(){
          this.scan.id = this.$route.params.scan_id;
          getScan(this.$route.params.project_id,this.$route.params.scan_id).then(response =>{this.scan=response})
      },
      get_dependencies() {getDependencies(this.$route.params.project_id,this.$route.params.scan_id).then(response =>  {this.dependencies = response;});},
      view_vulns() {getJsonReport(this.$route.params.project_id,this.$route.params.scan_id).then(response =>  {this.open_vuln_dialog(response)})},
      set_vulns(){
         getJsonReport(this.$route.params.project_id,this.$route.params.scan_id).then(response =>  
          {var vulns = response;
            this.vulns=vulns;})

         this.graphData.labels = ['January', 'February'];
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
      },
      openCVEModal(vuln){
        getCve(vuln[0].cve).then(response => {
          this.cve = response[0]
          if (parseFloat(this.cve.cvss2) > 8) {this.activeColor = 'firebrick';
          }else if (parseFloat(this.cve.cvss2) > 4) {this.activeColor = 'orange';
          }else{this.activeColor = 'black';
          }

        })
        this.selectedvuln.our_version = vuln[0].our_version;
        this.selectedvuln.patched_version = vuln[0].patched_version;
        this.$modal.show('cvemodal');
      },
      openDepModal(dep){
        this.selecteddep=dep;
        this.$modal.show('depmodal');
      },
      maven(dep_name){window.location.href = 'https://search.maven.org/#search%7Cga%7C1%7C'+ dep_name},
      rubygems(dep_name){window.location.href = 'https://rubygems.org/gems/'+ dep_name},
      pypi(dep_name){window.location.href = 'https://pypi.python.org/pypi/'+ dep_name},
      mitre(cve_id){window.location.href = 'https://cve.mitre.org/cgi-bin/cvename.cgi?name='+ cve_id},
      nvdb(cve_id){window.location.href = 'https://nvd.nist.gov/vuln/detail/'+ cve_id},
      cvedetails(cve_id){window.location.href = 'https://www.cvedetails.com/cve/CVE-'+ cve_id},
      cvemodalshow(cve){this.$modal.show('depmodal');}
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


</style>


