<template>


  <div>
  <md-list class="md-double-line">
    <md-list-item v-for="item in items">

      <md-avatar md-theme="red" v-if="item.language === 'Ruby'" class="md-avatar-icon md-primary">
        <md-icon >code</md-icon>
      </md-avatar>
      <md-avatar md-theme="orange" v-if="item.language === 'Java'" class="md-avatar-icon md-primary">
        <md-icon >code</md-icon>
      </md-avatar>
      <md-avatar md-theme="green" v-if="item.language === 'Python'" class="md-avatar-icon md-primary">
        <md-icon >code</md-icon>
      </md-avatar>

      <div class="md-list-text-container">
        <span>{{item.name}}</span>
        <p>{{ item.language }}</p>
        <p>{{ item.description }}</p>
      </div>

      <md-button class="md-icon-button md-list-action"  @click=delete_project(item.id)>
        <md-icon>delete</md-icon>
      </md-button>
      <md-button class="md-icon-button md-list-action"  @click=editshow(item.id)>
        <md-icon>edit</md-icon>
      </md-button>


    </md-list-item>
  </md-list>
  <div>
    <modal name="edit-project"         :height="350" :adaptive="true" @opened="opened" >
      <div style="padding: 30px; text-align: center">
                <h2 >Edit a Project</h2>
            <md-input-container>
              <md-icon>work</md-icon>
              <label>Edit Project</label>
              <md-input name v-model="editproject.name"/>
            </md-input-container>
            <md-input-container>
              <md-icon>description</md-icon>
              <label>Description</label>
              <md-input name v-model="editproject.description"/>
            </md-input-container>
            </br>
      <md-button class="md-primary md-raised" v-on:click=edit_project>Edit</md-button>
        </div>
    </modal>
  </div>
</div>
</template>

<script>
  import {getToken,getProjects,putProjects} from '../utils/api.js';
  export default {
    name: 'ProjectList',
    data: function () {
      return {
        items: [],
         editproject: {
          name: '',
          description: '',
        },
        edit_id: ''
      }
    },
    methods: {
      poll_projects:  function () {
        var resp =getProjects({headers: {'Authorization': getToken()}}).then(response =>  {this.items = response;});
      },
      editshow (id) {
        this.edit_id = id;
        console.log(this.edit_id);
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
          this.$http.put('http://localhost:3000/projects/'+this.edit_id, formCreds, {headers: {'Authorization': getToken()}}, (data) => {});
          this.hide();
          this.poll_projects();
      },
      delete_project(id) {
        this.$http.delete('http://localhost:3000/projects/'+id, {headers: {'Authorization': getToken()}}, (data) => {});
        this.poll_projects;
      },
      beforeOpen (event) {
        console.log(event.params.title);
      }
    },
    created: function () {
        this.poll_projects();
        setInterval(function () {this.poll_projects();}.bind(this), 10000); 
    }
}
</script>

<style scoped>
html,
body,
.md-title {
  padding-left: 8px;
  color: #fff;
}

.md-list-action .md-icon {
  color: rgba(#000, .26);
}

.md-avatar-icon .md-icon {
  color: #fff !important;
}

.md-sidenav .md-list-text-container > :nth-child(2) {
  color: rgba(#fff, .54);
}

</style>
