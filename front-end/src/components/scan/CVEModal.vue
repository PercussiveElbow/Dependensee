<template>
	    <modal name="cvemodal" :height="550" :adaptive="true" @before-open="beforeOpen">
      <div style="padding: 11px; text-align: left">
              <h1  v-bind:style="{ color: activeColor}" style ="text-align: center" >CVE {{cve.cve_id}}</h1>
              <h2 style ="text-align: center" >{{cve.title}}</h2>
              <p>{{selectedvuln.depname}}</p>
              <span style="font-weight: bold" >CVSS2 Score: </span><span> {{cve.cvss2}}</span></br>
              <span v-if="project.language === 'Python' | project.language === 'Java'" >{{cve.desc}}</span>
              </br v-if="project.language === 'Ruby'">
              <span class="md-subheading" style="font-weight: bold" v-if="project.language === 'Ruby'" @click="$router.push({ path: '/cve/'+cve.id });">Description</span>
              </br v-if="project.language === 'Ruby'">
              <span class="md-subheading" style="font-weight: bold" >Versions</span></br>
              <span style="font-weight: bold" > Our: </span><span>{{selectedvuln.our_version}}</span></br>
              <span style="font-weight: bold">  Safe: </span>
              <span v-if="project.language === 'Python' | project.language === 'Java'" v-for="patched in selectedvuln.patched_version">{{patched}},</span>
              <span v-if="project.language === 'Ruby'" v-for="patched in cve.patched_versions">{{patched}},</span>
              <br>
              <span v-if="project.language === 'Ruby'" style="font-weight: bold">  Unaffected: </span>
              <span v-if="project.language === 'Ruby'" v-for="unaffected in cve.unaffected_versions">{{unaffected}},</span><br v-if="project.language === 'Ruby'">
              <span style="font-weight: bold"> Latest: </span><span>{{latestver}}</span>
              </br></br>
              <span v-if="project.language === 'Python' | project.language === 'Java'" class="md-subheading" style="font-weight: bold">References</span></br>
              <div v-if="project.language === 'Python' | project.language === 'Java'" v-for="reference in cve.references">
              <a v-bind:href="reference">{{reference}}</a>
              </br>
              </div>
          <div style="text-align: center">
   <md-button style="margin: 0; margin-left: 0px; font-size: 11px; min-width: 1%; margin-right: 0px" class="md-primary md-raised" @click="mitre(cve.cve_id)">Mitre</md-button>
            <md-button style="margin: 0; margin-left: 0px; font-size: 11px; min-width: 1%; margin-right: 0px" @click="nvdb(cve.cve_id)" class="md-primary md-raised">NVDB</md-button>
            <md-button style="margin: 0; margin-left: 0px; font-size: 11px; min-width: 1%; margin-right: 0px" @click="cvedetails(cve.cve_id)" class="md-primary md-raised">CVEDetails</md-button>
            <md-button style="margin: 0; margin-left: 0px; font-size: 11px; min-width: 1%; margin-right: 0px" class="md-primary md-raised" @click="rapid7(cve.cve_id)">Rapid7</md-button>
            <md-button @click="getExploitInfo(cve.cve_id)" style="background-color: red; margin: 0; margin-left: 0px; font-size: 11px; min-width: 1%; margin-right: 0px" class="md-primary md-raised">Exploit</md-button>
          </div>
      </div>
    </modal>
</template>

<script>
  import {getExploit} from '../../utils/api.js';

	export default {
	  name: 'CVEModal',
		data() {
			return {
				cve: [],
				activeColor: '',
				selectedvuln: '',
				project: '',
				latestver: ''
			}
		},
		methods: {
		  mitre(cve_id){window.location.href = 'https://cve.mitre.org/cgi-bin/cvename.cgi?name='+ cve_id},
		  nvdb(cve_id){window.location.href = 'https://nvd.nist.gov/vuln/detail/'+ cve_id},
		  cvedetails(cve_id){window.location.href = 'https://www.cvedetails.com/cve/CVE-'+ cve_id},
		  rapid7(cve_id){window.location.href = 'https://www.rapid7.com/db/search?utf8=%E2%9C%93&q=' + cve_id + '&t=a'},
		  getExploitInfo(cve_id){getExploit(cve_id);},
  		beforeOpen (event) {
    		this.cve=event.params.cve;
    		this.activeColor=event.params.activeColor;
    		this.selectedvuln=event.params.selectedvuln;
    		this.project=event.params.project;
    		this.latestver=event.params.latestver;
  		}
		}
	}
</script>

<style>
</style>