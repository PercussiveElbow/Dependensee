import Vue from 'vue'
import {apiSignUp,saveToken,postProject,getToken,getProject,getProfile,getCve,deleteProject,upload,getScans} from '../../../src/utils/api.js'
import 'url-search-params-polyfill';
var FormData = require('form-data');
var chai = require('chai');
var expect = chai.expect;
var should = chai.should();
var FileReader = require('filereader')
var fs = require('fs');


describe('API Tests', function() {
  describe('#test thing()', function() {
  	var projectId = ''
    var scanId = ''

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

    it('should get profile sucessfully', function(){
    	getProfile().then(resp => (expect(resp).to.have.property("name"),expect(resp).to.have.property("email") ) );
    });

    it('should get cve sucessfully', function(){
    	getCve('2017-14063').then(resp => (expect(resp).to.have.property("desc"), expect(resp).to.have.property("cvss2")));
    });

    it('should create a project and delete a project', function(done) {
          var formCreds = {}
          formCreds.name = 'testname'
          formCreds.description = 'testdesc'
          formCreds.language = 'Java'
          postProject(formCreds).then(resp => (expect(resp).to.have.property("id"), deleteProject(resp['id']),done() ));
       		this.timeout(10000);
    },10000);

    it('should recreate a project', function(done) {
          var formCreds = {}
          formCreds.name = 'testname'
          formCreds.description = 'testdesc'
          formCreds.language = 'Java'
          postProject(formCreds).then(resp => (expect(resp).to.have.property("id"), projectId = resp['id'], done() ));
       		this.timeout(10000);
    },10000);

    it('should get a project', function() {
          getProject().then(resp => (expect(resp).to.have.property("id")));
    });

    it('should upload a test file for a new scan', function(done) {
	  var contents = fs.readFileSync('test/unit/specs/pom.xml.test', 'utf8');
      upload(projectId,contents,"Web [TestRun] ").then(resp => { expect(resp).to.have.property("scan_id"), expect(resp).to.have.property("dependencies"),expect(resp).to.have.property("type"), scanId = resp['scanId'],done()    });
      this.timeout(10000);
    },10000);

    it('should appear as a scan under projects', function() {
    	getScans(projectId).then(resp => {expect(resp.length).to.equal(1)});
    });


  });



});