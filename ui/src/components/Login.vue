<template>
  <div id="app" v-bind:style="{ 'background-image': 'url(' + background + ')' }">
    <md-layout id="child" style="vertical-align: center" md-tag="form" novalidate @submit.stop.prevent="submit" md-align="center">
      <md-layout style=" vertical-align:center" md-tag="md-card-media" md-column md-flex="30" md-flex-medium="40" md-flex-small="60" md-flex-xsmall="90" class="md-primary">
        <md-card-header><div class="md-title">Login</div></md-card-header>
        <md-card-content>
          <md-input-container><md-icon>mail</md-icon><label>Email</label><md-input email v-model="creds.email" /></md-input-container>
          <md-input-container md-has-password><md-icon>lock</md-icon><label>Password</label><md-input type="password" v-model="creds.password"/></md-input-container>
        </md-card-content>
        <md-card-actions>
          <md-button class="md-raised md-primary" v-on:click="$router.push('/signup')">Signup</md-button>
          <md-button class="md-raised md-primary" v-on:click=handleLogin>Login</md-button>
        </md-card-actions>
      </md-layout>
    </md-layout>
  </div>
</template>

<script>
var  Trianglify = require('trianglify')
  import {apiLogin,saveToken,saveTokenQR} from '../utils/api.js';

  export default {
    name: 'Login',
     data() {
      return {
        creds: {
          email: '',
          password: '',
        },
        error: '',
        background: ''
      }
    }, methods:
      {
        handleLogin(creds) {
          var formCreds = new URLSearchParams();
          formCreds.append('email',this.creds.email);
          formCreds.append('password',this.creds.password);
          apiLogin(formCreds).then(resp => this.isSucessfulSignin(resp));
        },
        isSucessfulSignin(resp){
          if(resp.auth_token === null ){
            alert('Signup failed:');
          }else{
            console.log('Token saved');
            saveToken(resp);
            this.$router.push('/projects');
          }
        },
            backgroundPattern(){
          var width = window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth;
          var height = window.innerHeight || document.documentElement.clientHeight  || document.body.clientHeight;
          var pattern = Trianglify({height: height,width: width,cell_size: 200});
          return pattern.png();
    }
      },
      created() {
          var key = this.$route.query.key
          if(key == undefined) {
          }else{
            saveTokenQR(key)
            this.$router.push('/projects');
          }
          this.background = this.backgroundPattern()
      }
}
</script>

<style scoped>
#app {position: relative;}

#child {
    position: absolute;
    top: 0;
    bottom: 0;
    left: 0;
    right: 0;
    height: 30%;
    margin: auto;
}
</style>