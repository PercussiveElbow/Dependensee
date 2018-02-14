<template>
  <div id='app' v-bind:style="{ 'background-image': 'url(' + background + ')' }" >
    <md-layout md-tag="form" novalidate @submit.stop.prevent="submit" md-align="center">
      <md-layout md-tag="md-card" md-column md-flex="30" md-flex-medium="40" md-flex-small="60" md-flex-xsmall="90" class="md-primary">
        <md-card-header><div class="md-title">Signup</div></md-card-header>
        <md-card-content>
          <md-input-container><md-icon>person</md-icon><label>Name</label><md-input maxlength="25" v-model="creds.name"></md-input></md-input-container>
          <md-input-container><md-icon>mail</md-icon><label>Email</label><md-input v-model="creds.email"></md-input></md-input-container>
          <md-input-container><md-icon>lock</md-icon><label>Password</label><md-input v-model="creds.password" type="password"></md-input></md-input-container>
        </md-card-content>
        <md-card-actions>
          <md-button class="md-raised md-primary" v-on:click="$router.push('/Login')">Login</md-button>
    	    <md-button class="md-raised md-primary" v-on:click=handleSignUp>Sign up</md-button>
        </md-card-actions>
      </md-layout>
    </md-layout>
  </div>
</template>

<script>
  import {apiSignUp,getProjects,saveToken} from '../utils/api.js';
  var  Trianglify = require('trianglify')
  export default {
    name: 'SignUp',
    data() {
      return {
        creds: {
          email: '',
          name: '',
          password: ''
        },
        error: '',
        background: ''
      }
    }, methods:
      {
        handleSignUp(creds) {
          var formCreds = new URLSearchParams();
          formCreds.append('name', this.creds.name);
          formCreds.append('email',this.creds.email);
          formCreds.append('password',this.creds.password);
          formCreds.append('password_confirmation',this.creds.password);
          apiSignUp(formCreds).then(resp => (this.isSucessfulSignup(resp)));
        },
        isSucessfulSignup(resp) {
          console.log(resp);
          if(resp.auth_token === null ){
            //throw error
            console.log('Signup failed, handle validation response');
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
          this.background = this.backgroundPattern()
      }
  }
</script>
