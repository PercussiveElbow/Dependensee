<template>
  <div id app>
    <div class="app-viewport" id="file-list">
  <md-sidenav class="md-left md-fixed" ref="sidebar">
    <md-toolbar class="md-account-header">
      <md-list class="md-transparent">
        <md-list-item class="md-avatar-list">
          <md-avatar class="md-large">
            <img src="https://placeimg.com/128/128/tech" alt="People">
          </md-avatar>
  
          <span style="flex: 1"></span>
  
        </md-list-item>
  
        <md-list-item>
          <div class="md-list-text-container">
            <span>John Doe</span>
            <span>test@example.com</span>
          </div>
  
          <md-button class="md-icon-button md-list-action">
            <md-icon>arrow_drop_down</md-icon>
          </md-button>
        </md-list-item>
      </md-list>
    </md-toolbar>
  
    <md-list>
      <md-list-item @click="$refs.sidebar.toggle()" class="md-primary">
        <md-icon>folder</md-icon> <span>Projects</span>
      </md-list-item>
  
      <md-list-item @click="$refs.sidebar.toggle()">
        <md-icon>dehaze</md-icon> <span>Dependencies</span>
      </md-list-item>

            <md-list-item @click="$refs.sidebar.toggle()">
        <md-icon>warning</md-icon> <span>Vulnerabilities</span>
      </md-list-item>

      <md-list-item @click="$refs.sidebar.toggle()">
        <md-icon>autorenew</md-icon> <span>Quick Scan</span>
      </md-list-item>
    </md-list>
  </md-sidenav>
  
  <md-whiteframe md-elevation="3" class="main-toolbar">
    <md-toolbar class="md-large">
      <div class="md-toolbar-container">
        <md-button class="md-icon-button" @click="$refs.sidebar.toggle()">
          <md-icon>menu</md-icon>
        </md-button>
  
        <span style="flex: 1"></span>
  
        <md-button class="md-icon-button">
          <md-icon>search</md-icon>
        </md-button>
  
        <md-button class="md-icon-button">
          <md-icon>view_module</md-icon>
        </md-button>
      </div>
  
      <div class="md-toolbar-container">
        <h2 class="md-title">Projects</h2>
  
        <md-button class="md-fab md-mini">
          <md-icon>add</md-icon>
        </md-button>
      </div>
    </md-toolbar>
  </md-whiteframe>
  
  <main class="main-content">




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
  </main>
</div>
  </div>
</template>

<script>
  export default {
    name: 'Projects',
  data: function () {
    return {
      items: []
    }
  },
    methods: {

    poll_projects:  function () {
      var auth_key = 'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE1MDg5NzIzNjl9.aDBgFJW640H2fK90IIEOrpacqVhUrQVw_ndV-s2qZak'

      this.$http.get('http://localhost:3000/projects/', { headers: {'Authorization': auth_key}}).then(response => {
        this.items = response.body
      }, response => {
    });
   }

  },
  created: function () {
      console.log('test');
      this.poll_projects();

      setInterval(function () {this.poll_projects();}.bind(this), 5000); 
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
