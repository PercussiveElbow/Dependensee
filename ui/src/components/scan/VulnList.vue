<template>
	<main class="main-content">
	    <div>
	      <md-list class="md-double-line">
	      	<div v-for="(vuln,title) in vulns" v-bind:key="title">
	          <md-card md-with-hover style="text-align: left; background-color: white" >
	          	<md-card-content>
	          	 	<md-card-header>
			          <div class="md-title" style="font-size: large; font-weight: bold;">{{title}}</div>
			          <md-chip style="background-color:red; color: white">Current {{vuln.cves[0].our_version}}</md-chip>
			          <md-chip style="background-color:#2ECC40; color: white">Safe {{vuln.overall_patch}}</md-chip>
<!-- 			          <md-chip class="md-primary" style="color: white">Latest {{vuln.overall_patch}}</md-chip>
 -->	      			</md-card-header>
		          <md-list-item v-for="(item,index) in vuln.cves" v-bind:key="item.cve">
		            <md-avatar class="md-avatar-icon md-primary" style="background-color:red" ><md-icon >warning</md-icon></md-avatar>
		            <div class="md-list-text-container">
		              <a style="color: red" @click=openCVEModal(vuln,index,title)>CVE-{{item.cve}}</a>
		              <ul >Patched versions: <li style="display:inline;" v-for="patched_ver in item.patched_version">{{patched_ver}},  </li></ul>
		            </div>
		          </md-list-item>
	      		</md-card-content>
	           </md-card>
	    	   </br>
	    	</div>
	      </md-list>
	    </div>
    </main>  
</template>

<script>
	  import {getCve,dependencyLatest} from '../../utils/api.js';

	export default {
	    name: 'VulnList',
	    props: ['vulns','project','dependencies'],
		data() {
			return {
				cve: {},
				selectedVuln: {},
				latestVer: '',
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
		          self.latestVer = 'Fetching..'
		          if(value.name===name){
		              dependencyLatest(self.$route.params.project_id,self.$route.params.scan_id,value.id).then(response =>  {
		              self.latestVer = response.version;
				        self.selectedVuln.our_version = vuln.cves[index].our_version;
				        self.selectedVuln.patched_version = vuln.cves[index].patched_version;
				        self.$modal.show('cvemodal', {cve: self.cve,project: self.project, latestVer: self.latestVer, activeColor: self.activeColor, selectedVuln: self.selectedVuln});
		              });
		           } 
		        });

	        })
     	 }
		}
	}
</script>