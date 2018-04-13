<template>
	<div id='graphthing' responsive: true >
       <h1>Vulnerable vs Safe Dependencies</h1> <pie-chart :height="200" :chart-data="pieData"></pie-chart></br>
       <h1>Vulnerability Severity</h1> <bar-chart :height="200" :chart-data="graphData" :options="graphOptions"></bar-chart>
    </div>
</template>

<script>
  import {getCve} from '../../utils/api.js';
  import PieChart from '../../utils/PieChart.js'
  import BarChart from '../../utils/BarChart.js'

  export default {
    name: 'ScanGraphs',
    components:  {
      BarChart,
      PieChart
    },
	mounted() {
	  const vm = this
	},
	data() {
		return {
			graphData: {
	          labels: [],data: []
	        },
	        pieData: {
	          labels: [],data: []
	        },
	        dependencies: [],
	        vulns: [],
          graphOptions: {}
		}
	},
    methods: {
      fillData (dependencies,vulns) {
      	this.dependencies=dependencies;
      	this.vulns=vulns;
        this.graphData = {
          labels: [],
          datasets: [{label: 'Severity (CVSS2)', backgroundColor: '#0074D9', data: []}]
        }
        this.pieData = {
          labels: ['Safe','Vuln'],
          datasets: [{
              label: ['Safe','Vuln'],backgroundColor: ['#2ECC40','red'],
              data: [this.dependencies.length-Object.getOwnPropertyNames(this.vulns).length+1,Object.getOwnPropertyNames(this.vulns).length-1]
            }]
        }

        this.graphOptions = {scales: {
            yAxes: [{ticks: {beginAtZero:true}}],
            xAxes: [{ticks: {beginAtZero:true}}]
          }}
        var scores = []; var labels = [];
        var keys = Object.keys(this.vulns);
        for(var i=0;i<keys.length;i++){
            for(var j=0; j<this.vulns[keys[i]].cves.length; j++){
              if(this.vulns[keys[i]].cves[j].cve !== undefined){this.processGraph(this.vulns[keys[i]].cves[j].cve,labels,scores,this.vulns[keys[i]].cves[j])}
        }}
      },
      processGraph(cve_id,labels,scores,aCve){
        getCve(cve_id).then(response =>  {
          if(response['cvss2'] !== undefined){
            labels.push(aCve.cve);
            scores.push(parseFloat(response['cvss2']))
            this.graphData = {
              labels: labels,
              datasets: [{label: 'Severity (CVSS2)',backgroundColor: '#0074D9', data: scores}]
            }}
        });
      }

    }
}
</script>