<template>
  <div id ='something'>
    <div class="app-viewport" id="file-list">
      <Sidebar ref='sidebar'></Sidebar>

      <md-whiteframe md-elevation="3" class="main-toolbar">
        <md-toolbar class="md-dense">
          <div class="md-toolbar-container">
            <md-button class="md-icon-button" @click="$refs.sidebar.toggleSidebar()" ><md-icon>menu</md-icon></md-button>
            <h2 class="md-title" @click="$router.push({ path: '/project/'+project.id });">Project: {{project.name}}</h2><span style="flex: 1"></span>
            <md-button class="md-icon-button" @click="$refs.cvesearch.showsearch()"><md-icon>search</md-icon></md-button>
            <md-button class="md-icon-button"><md-icon>view_module</md-icon></md-button>
          </div>

          <div class="md-toolbar-container">
            <md-button class="md-icon-button"  @click="$router.push({ path: '/projects/' });"><md-icon>home</md-icon></md-button>
              <md-button class="md-icon-button"  @click="$router.push({ path: '/project/' + project.id });">
              <md-icon>keyboard_backspace</md-icon>
            </md-button>
            <h2 class="md-title">Scan: {{scan.title}}</h2>
            <md-button class="md-icon-button md-list-action"  @click=view_vulns()><md-icon>file_download</md-icon></md-button>
            <md-button class="md-icon-button md-list-action"  @click=update_deps()><md-icon>system_update_alt</md-icon></md-button>
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


                  <h4 style="text-align: left" v-for="(vuln,title) in vulns">{{title}} [{{vuln[0].our_version}}]
                  <md-list-item v-for="thing in vuln">
                    <md-avatar class="md-avatar-icon md-primary" md-theme="red" v-if="project.language === 'Ruby'" ><md-icon >warning</md-icon></md-avatar>
                    <md-avatar class="md-avatar-icon md-primary" md-theme="orange" v-if="project.language === 'Java'"><md-icon >warning</md-icon></md-avatar>
                    <md-avatar class="md-avatar-icon md-primary" md-theme="green" v-if="project.language === 'Python'"><md-icon >warning</md-icon></md-avatar>
                    <div class="md-list-text-container">
                      <a @click=openCVEModal(vuln)>CVE-{{thing.cve}}</a>
                      <p>Patched ver: {{ thing.patched_version }}</p>
                    </div>
                  </md-list-item>
                </h4>
              </md-list>
            </div>
          </main>     
        </md-tab>
        <md-tab id="tab-pages" md-label="Graphs" to="/components/tabs/pages">
          <div id='graphthing' style="height:500; width:500px;">
               <h1>Vulnerable vs Safe Dependencies</h1> <pie-chart :chart-data="pieData"></pie-chart></br>
               <h1>Vulnerability Severity</h1> <bar-chart :chart-data="graphData"></bar-chart>
          </div>
        </md-tab>
      </md-tabs>
    </div>
    <v-dialog/>

    <modal name="cvemodal" :height="650" :adaptive="true" >
      <div style="padding: 13px; text-align: left">
              <h1  v-bind:style="{ color: activeColor}" style ="text-align: center" >CVE {{cve.cve_id}}</h1>
              <h2 style ="text-align: center" >{{cve.title}}</h2>
              <p>{{selectedvuln.depname}}</p>
              <span style="font-weight: bold" >CVSS2 Score: </span><span > {{cve.cvss2}}</span>
                 <p v-if="project.language === 'Python' | project.language === 'Java'" >{{cve.desc}}</p>
                 </br v-if="project.language === 'Ruby'">
                  <a v-if="project.language === 'Ruby'" class="md-title" @click="$router.push({ path: '/cve/'+cve.id });">Description</a>
                  </br v-if="project.language === 'Ruby'">
  <!--             <span class="md-subheading" style="font-weight: bold" >Versions</span></br>
   -->            <span style="font-weight: bold" >Our version: </span><span>{{selectedvuln.our_version}}</span></br>
              <div v-if="project.language === 'Python' | project.language === 'Java'">
                <span style="font-weight: bold" >Patched version: </span><span>{{selectedvuln.patched_version}}</span>
              </div>

              <div v-if="project.language === 'Ruby'">
                </br>
                <span class="md-subheading" style="font-weight: bold">Patched versions</span ></br>
                <span v-for="patched in cve.patched_versions">
                   {{patched}}</br>
                </span>
                </br>
                <span  class="md-subheading" style="font-weight: bold">Unaffected versions</span ></br>
                <span v-for="unaffected in cve.unaffected_versions">
                   {{unaffected}}</br>
                </span>
              </div>
              </br>
              <span v-if="project.language === 'Python' | project.language === 'Java'" class="md-subheading" style="font-weight: bold">Affected</span ></br>
              <span v-if="project.language === 'Python' | project.language === 'Java'" v-for="affected in cve.affected">
                   {{affected}}</br>
              </span></br>
              <span v-if="project.language === 'Python' | project.language === 'Java'" class="md-subheading" style="font-weight: bold">References</span></br>
              <div v-if="project.language === 'Python' | project.language === 'Java'" v-for="reference in cve.references">
                       <a v-bind:href="reference">{{reference}}</a></br>
              </div>
              </br>
          <div style="text-align: center">
  <!--           <span style="font-weight: bold">Open:</span></br>
   -->          <md-button style="margin-left: 0px; margin-right: 0px" class="md-primary md-raised" @click="mitre(cve.cve_id)">Mitre</md-button>
            <md-button  style="margin-left: 0px; margin-right: 0px" @click="nvdb(cve.cve_id)" class="md-primary md-raised">NVDB</md-button>
            <md-button style="margin-left: 0px; margin-right: 0px" @click="cvedetails(cve.cve_id)" class="md-primary md-raised">CVEDetails</md-button>
            <md-button style="margin-left: 0px; margin-right: 0px" class="md-primary md-raised" @click="rapid7(cve.cve_id)">Rapid7</md-button>
            <md-button @click="getExploitInfo(cve.cve_id)" style="background-color: red; margin-left: 0px; margin-right: 0px" class="md-primary md-raised">Exploit</md-button>
          </div>
      </div>
    </modal>

    <modal name="depmodal" :height="260" :adaptive="true" >
      <div style="padding: 15px; text-align: left">
        <i class="icon-python" style="font-size: 1.75em" v-if="project.language === 'Python'"></i>
          <i class="icon-java" style="font-size: 1.75em" v-if="project.language === 'Java'"></i>
          <i class="icon-ruby" style="font-size: 1.75em" v-if="project.language === 'Ruby'"></i>
          <h1 style ="text-align: center" >{{selecteddep.name}}</h1>
         <span style="font-weight: bold">Version: </span><span>{{selecteddep.version}}</span>
         </br>
          <span style="font-weight: bold">Latest version: </span><a>{{selecteddep.latestver}}</a>
         </br></br>
         <span style="font-weight: bold">Raw: </span><span> {{selecteddep.raw}}</span>
          </br>
          <div style="text-align: center">
       <!--      <span style="font-weight: bold">Open on:</span></br> -->
            <md-button v-if="project.language === 'Java'" class="md-primary md-raised" @click="maven(selecteddep.name)">Maven Central</md-button>
            <md-button v-if="project.language === 'Python'" class="md-primary md-raised" @click="pypi(selecteddep.name)">Pypi</md-button>
            <md-button v-if="project.language === 'Ruby'" class="md-primary md-raised" @click="rubygems(selecteddep.name)">Ruby Gems</md-button>
          </div>
      </div>
    </modal>
    <CVESearch ref='cvesearch'></CVESearch>
  </div>
