var axios = require('axios')

const API_URL = 'http://localhost:3000/';
const LOGIN_URL = API_URL + 'login/';
const SIGNUP_URL = API_URL + 'signup/';
const PROJECTS_URL = API_URL + 'projects/';
const ACCESS_TOKEN = 'jwk_access_token'

export{apiLogin,apiSignUp,getProjects,saveToken,clearToken,getToken,putProjects};

function apiLogin(params) {
	return axios.post(LOGIN_URL,params).then(response => response.data);
}

function apiSignUp(params) {
	return axios.post(SIGNUP_URL,params).then(response => response.data);
}

function getProjects(params) {
	return axios.get(PROJECTS_URL,params).then(response => response.data);
}

function putProjects(params) {
	return axios.put(PROJECTS_URL,params).then(response => response.data);
}

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