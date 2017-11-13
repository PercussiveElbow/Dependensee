<template>

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
      <md-list-item >
               <router-link :to="{ path: '/projects/' }">Projects</router-link>
      </md-list-item>
      <md-list-item >
               <router-link :to="{ path: '/dependencies/' }">Dependencies</router-link>
      </md-list-item> 

            <md-list-item @click="$refs.sidebar.toggle()">
        <md-icon>warning</md-icon> <span>Vulnerabilities</span>
      </md-list-item>

      <md-list-item @click="$refs.sidebar.toggle()">
        <md-icon>autorenew</md-icon> <span>Quick Scan</span>
      </md-list-item>
    </md-list>
  </md-sidenav>
</template>

<script>
 export default {
    name: 'Sidebar'
    }
</script>

