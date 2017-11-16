<template>
<div id="app">
  <md-layout md-tag="form" novalidate @submit.stop.prevent="submit" md-align="center">
    <md-layout md-tag="md-card" md-column md-flex="30" md-flex-medium="40" md-flex-small="60" md-flex-xsmall="90" class="md-primary">
      <md-card-header>
        <div class="md-title">Login</div>
      </md-card-header>

      <md-card-content>
        <md-input-container>
          <md-icon>mail</md-icon>
          <label>Email</label>
          <md-input email v-model="creds.email" />
        </md-input-container>

        <md-input-container md-has-password>
          <md-icon>lock</md-icon>
          <label>Password</label>
          <md-input type="password" v-model="creds.password" />
        </md-input-container>
      </md-card-content>

    <md-card-actions>
      <router-link :to="{ path: '/SignUp/' }">Sign Up</router-link>
       <md-button class="md-raised md-primary" v-on:click=handleLogin>Login</md-button>
    </md-card-actions>
    </md-layout>
  </md-layout>


</div>
</template>


<script>
  import {apiLogin,saveToken} from '../utils/api.js';

  export default {
    name: 'Login',
     data() {
      return {
        creds: {
          email: '',
          password: '',
        },
        error: ''
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
                    console.log(resp);
          if(resp.auth_token === null ){
            //throw error
            console.log('Signup failed, handle validation response');
          }else{
            console.log('Token saved');
            saveToken(resp);
            this.$router.push('/projects');
          }
        }
      }
  }
</script>


