<template>
  <div id="app">
    <div :style="{ 'background-image': 'url(' + backgroundPattern() + ')' }">
    <router-link :to="{ name: 'Login' }">Login</router-link>
    <router-link to="/SignUp">SignUp</router-link>
        <router-link to="/Projects">projects</router-link>

    <router-view></router-view>
</div>
</div>
</template>

<script>

var  Trianglify = require('trianglify')

export default {
  name: '#app',
  methods: {
    backgroundPattern(){
      var width = window.innerWidth
      || document.documentElement.clientWidth
      || document.body.clientWidth;

      var height = window.innerHeight
      || document.documentElement.clientHeight
      || document.body.clientHeight;

      var pattern = Trianglify({
        height: height,
        width: width,
        cell_size: 40});
    return pattern.png();
    }
  }
}
</script>

<style>
#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 0px;
  height: 100vh;
}
</style>
