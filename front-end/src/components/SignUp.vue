<template>
  <div id app>
    <md-layout md-tag="form" novalidate @submit.stop.prevent="submit" md-align="center">
    <md-layout md-tag="md-card" md-column md-flex="30" md-flex-medium="40" md-flex-small="60" md-flex-xsmall="90" class="md-primary">
      <md-card-header>
        <div class="md-title">Signup</div>
      </md-card-header>

      <md-card-content>
    <md-input-container>
      <label>Name</label>
      <md-input v-model="creds.name" placeholder="John Doe"></md-input>   
    </md-input-container>
    
    <md-input-container>
      <label>Email</label>
      <md-input v-model="creds.email" placeholder="jdoe@example.com"></md-input>
    </md-input-container>

    <md-input-container>
      <label>Password</label>
      <md-input v-model="creds.password" type="password"></md-input>
    </md-input-container>
    </md-card-content>

    <md-card-actions>
	     <md-button class="md-raised md-primary" v-on:click=handleSignUp>Sign up</md-button>
    </md-card-actions>
    </md-layout>
  </md-layout>
  </div>
</template>

<script>
  import {apiSignUp} from '../utils/api.js';
  export default {
    name: 'SignUp',
    data() {
      return {
        creds: {
          email: '',
          name: '',
          password: ''
        },
        error: ''
      }
    }, methods:
      {
        handleSignUp(creds) {
          var formCreds = new URLSearchParams();
          formCreds.append('name', this.creds.name);
          formCreds.append('email',this.creds.email);
          formCreds.append('password',this.creds.password);
          formCreds.append('password_confirmation',this.creds.password);
          apiSignUp(formCreds);
        }
      }
  }
</script>

<style> scoped>
h1, h2 {
  font-weight: normal;
}

ul {
  list-style-type: none;
  padding: 0;
}

li {
  display: inline-block;
  margin: 0 10px;
}

a {
  color: #42b983;
}
</style>
