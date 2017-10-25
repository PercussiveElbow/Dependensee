<template>
  <div id app>
  <h1> Sign Up</h1>
  <input v-model="creds.name" placeholder="Name">
    <br/>
  <input v-model="creds.email" placeholder="Email">
    <br/>
    <input v-model="creds.password" placeholder="Password">
    <br/>
    <input v-model="creds.password_confirm" placeholder="Password Confirmation">
    <br/>
	<md-button class="md-raised md-primary" v-on:click=signup>Sign up</md-button>

  </div>
</template>

<script>
  const API_URL = 'http://localhost:3000/';
  const SIGNUP_URL = API_URL + 'signup/';

  export default {
    name: 'SignUp',
    data() {
      return {
        creds: {
          email: '',
          name: '',
          password: '',
          password_confirm: ''
        },
        error: ''
      }
    }, methods:
      {
        signup(creds) {
          console.log(creds);

          var formCreds = new FormData();
          formCreds.append('name', this.creds.name);
          formCreds.append('email',this.creds.email);
          formCreds.append('password',this.creds.password);
          formCreds.append('password_confirmation',this.creds.password_confirm);

          this.$http.post(SIGNUP_URL, formCreds, (data) => {
           console.log(data.auth_token);

            this.user.authenticated = true
        });
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
