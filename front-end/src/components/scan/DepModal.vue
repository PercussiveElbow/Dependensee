<template>
	<modal name="depmodal" :responsive="260" :adaptive="true" @before-open="beforeOpen">
      <div style="padding: 15px; text-align: left">
        <i class="icon-python" style="font-size: 1.75em" v-if="project.language === 'Python'"></i>
          <i class="icon-java" style="font-size: 1.75em" v-if="project.language === 'Java'"></i>
          <i class="icon-ruby" style="font-size: 1.75em" v-if="project.language === 'Ruby'"></i>
          <h1 style ="text-align: center" >{{selecteddep.name}}</h1>
         <span style="font-weight: bold">Version: </span><span>{{selecteddep.version}}</span>
         </br>
          <span style="font-weight: bold">Latest version: </span><a>{{latestver}}</a>
         </br></br>
         <span style="font-weight: bold">Raw: </span><span> {{selecteddep.raw}}</span>
          </br>
          <div style="text-align: center">
            <md-button v-if="project.language === 'Java'" class="md-primary md-raised" @click="maven(selecteddep.name)">Maven Central</md-button>
            <md-button v-if="project.language === 'Python'" class="md-primary md-raised" @click="pypi(selecteddep.name)">Pypi</md-button>
            <md-button v-if="project.language === 'Ruby'" class="md-primary md-raised" @click="rubygems(selecteddep.name)">Ruby Gems</md-button>
          </div>
      </div>
    </modal>
</template>

<script>
	export default {
	    name: 'DepModal',
		data() {
			return {
				project: '',
				selecteddep: '',
				latestver: ''
			}
		},
		methods: {
  		  beforeOpen (event) {
    		this.selecteddep=event.params.selecteddep;
    		this.project=event.params.project;
    		this.latestver=event.params.latestver;
  		  }
		}
	}
</script>

<style>
</style>