import Vue from 'vue'
import Router from 'vue-router'
import Projects from '@/components/Projects'
import Project from '@/components/Project'
import Scan from '@/components/Scan'
import Login from '@/components/Login'
import SignUp from '@/components/SignUp'
import Cve from '@/components/Cve'
import Qr from '@/components/Qr'

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
    {
     path: '/project/:id',
     name: 'Project',
     component: Project
    },
    {
     path: '/scan/:project_id/:scan_id',
     name: 'Scan',
     component: Scan
    },
    {
     path: '/cve/:cve_id/',
     name: 'Cve',
     component: Cve
    },
    {
    path: '/qr',
     name: 'qr',
     component: Qr
    }
  ]
})