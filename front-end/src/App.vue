<template>
  <div id="app">
<!--     <img src="./assets/logo.png">
 -->    <Projects/>
  </div>
</template>

<script>
import SignUp from './components/SignUp.vue'
import Projects from './components/Projects.vue'

export default {
  name: 'app',
  components: {
    Projects
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
}

</style>
