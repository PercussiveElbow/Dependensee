<template>
  <div id app>
  
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
  </div>
</template>

<script>
  export default {
    name: 'ProjectList',
  data: function () {
    return {
      items: []
    }
  },
    methods: {

    poll_projects:  function () {
    //   var auth_key = 'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE1MDkxMDM0MzB9.CRY2IkFszfwPT6PAhOT5ixVengGTDma0-d_QQZvzSts'

    //   this.$http.get('http://localhost:3000/projects/', { headers: {'Authorization': auth_key}}).then(response => {
    //     this.items = response.body
    //   }, response => {
    // });

    
   },

   create_project: function() {
      var auth_key = 'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE1MDkxMDM0MzB9.CRY2IkFszfwPT6PAhOT5ixVengGTDma0-d_QQZvzSts'

          var formCreds = new FormData();
          formCreds.append('name', 'NewProject');
          formCreds.append('language','Ruby');

          this.$http.post('http://localhost:3000/projects/', formCreds, {headers: {'Authorization': auth_key}}, (data) => {
        });
          this.poll_projects();
   }

  },
  created: function () {
      this.poll_projects();
      setInterval(function () {this.poll_projects();}.bind(this), 600000); 
    }
}
</script>


<style> scoped>
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

.md-list-action .md-icon {
  color: rgba(#000, .26);
}

.md-avatar-icon .md-icon {
  color: #fff !important;
}

.md-sidenav .md-list-text-container > :nth-child(2) {
  color: rgba(#fff, .54);
}

.md-account-header {
  .md-list-item:hover .md-button:hover {
    background-color: inherit;
  }

  .md-avatar-list .md-list-item-container:hover {
    background: none !important;
  }
}
</style>
