var axios = require('axios')

// const API_URL = 'http://localhost:3000/';
const API_URL = 'http://192.168.0.5:3000/';
const LOGIN_URL = API_URL + 'login/';
const SIGNUP_URL = API_URL + 'signup/';
const PROJECTS_URL = API_URL + 'projects/';
const UPLOAD_URL =  '/upload/'
const SCANS_URL = '/scans/'
const PROFILE_URL = '/profile'
const DEPENDENCIES_URL = '/dependencies/'
const ACCESS_TOKEN = 'jwk_access_token'

export{apiLogin,apiSignUp,getProjects,saveToken,clearToken,getToken,putProjects,getProject,getScans,isValidToken,getProfile,postProject,upload,getScan,getDependencies};


//AUTH
function apiLogin(params) {
	return axios.post(LOGIN_URL,params).then(response => response.data);
}

function apiSignUp(params) {
	return axios.post(SIGNUP_URL,params).then(response => response.data);
}

function isValidToken() {
	var isValid;
	getProjects( {headers: {'Authorization': getToken()} } ).then(response =>  {return 'fewf';});
}

//PROFILE
function getProfile() {
	return axios.get(API_URL + PROFILE_URL, {headers: {'Authorization': getToken()} }).then(response => response.data);
}

//PROJECTS
function getProject(id) {
	return axios.get(PROJECTS_URL+id,{headers: {'Authorization': getToken()}}).then(response => response.data);
}

function putProjects(params) {
	return axios.put(PROJECTS_URL,params).then(response => response.data);
}

function getProjects() {
	return axios.get(PROJECTS_URL,{headers: {'Authorization': getToken()}}).then(response => response.data);
}

function postProject(params){
	return axios.post(PROJECTS_URL,params, {headers: {'Authorization': getToken()}}).then(response => response.data);
}

//SCANS

function getScan(project_id,scan_id){
	return axios.get(PROJECTS_URL+project_id+SCANS_URL+scan_id, {headers: {'Authorization': getToken()}} ).then(response => response.data);
}

function getScans(id,params){
	return axios.get(PROJECTS_URL+id+SCANS_URL,params).then (response => response.data);
}

function upload(id,body){
	return axios.post(PROJECTS_URL+id+UPLOAD_URL, body, {headers: {'Authorization': getToken()}, 'Content-Type': 'text/plain'}).then(response =>response.data);
}

//DEPENDENCIES
function getDependencies(project_id,scan_id){
	return axios.get(PROJECTS_URL+project_id+SCANS_URL + scan_id + DEPENDENCIES_URL,{headers: {'Authorization': getToken()}} ).then (response => response.data);
}


//TOKEN
function saveToken(token) {
	if(token.auth_token){
		clearToken()
  		localStorage.setItem(ACCESS_TOKEN, token.auth_token);
  		console.log("Auth token set");
	}else{
		console.log("No auth token recieved");
	}
}

function clearToken() {
  localStorage.removeItem(ACCESS_TOKEN);
}

function getToken() {
  return localStorage.getItem(ACCESS_TOKEN);
}