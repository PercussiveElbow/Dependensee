import Vue from 'vue'
import {apiLogin,apiSignUp,saveToken,clearToken,getToken,isValidToken,getProfile,
  getProject,getProjects,postProject,editProject,deleteProject,
  getScans,getScan,deleteScan,editScan,
  upload,
  getDependencies,dependencyLatest,requestUpdate,
  getJsonReport,getPdfReport,getTxtReport,
  getExploit,getExploitPlain,canExploit,
  getCve,
  getQr,saveTokenQR,
  getClientDownload,getClientLinux} from '../../../src/utils/api.js'
import 'url-search-params-polyfill';
var FormData = require('form-data');
var chai = require('chai');
var expect = chai.expect;
var should = chai.should();
var fs = require('fs');

describe('API Tests', function() {
  	var projectId = ''
    var scanId = ''
    var dependencyId = ''
    var email = ''
    var password = ''

    it('should sign up correctly and save token successfully', function(done) {
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
          email = creds.email;
          password = creds.password;
          apiSignUp(formCreds).then(resp => (expect(resp).to.have.property("auth_token") ,saveToken(resp), console.log(getToken()), done() ));
   		  this.timeout(10000);

    }, 10000);

    it('should login successfully',function() {
      var formCreds = new URLSearchParams();
          formCreds.append('email',email);
          formCreds.append('password',password);
        apiLogin(formCreds).then(resp=>(expect(resp).to.have.property("auth_token")));
    });

    it('should get profile successfully', function(){
    	getProfile().then(resp => (expect(resp).to.have.property("name"),expect(resp).to.have.property("email") ) );
    });

    it('should get cve successfully', function(){
    	getCve('2017-14063').then(resp => (expect(resp).to.have.property("desc"), expect(resp).to.have.property("cvss2")));
    });

    it('should create a project and delete a project successfully', function(done) {
          var formCreds = {}
          formCreds.name = 'testname'
          formCreds.description = 'testdesc'
          formCreds.language = 'Java'
          postProject(formCreds).then(resp => (expect(resp).to.have.property("id"), deleteProject(resp['id']),done() ));
       		this.timeout(10000);
    },10000);

    it('should recreate a project successfully', function(done) {
          var formCreds = {}
          formCreds.name = 'testname'
          formCreds.description = 'testdesc'
          formCreds.language = 'Java'
          postProject(formCreds).then(resp => (expect(resp).to.have.property("id"), projectId = resp['id'], done() ));
       		this.timeout(10000);
    },10000);


    it('should get projects successfully', function() {
          getProjects().then(resp => (expect(resp.length).to.equal(1)));
    });

    it('should get a project successfully', function() {
          getProject(projectId).then(resp => (expect(resp).to.have.property("id")));
    });

    it('should edit a project successfully', function() {
    	  var formCreds = {}
          formCreds.name =  'newname';
          formCreds.description = 'newdesc';
          editProject(projectId,formCreds).then( resp => { getProject(projectId).then(resp => (expect(resp.name).to.have.equal("newname")));});
    });

    it('should upload a test file for a new scan successfully', function(done) {
	  var contents = fs.readFileSync('test/unit/specs/pom.xml.test', 'utf8');
      upload(projectId,contents,"Web [TestRun] ").then(resp => { expect(resp).to.have.property("scan_id"), expect(resp).to.have.property("dependencies"),expect(resp).to.have.property("type"), scanId = resp['scan_id'],done()    });
      this.timeout(10000);
    },10000);

    it('should appear as a scan under projects successfully', function() {
    	getScans(projectId).then(resp => {expect(resp.length).to.equal(1)});
    });

    it('should get the individual scan successfully', function() {
    	getScan(projectId,scanId).then(resp => {expect(resp).to.have.property("id")});
    });

    it('should get dependencies successfully', function() {
    	getDependencies(projectId,scanId).then(resp => { 
        expect(resp.length).to.equal(6);
        dependencyId = resp[0]['id'];
      });
    });

    it('should get latest version of dependency sucessfully',function() {
      dependencyLatest(projectId,scanId,dependencyId).then(resp=> {expect(resp).to.have.property('version')})
    });

    it('should get vulnerabilities successfully', function() {
    	getJsonReport(projectId,scanId).then(resp => { expect(resp).to.have.property("org.asynchttpclient.async-http-client") });
    });

    it('should delete scan successfully', function() {
    	deleteScan(projectId,scanId).then(resp => { getScans(projectId).then(response => { expect(response.length).to.equal(0) } )});
    });

    it('should clear token', function(){
      clearToken()
    });

    it('should get token', function(){
      expect(getToken()).to.equal(null);
    });

    it('should set and get token', function(){
      var token = "newtoken";
      var tokenHash = {};
      tokenHash['auth_token'] = token;
      saveToken(tokenHash);
      expect(getToken()).to.eql(token);
    });

    it('should check if can exploit', function(){
      canExploit('2017-14063').then(resp=> {resp.to.equal(404);});
    });

    // it('should check if can exploit true', function(){
    //   canExploit('').to.equal(200);
    // });

  });
