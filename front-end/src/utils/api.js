
var axios = require('axios')

const API_URL = 'http://localhost:3000/';
const LOGIN_URL = API_URL + 'login/';
const SIGNUP_URL = API_URL + 'signup/';


export{apiLogin,apiSignUp,getProjects};



function apiLogin(params) {
	return axios.post(LOGIN_URL,params).then(response => response.data);
}

function apiSignUp(params) {
	return axios.post(SIGNUP_URL,params).then(response => response.data);
}


function getProjects(params) {
	return axios.post(SIGNUP_URL,params).then(response => response.data);
}
