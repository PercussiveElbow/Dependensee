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
            <h2 class="md-title">CVE-{{cve.cve_id}}</h2>
          </div>
        </md-toolbar>
      </md-whiteframe>
  
      <main class="main-content" style="text-align: left;">
        <h1>{{error}}</h1>
        <div style="padding: 20px" v-if="cve.language === 'Ruby' || cve.language === 'Java' || cve.language === 'Python'">
          <div v-if="cve.language === 'Ruby'">
            <i class="icon-ruby" style="font-size: 1.75em" ></i>
            </br>
            <span style="font-weight: bold;">Name: </span><span>CVE-{{cve.id}}</span>
            </br>
            <span style="font-weight: bold;">Dependency name: </span><span>{{cve.dependency_name}}</span>
            </br>
            <span style="font-weight: bold;">Description: </span><span>{{cve.desc}}</span>
            </br>
            </br>
            <span style="font-weight: bold;">Patched versions: </span><span>{{cve.patched_versions}}</span>
            </br>
            <span style="font-weight: bold;">Unaffected versions: </span><span>{{cve.unaffected_versions}}</span>
            </br>
          </div>

          <div v-if="cve.language === 'Java' || cve.language === 'Python'">
            <i class="icon-python" style="font-size: 1.75em" v-if="cve.language === 'Python'"></i>
            <i class="icon-java" style="font-size: 1.75em" v-if="cve.language === 'Java'"></i>
            </br>
            <span style="font-weight: bold;">Name: </span><span>CVE-{{cve.cve_id}}</span>
            </br>
            <span style="font-weight: bold;">Title: </span><span>{{cve.title}}</span>
            </br>
            <span style="font-weight: bold;">Description: </span><span>{{cve.desc}}</span>
            </br>
            </br>
            <span style="font-weight: bold;">CVSS2 Score: </span><span>{{cve.cvss2}}</span>
            </br>
            </br>
            <span style="font-weight: bold;">Affected: </span></br>
            <span v-for="affected in cve.affected">{{affected}}</br></span>
            </br>
            <span style="font-weight: bold;">References: </span></br>
            <a v-for="reference in cve.references">{{reference}}</br></a>
            </br>
          </div>
            <md-button @click="mitre(cve.cve_id)" class="md-primary md-raised">Mitre</md-button>
            <md-button  @click="nvdb(cve.cve_id)" class="md-primary md-raised">NVDB</md-button>
            <md-button  @click="cvedetails(cve.cve_id)" class="md-primary md-raised">CVEDetails</md-button>
            <md-button  @click="rapid7(cve.cve_id)" class="md-primary md-raised">Rapid7</md-button>
            <md-button  @click="getExploitInfo(cve.cve_id)" style="background-color: red;" v-if="exploitFound" class="md-primary md-raised">Exploit</md-button>
    </div>
  </main>
  </div>
  <CVESearch ref='cvesearch'></CVESearch>
</div>
</template>

<script>
  import {getCve,canExploit,getExploit} from '../utils/api.js';
  import Sidebar from './Sidebar'
  import CVESearch from './CveSearch'

  export default {
    name: 'Cve',
    components:  {
      Sidebar,
      CVESearch
    },
    data() {
      return {
        cve: '',
        exploitFound: false,
        error: ''
       }
    },
    created() {
      this.get_cve();
       canExploit(this.$route.params.cve_id).then( response => {
            if(response===200){
              this.exploitFound=true;
            }else{
              this.error= 'CVE not found!'
            }
        });
    },
    watch: {
      '$route': 'fetchData'
    },
    methods: {
      get_cve() {
        getCve(this.$route.params.cve_id).then(resp => {this.cve = resp;}).catch((error) => {
          this.error= 'CVE not found!'
        });
      },
      getExploitInfo(cve_id){getExploit(this.$route.params.cve_id);},
      nvdb(cve_id){window.location.href = 'https://nvd.nist.gov/vuln/detail/'+ cve_id},
      cvedetails(cve_id){window.location.href = 'https://www.cvedetails.com/cve/CVE-'+ cve_id},
      rapid7(cve_id){window.location.href = 'https://www.rapid7.com/db/search?utf8=%E2%9C%93&q=' + cve_id + '&t=a'}
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