</template>

<script>
  import {getProject,getScan,upload,getDependencies,getJsonReport,getCve,getPdfReport,getTxtReport,getExploit,updateScan,dependencyLatest} from '../utils/api.js';
  import Sidebar from './Sidebar'
  import PieChart from '../utils/PieChart.js'
  import BarChart from '../utils/BarChart.js'
  import CVESearch from './CveSearch'

  export default {
    name: 'Scan',
    components:  {
      Sidebar,
      BarChart,
      PieChart,
      CVESearch
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
        pieData: {
          labels: [],
          data: []
        },
        cveThing: '',
        activeColor: 'white',
        selecteddep: {
          latestver : ''
        },
        datacollection: null,
        intervalKill : ''
      }
    },
    created() {
      this.get_project();
      this.get_dependencies();
      this.set_vulns();
      this.get_scan();
      this.graphWidth = window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth;
      this.graphHeight = window.innerHeight || document.documentElement.clientHeight  || document.body.clientHeight;
      this.intervalKill = setInterval(function () {this.get_dependencies();}.bind(this), 60000);
    },
    destroyed() {
      clearInterval(this.intervalKill);
    },
    watch: {
      '$route': 'fetchData'
    },
    methods: {
      swapComponent: function(component){
        this.currentComponent = component;
      },
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
        this.datacollection = {
          labels: [],
          datasets: []
        };
         getJsonReport(this.$route.params.project_id,this.$route.params.scan_id).then(response =>  
          { this.vulns=response;
                  this.fillData();
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
      openCVEModal(vuln){
        getCve(vuln[0].cve).then(response => {
          this.cve = response
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
        this.selecteddep.latestver = 'Fetching..'
        dependencyLatest(this.$route.params.project_id,this.$route.params.scan_id,this.selecteddep.id).then(response =>  {
          this.selecteddep.latestver = response.version;
          this.$modal.show('depmodal');
        });
      },
      maven(dep_name){window.location.href = 'https://search.maven.org/#search%7Cga%7C1%7C'+ dep_name},
      rubygems(dep_name){window.location.href = 'https://rubygems.org/gems/'+ dep_name},
      pypi(dep_name){window.location.href = 'https://pypi.python.org/pypi/'+ dep_name},
      mitre(cve_id){window.location.href = 'https://cve.mitre.org/cgi-bin/cvename.cgi?name='+ cve_id},
      nvdb(cve_id){window.location.href = 'https://nvd.nist.gov/vuln/detail/'+ cve_id},
      cvedetails(cve_id){window.location.href = 'https://www.cvedetails.com/cve/CVE-'+ cve_id},
      rapid7(cve_id){window.location.href = 'https://www.rapid7.com/db/search?utf8=%E2%9C%93&q=' + cve_id + '&t=a'},
      cvemodalshow(cve){this.$modal.show('depmodal');},
      openJsonReport(){
        getJsonReport(this.$route.params.project_id,this.$route.params.scan_id).then(response =>  {
          window.open(window.URL.createObjectURL(new Blob([JSON.stringify(response)], { type: 'application/json' } )));});
      },
      returnToProj(){$router.push({path: '/project/'+this.$route.params.project_id});},
      getExploitInfo(cve_id){getExploit(cve_id);}, 
     fillData () {
        this.graphData = {
          labels: [],
          datasets: [
          { label: 'Severity (CVSS2)' ,
           backgroundColor: '#0074D9', 
           data: []
          } 
          ]
        }
        this.pieData = {
          labels: ['Safe','Vuln'],
          datasets: [
            {
              label: ['Safe','Vuln'],
              backgroundColor: [
              '#2ECC40',
              'red'],
              data: [this.dependencies.length-Object.getOwnPropertyNames(this.vulns).length+1,Object.getOwnPropertyNames(this.vulns).length-1]
            }
          ]
        }

            var self = this;
            var data = [];
            var labels = []
            var keys = Object.keys(this.vulns);
            for(var i=0;i<keys.length;i++){
                var key = keys[i];
                var len = this.vulns[key].length;
                var someData = [];
                for(var j=0; j<len; j++){
                         var vthing = this.vulns[key][j];
                         var labelname = this.vulns[key][j].cve;

                          if( labelname !== undefined){
                            getCve(labelname).then(response =>  {
                              if(response['cvss2'] !== undefined){
                                labels.push(labelname);
                                data.push(parseFloat(response['cvss2']))
                              self.graphData = {
                                labels: labels,
                                datasets: [{
                                label: 'Severity (CVSS2)' ,
                                backgroundColor: '#0074D9', 
                                data: data
                                }]
                               }}
                            });
                        }
                }
            }
      },
      getRandomInt () {
        return Math.floor(Math.random() * (50 - 5 + 1)) + 5
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

.md-tab {
   background-color: white;
}

.md-content {
  max-width: 400px;
  max-height: 100px;
  overflow: auto;
}

</style>


