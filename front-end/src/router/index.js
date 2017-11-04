// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue'
import Router from 'vue-router'
import Projects from '@/components/Projects'
import Login from '@/components/Login'
import SignUp from '@/components/SignUp'


Vue.use(Router);




export default new Router({
 routes: [
    {
      path: '/Login',
      name: 'Login',
      component: Login
    },
    {
      path: '/Signup',
      name: 'SignUp',
      component: SignUp
    },
    {
      path: '/Projects',
      name: 'Projects',
      component: Projects
    },
  ]
})