<template>
	<main class="main-content">
	    <div>
	      <md-list class="md-double-line">
	          <div style="text-align: left" v-for="(vuln,title) in vulns">
	          <span style="font-size: large; font-weight: bold;">{{title}}</span></br>
	          <span style="color: red">Current version:  {{vuln.cves[0].our_version}}</span></br>
	          <span style="color: green">Safe version: {{vuln.overall_patch}}</span>
	          <md-list-item v-for="(thing,index) in vuln.cves">
	            <md-avatar class="md-avatar-icon md-primary" md-theme="red" v-if="project.language === 'Ruby'" ><md-icon >warning</md-icon></md-avatar>
	            <md-avatar class="md-avatar-icon md-primary" md-theme="orange" v-if="project.language === 'Java'"><md-icon >warning</md-icon></md-avatar>
	            <md-avatar class="md-avatar-icon md-primary" md-theme="green" v-if="project.language === 'Python'"><md-icon >warning</md-icon></md-avatar>
	            <div class="md-list-text-container">
	              <a @click=openCVEModal(vuln,index,title)>CVE-{{thing.cve}}</a>
	              <p>Patched ver: {{thing.patched_version}}</p>
	            </div>
	          </md-list-item>
	        </div>
	      </md-list>
	    </div>
    </main>  
</template>

<script>
	  import {getCve,dependencyLatest} from '../../utils/api.js';

	export default {
	    name: 'VulnList',
	    components:  {
	    },
	    props: ['vulns','project','dependencies'],
		mounted() {
		  const vm = this
		},
		data() {
			return {
				cve: {},
				selectedvuln: {},
				latestver: '',
				activeColor: ''
			}
		},
		methods: {
			openCVEModal(vuln,index,name){
		        getCve(vuln.cves[index].cve).then(response => {
		          this.cve = response
		          if (parseFloat(this.cve.cvss2) > 8) {this.activeColor = 'firebrick';
		          }else if (parseFloat(this.cve.cvss2) > 4) {this.activeColor = 'orange';
		          }else{
		            this.activeColor = 'black';
		            if(this.cve.cvss2 == null){this.cve.cvss2 = 'Unknown'}
		            	console.log(this.cve)
		          }
		        var self = this;
		        this.dependencies.forEach(function (value, i) {
		          self.latestver = 'Fetching..'
		          if(value.name===name){
		              dependencyLatest(self.$route.params.project_id,self.$route.params.scan_id,value.id).then(response =>  {
		              self.latestver = response.version;
				        self.selectedvuln.our_version = vuln.cves[index].our_version;
				        self.selectedvuln.patched_version = vuln.cves[index].patched_version;
				        self.$modal.show('cvemodal', {cve: self.cve,project: self.project, latestver: self.latestver, activeColor: self.activeColor, selectedvuln: self.selectedvuln});
		              });
		           } 
		        });

	        })
     	 }
		}
	}

</script>


<style>

</style>