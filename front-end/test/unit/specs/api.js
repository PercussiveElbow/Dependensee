import Vue from 'vue'
import {apiSignUp,saveToken,postProject} from '../../../src/utils/api.js'
import 'url-search-params-polyfill';
var FormData = require('form-data');

describe('API Tests', function() {
  describe('#test thing()', function() {
    it('should sign up correctly and save token', function() {
      	var creds = { name: '', email: '', password: ''};
  		var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
		for (var i = 0; i < 5; i++)
		  creds.name += possible.charAt(Math.floor(Math.random() * possible.length));

		for (var i = 0; i < 5; i++)
		  creds.password += possible.charAt(Math.floor(Math.random() * possible.length));




		  creds.email = creds.name + "@demo.com"

          var formCreds = new URLSearchParams();
          formCreds.append('name', creds.name);
          formCreds.append('email',creds.email);
          formCreds.append('password',creds.password);
          formCreds.append('password_confirmation',creds.password);
          var respThing = '';
          console.log("Name: " + creds.name, + " Email: " +creds.email + " Password: " + creds.password);
          apiSignUp(formCreds).then(resp => (console.log(resp), resp.should.include("Account created"),saveToken(resp.auth_token) ));



    });


    it('should create a project', function() {
 		  var formCreds = new FormData();
          formCreds.append('name', 'testname');
          formCreds.append('description', 'testdesc');
          formCreds.append('language','Java');
          postProject(formCreds).then(resp => (console.log(resp)));
    });







  });



});