<template>
  <div>
    <md-list class="md-double-line">
      <md-list-item v-for="item in items" v-bind:key="item.name">
        <md-avatar md-theme="red" v-if="item.language === 'Ruby'" class="md-avatar-icon md-primary"><i class="icon-ruby"></i></md-avatar>
        <md-avatar md-theme="orange" v-if="item.language === 'Java'" class="md-avatar-icon md-primary"><i class="icon-java"></i></md-avatar>
        <md-avatar md-theme="green" v-if="item.language === 'Python'" class="md-avatar-icon md-primary"><i class="icon-python"></i></md-avatar>
        <div class="md-list-text-container">
          <router-link :to="{ path: '/project/'+item.id }">{{item.name}}</router-link>
          <p>{{ item.description }}</p>
        </div>
        <md-button class="md-icon-button md-list-action" @click=delete_project(item.id)><md-tooltip md-direction="top">Delete</md-tooltip><md-icon>delete</md-icon></md-button>
        <md-button class="md-icon-button md-list-action" @click=editshow(item.id)><md-tooltip md-direction="top">Edit</md-tooltip><md-icon>edit</md-icon></md-button>
      </md-list-item>
    </md-list>
    <div>
      <modal name="edit-project" :height="350" :adaptive="true">
        <div style="padding: 30px; text-align: center">
          <h2 >Edit a Project</h2>
          <md-input-container><md-icon>work</md-icon><label>Edit Project</label><md-input maxlength="20" name v-model="editproject.name"/></md-input-container>
          <md-input-container><md-icon>description</md-icon><label>Description</label><md-input maxlength="30" name v-model="editproject.description"/></md-input-container>
          </br>
          <md-button class="md-primary md-raised" v-on:click=edit_project>Save</md-button>
        </div>
      </modal>
    </div>
  </div>
</template>

<script>
  import {getToken,getProjects,editProject,deleteProject} from '../../utils/api.js';
  export default {
    name: 'ProjectList',
    data: function () {
      return {
        items: [],
         editproject: {
          name: '',
          description: ''
        },
        edit_id: '',
        intervalKill: ''
      }
    },
    methods: {
        poll_projects() {var resp =getProjects().then(response =>  {this.items = response;});},
        editshow (id) {
          this.edit_id = id;
          this.$modal.show('edit-project');
        }, 
        hide () {
          this.edit_id='';
          this.$modal.hide('edit-project');
        },
        edit_project(){
          var formCreds = new FormData();
          formCreds.append('name', this.editproject.name);
          formCreds.append('description', this.editproject.description);
          editProject(this.edit_id,formCreds);
          this.hide();
          this.poll_projects();
        },
        delete_project(id) {
          deleteProject(id)
          this.poll_projects;
        },
        beforeOpen (event) {
          console.log(event.params.title);
        }
      },
      created: function () {
        this.poll_projects();
        this.intervalKill = setInterval(function () {this.poll_projects();}.bind(this), 2000); 
      },
      destroyed() {
        clearInterval(this.intervalKill);
    }
}
</script>

<style scoped>
i {
    display: block;
    margin-left: 23%;
    margin-top: 20%;
    font-size: 1.5em;
}
</style>
