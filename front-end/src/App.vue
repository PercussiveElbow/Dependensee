<template>

  <div id="app">
    <head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
</head>
    <div>
      <router-view></router-view>
    </div>
  </div>
</template>

<script>
var  Trianglify = require('trianglify')
import {isValidToken} from './utils/api.js';

export default {
  name: '#app',
  created() {
      console.log(isValidToken());
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
