<template>
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
	        <md-button v-if="project.language === 'Java'" class="md-icon-button md-list-action"  @click=maven(dep.name)><md-tooltip md-direction="left">View on Maven</md-tooltip><md-icon>search</md-icon></md-button>
	        <md-button v-if="project.language === 'Python'" class="md-icon-button md-list-action"  @click=pypi(dep.name)><md-tooltip md-direction="left">View on PyPi</md-tooltip><md-icon>search</md-icon></md-button>
	        <md-button v-if="project.language === 'Ruby'" class="md-icon-button md-list-action"  @click=rubygems(dep.name)><md-tooltip md-direction="left">View on RubyGems</md-tooltip><md-icon>search</md-icon></md-button>
	      </md-list-item>
	    </md-list>
	  </div>
	</main>
</template>

<script>
	import {dependencyLatest} from '../../utils/api.js';

  export default {
    name: 'DepList',
    props: ['dependencies','project','selecteddep','latestver'],
	mounted() {
	  const vm = this
	},
	data() {
		return {
			localDeps : this.dependencies,
			localSelectedDep: this.selecteddep,
			localLatestVer: this.latestver
		}
	},
	methods: {
      openDepModal: function(dep){
        this.localSelectedDep=dep;
        dependencyLatest(this.$route.params.project_id,this.$route.params.scan_id,this.localSelectedDep.id).then(response =>  {
          this.localLatestVer = response.version;
          this.$modal.show('depmodal',{latestver: this.localLatestVer, selecteddep: this.localSelectedDep, project: this.project});
        });
      },
      maven(dep_name){window.location.href = 'https://search.maven.org/#search%7Cga%7C1%7C'+ dep_name},
      rubygems(dep_name){window.location.href = 'https://rubygems.org/gems/'+ dep_name},
      pypi(dep_name){window.location.href = 'https://pypi.python.org/pypi/'+ dep_name}
	}
}

</script>