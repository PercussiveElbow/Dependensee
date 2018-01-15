import Vue from 'vue'
import {apiSignUp,saveToken,postProject,getToken} from '../../../src/utils/api.js'
import 'url-search-params-polyfill';
var FormData = require('form-data');
var chai = require('chai');
var expect = chai.expect;
var should = chai.should();


describe('API Tests', function() {
  describe('#test thing()', function() {
    it('should sign up correctly and save token', function(done) {
      	var creds = { name: '', email: '', password: ''};
  		var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
		for (var i = 0; i < 8; i++)
		  creds.name += possible.charAt(Math.floor(Math.random() * possible.length));

		for (var i = 0; i < 8; i++)
		  creds.password += possible.charAt(Math.floor(Math.random() * possible.length));




		  creds.email = creds.name + "@test.com"

          var formCreds = new URLSearchParams();
          formCreds.append('name', creds.name);
          formCreds.append('email',creds.email);
          formCreds.append('password',creds.password);
          formCreds.append('password_confirmation',creds.password);
          var respThing = '';
          console.log("Name: " + creds.name, + " Email: " +creds.email + " Password: " + creds.password);
          apiSignUp(formCreds).then(resp => (expect(resp).to.have.property("auth_token") ,saveToken(resp), console.log(getToken()), done() ));
   			    	this.timeout(10000);

    }, 10000);


    it('should create a project', function() {
 		  var formCreds = new FormData();
          formCreds.append('name', 'testname');
          formCreds.append('description', 'testdesc');
          formCreds.append('language','Java');

          var formCreds = {}
          formCreds.name = 'testname'
          formCreds.description = 'testdesc'
          formCreds.language = 'Java'
          postProject(formCreds).then(resp => (console.log(resp)));
    });







  });



});