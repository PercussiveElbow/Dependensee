var axios = require('axios')

//const API_URL = 'https://dependensee.tech/api/v1/'
//const WEB_URL = 'https://ui.dependensee.tech/'
var ADDRESS  = 'http://' + window.location.hostname
const API_URL = ADDRESS + ':3000/api/v1/'
const API_URL_NO_VER = ADDRESS + ':3000/'
const WEB_URL = ADDRESS + ':8080/'

const LOGIN_URL = API_URL + 'login/';
const SIGNUP_URL = API_URL + 'signup/';
const PROJECTS_URL = API_URL + 'projects/';
const CVE_URL = API_URL + 'cve/';
const EXPLOIT_URL = API_URL + 'exploit/';
const UPLOAD_URL =  '/upload/'
const SCANS_URL = '/scans/'
const PROFILE_URL = '/profile'
const UPDATE_URL = '/updates/'
const DEPENDENCIES_URL = '/dependencies/'
const JSON_REPORT_URL = '/reports/json/'
const PDF_REPORT_URL = '/reports/pdf/'
const TXT_REPORT_URL = '/reports/txt/'
const HTML_REPORT_URL = '/reports/html/'
const ACCESS_TOKEN = 'jwk_access_token'

//Split this file out for tidiness	
export{apiLogin,apiSignUp,saveToken,clearToken,getToken,isValidToken,getProfile,
	getProject,getProjects,postProject,editProject,deleteProject,
	getScans,getScan,deleteScan,editScan,
	upload,
	getDependencies,dependencyLatest,requestUpdate,
	getJsonReport,getPdfReport,getTxtReport,getHtmlReport,
	getExploit,getExploitPlain,canExploit,
	getCve,
	getQr,saveTokenQR,
	getClientDownload,getClientLinux,getClientWindows};

//AUTH
function apiLogin(params) {
	return axios.post(LOGIN_URL,params).then(response => response.data);
}

function apiSignUp(params) {
	return axios.post(SIGNUP_URL,params).then(response => response.data);
}

function isValidToken(router) {
	var thing = router;
	getProjects( {headers: {'Authorization': getToken()} }).catch(function (error) {
    if (error.response) {
    	thing.push('/login')
    }});
}

//PROFILE
function getProfile() {
	return common_get(API_URL + PROFILE_URL)
}

//PROJECTS
function getProject(id) {
	return common_get(PROJECTS_URL+id)
}

function editProject(id,params) {
	return axios.put(PROJECTS_URL+id,params, {headers: {'Authorization': getToken()}}).then(response => response.data);
}

function deleteProject(id){
	return common_delete(PROJECTS_URL+id)
}

function getProjects() {
	return common_get(PROJECTS_URL);
}

function postProject(params){
	return axios.post(PROJECTS_URL,params, {headers: {'Authorization': getToken()}}).then(response => response.data);
}

//SCANS
function getScan(project_id,scan_id){
	return common_get(PROJECTS_URL+project_id+SCANS_URL+scan_id);
}

function getScans(id){
	return common_get(PROJECTS_URL+id+SCANS_URL);
}

function editScan(id,scan_id,type){
	return axios.put(PROJECTS_URL+id+SCANS_URL+scan_id,{'needs_update': type}, {headers: {'Authorization': getToken()}} ).then(response => response.data);
}

function upload(id,body,source){
	return axios.post(PROJECTS_URL+id+UPLOAD_URL, body, {headers: {'Authorization': getToken(), 'Source': source}, 'Content-Type': 'text/plain'}).then(response =>response.data);
}

function deleteScan(id,scan_id){
	return common_delete(PROJECTS_URL+id+SCANS_URL+scan_id)
}

//UPDATE
function requestUpdate(id,scan_id,params,type){
	return axios.post(PROJECTS_URL+id+SCANS_URL+scan_id + UPDATE_URL + type, params, {headers: {'Authorization': getToken() }} ).then(response => response.data);
}

//DEPENDENCIES
function getDependencies(project_id,scan_id){
	return common_get(PROJECTS_URL+project_id+SCANS_URL + scan_id + DEPENDENCIES_URL);
}

//REPORTS
function getJsonReport(project_id,scan_id){
	return common_get(PROJECTS_URL+project_id+SCANS_URL + scan_id + JSON_REPORT_URL);
}
function getPdfReport(project_id,scan_id){
	return axios.get(PROJECTS_URL+project_id+SCANS_URL + scan_id + PDF_REPORT_URL,{headers: {'Authorization': getToken()}} ).then (
			response => { response.data
			let blob = new Blob([response.data], { type: 'application/pdf' } ),
			url = window.URL.createObjectURL(blob)
			 window.open(url);
			});
}

function getTxtReport(project_id,scan_id){
	return axios.get(PROJECTS_URL+project_id+SCANS_URL + scan_id + TXT_REPORT_URL,{headers: {'Authorization': getToken()}} ).then (
			response => { response.data
			let blob = new Blob([response.data], { type: 'application/text' } ),
			url = window.URL.createObjectURL(blob)
			 window.open(url);
	});
}

function getHtmlReport(project_id,scan_id){
	return axios.get(PROJECTS_URL+project_id+SCANS_URL + scan_id + HTML_REPORT_URL,{headers: {'Authorization': getToken()}} ).then (
			response => { response.data
			let blob = new Blob([response.data], { type: 'application/html' } ),
			url = window.URL.createObjectURL(blob)
			 window.open(url);
	});
}

//CVE
function getCve(cve_id){
	return common_get(CVE_URL+cve_id);
}

//EXPLOIT
function canExploit(cve_id){
	return axios.get(EXPLOIT_URL+cve_id, {headers: {'download': 'no'}} ).then (response => response.status);
}
function getExploit(cve_id){
	window.location.href = EXPLOIT_URL+cve_id
}

function getExploitPlain(cve_id){
	cve_id = '2016-6662'
	return axios.get(EXPLOIT_URL+cve_id).then (response => response);
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

function saveTokenQR(token){
		clearToken()
  		localStorage.setItem(ACCESS_TOKEN, token);
  		console.log("Auth token set");
}

function clearToken() {
  localStorage.removeItem(ACCESS_TOKEN);
}

function getToken() {
  return localStorage.getItem(ACCESS_TOKEN);
}

//OTHER 
function dependencyLatest(project_id,scan_id,dep_id){
  return axios.get(PROJECTS_URL+project_id+SCANS_URL + scan_id + DEPENDENCIES_URL + dep_id + '/latest',{headers: {'Authorization': getToken()}} ).then (response => response.data);
}

function getQr(){
	return WEB_URL + 'login?key=' + getToken()
}

function getClientLinux(){
	return 'wget ' + WEB_URL + 'static/quickclient.rb' + ' && ruby quickclient.rb ' + API_URL_NO_VER
}

function getClientWindows(){
	return 'ruby quickclient.rb ' + API_URL_NO_VER
}
function getClientDownload(){
	return WEB_URL + 'static/quickclient.rb '
}

function common_get(get_string){
	return axios.get(get_string,{headers: {'Authorization': getToken()}}).then(response => response.data);
}

function common_delete(delete_string){
	return axios.delete(delete_string, {headers: {'Authorization': getToken()}}).then (response => response.data);
}