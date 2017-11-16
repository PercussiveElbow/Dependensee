<template>
  <md-sidenav class="md-left md-fixed" ref="bsidebar">
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
            <span>{{profile.name}}</span>
            <span>{{profile.email}}</span>
          </div>
  
          <md-button class="md-icon-button md-list-action" @click="handleLogout">
            <md-icon>exit_to_app</md-icon>
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

            <md-list-item @click="$refs.bsidebar.toggle()">
        <md-icon>warning</md-icon> <span>Vulnerabilities</span>
      </md-list-item>

      <md-list-item @click="$refs.bsidebar.toggle()">
        <md-icon>autorenew</md-icon> <span>Quick Scan</span>
      </md-list-item>
    </md-list>
  </md-sidenav>






</template>


<script>
import {clearToken,getProfile} from '../utils/api.js';

  export default {
    name: 'Sidebar',
         data() {
      return {
        profile: {},
        error: ''
      }
    },
    created: function() {
        getProfile().then(response =>  {this.profile = response;});
    },
    methods: {
      toggleSidebar() {
        this.$refs.bsidebar.toggle();
      },
      handleLogout() {
        clearToken();
        this.$router.push('/login');
      }
    }
  }
</script>

