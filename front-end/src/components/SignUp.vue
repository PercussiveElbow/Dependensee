<template>
  <div id app>
  <h1> Sign Up</h1>
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

	  <md-button class="md-raised md-primary" v-on:click=handleSignUp>Sign up</md-button>
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
