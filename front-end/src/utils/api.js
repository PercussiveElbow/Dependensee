
var axios = require('axios')

const API_URL = 'http://localhost:3000/';
const LOGIN_URL = API_URL + 'login/';
const SIGNUP_URL = API_URL + 'signup/';


export{login,apiSignUp,getProjects};



function login() {
	return axios.post(LOGIN_URL).then(response => response.data);
}

function apiSignUp(params) {
	return axios.post(SIGNUP_URL,params).then(response => response.data);
}


function getProjects(params) {
	return axios.post(SIGNUP_URL,params).then(response => response.data);
}
