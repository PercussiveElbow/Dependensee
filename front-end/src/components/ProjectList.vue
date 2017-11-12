<template>
  <md-list class="md-double-line">
    <md-list-item v-for="item in items">

     <md-avatar md-theme="orange" class="md-avatar-icon md-primary">
        <md-icon>view_list</md-icon>
      </md-avatar>

      <div class="md-list-text-container">
        <span>[{{ item.id }}] {{item.name}}</span>
        <p>{{ item.language }}</p>
      </div>

      <md-button class="md-icon-button md-list-action">
        <md-icon>info</md-icon>
      </md-button>

    </md-list-item>
  </md-list>
</template>

<script>
  import {getToken,getProjects} from '../utils/api.js';
  export default {
    name: 'ProjectList',
    data: function () {
      return {
        items: []
      }
    },
    methods: {
    poll_projects:  function () {
      var resp =getProjects({headers: {'Authorization': getToken()}}).then(response =>  {this.items = response;});
    }
  },
  created: function () {
      this.poll_projects();
      setInterval(function () {this.poll_projects();}.bind(this), 10000); 
    }
}
</script>

<style scoped>
html,
body,
.md-title {
  padding-left: 8px;
  color: #fff;
}

.md-list-action .md-icon {
  color: rgba(#000, .26);
}

.md-avatar-icon .md-icon {
  color: #fff !important;
}

.md-sidenav .md-list-text-container > :nth-child(2) {
  color: rgba(#fff, .54);
}

</style>
