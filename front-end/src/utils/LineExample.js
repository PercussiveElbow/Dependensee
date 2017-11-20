import { Bar } from 'vue-chartjs'

export default {
  extends: Bar,
  mounted () {
    // Overwriting base render method with actual data.
    this.renderChart({
      labels: ['CVE-2014-123', 'CVE-2014-1234', 'CVE-2014-12356', 'CVE-2014-456', 'CVE-2014-789'],
      datasets: [
        {
          label: 'Cvss2 Score',
          backgroundColor: '#f87979',
          data: [40, 20, 12, 39, 10]
        }
      ],
      options: {
        responsive: false,
        maintainAspectRatio: false
      }
    })
  }
}