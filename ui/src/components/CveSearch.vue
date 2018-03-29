<template>
   <modal name="cve-search" :adaptive="true" >
        <div style="padding: 30px; text-align: center">
          <h2>Search</h2>
          <md-input-container><md-icon>search</md-icon><label>CVE-20XX-XXXX</label><md-input name v-model="cvesearch.name"/></md-input-container>
          <md-button class="md-primary md-raised" v-on:click=search()>Search CVE</md-button>
          <md-button class="md-primary md-raised" v-on:click=searchExploit()>Search Exploit</md-button>
          </br>
        </div>
    </modal>
</template>

<script>
  export default {
    name: 'ExploitSearch',
    data() {
      return {
        cvesearch: {
            name: ''
        }
      }
    },
    methods: {
      showsearch(){this.$modal.show('cve-search');},
      search(){
        this.$router.push('/cve/' + this.cvesearch.name);
      },
      searchExploit(){
        this.$router.push('/exploit/' + this.cvesearch.name);
      }
  	}
  }
</script>

<style>
</style>