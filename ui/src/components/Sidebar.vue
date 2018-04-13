<template>
  <md-sidenav class="md-left md-fixed" ref="bsidebar">
    <md-toolbar class="md-account-header">
      <md-list class="md-transparent">
        <md-list-item class="md-avatar-list">
          <md-avatar class="md-large"><img src="https://placeimg.com/128/128/tech"></md-avatar>
          <span style="flex: 1"></span>
        </md-list-item>
        <md-list-item>
          <div class="md-list-text-container">
            <span>{{profile.name}}</span>
            <span>{{profile.email}}</span>
          </div>
          <md-button class="md-icon-button md-list-action" @click="handleLogout"><md-tooltip md-direction="right">Logout</md-tooltip><md-icon>exit_to_app</md-icon></md-button>
        </md-list-item>
      </md-list>
    </md-toolbar>
    <md-list>
      <md-list-item @click="$router.push('/Projects')"><md-icon>folder</md-icon> <span>Projects</span></md-list-item>
      <md-list-item @click= "show()"><md-icon>search</md-icon> <span>CVE Search</span></md-list-item>
      <md-list-item @click= "show()"><md-icon>warning</md-icon> <span>Exploit Search</span></md-list-item>
    </md-list>
    <md-list>
      <md-divider class="md-inset"></md-divider>
      <md-subheader> Other Platforms </md-subheader>
      <md-list-item @click= "$router.push('/qr/')"><md-icon>smartphone</md-icon> <span>Smartphone UI</span></md-list-item>
      <md-list-item @click= "$router.push('/desktop/')"><md-icon>laptop</md-icon> <span>Desktop UI</span></md-list-item>
      <md-list-item @click=" redirectGit()"><md-icon>code</md-icon> <span>Github</span></md-list-item>
    </md-list>
  </md-sidenav>
</template>

<script>
import {clearToken,getProfile,isValidToken} from '../utils/api.js';
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
        isValidToken(this.$router)
    },
    methods: {
      toggleSidebar() {
        this.$refs.bsidebar.toggle();
      },
      handleLogout() {
        clearToken();
        this.$router.push('/login');
      },
      redirectGit(){
        window.location.href= 'https://github.com/PercussiveElbow/Dependensee/'
      },
      show(){this.$modal.show('cve-search');}
    }
  }
</script>

<style scoped>
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