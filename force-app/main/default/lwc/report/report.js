// investmentChart.js
import { LightningElement, wire } from 'lwc';
import { loadScript } from 'lightning/platformResourceLoader';
import bb from '@salesforce/resourceUrl/BillboardJS'; // Import Billboard.js
import BILLBOARD_JS from '@salesforce/resourceUrl/BillboardJS'; // Replace with your Static Resource name
import getInvestmentData from '@salesforce/apex/InvestmentChartController.getInvestmentData'; // Define the Apex method to fetch data

export default class InvestmentChart extends LightningElement {
    chart;
    isBillboardJsLoaded = false;
    data = [];

    @wire(getInvestmentData) // Wire to an Apex method to fetch "Your Investment" data
    wiredInvestmentData({ error, data }) {
        if (data) {
            this.data = data;
            this.createChart();
        } else if (error) {
            console.error('Error fetching investment data:', error);
        }
    }

    renderedCallback() {
        if (!this.isBillboardJsLoaded) {
            this.isBillboardJsLoaded = true;
            loadScript(this, BILLBOARD_JS)
                .then(() => {
                    this.createChart();
                })
                .catch(error => {
                    console.error('Error loading Billboard.js:', error);
                });
        }
    }

    createChart() {
        if (this.data.length === 0) {
            return;
        }

        const chartData = {
            columns: [['Quantity'].concat(this.data.map(item => item.Quantity__c))],
            type: 'bar', // You can change the chart type as needed
        };

        const chartOptions = {
            data: chartData,
            axis: {
                x: {
                    type: 'category',
                    categories: this.data.map(item => item.Name__c),
                },
            },
        };

        if (!this.chart) {
            this.chart = bb.generate({
                bindto: this.template.querySelector('.investment-chart'),
                data: chartData,
                ...chartOptions,
            });
        } else {
            this.chart.load(chartData);
            this.chart.axis.x.categories(this.data.map(item => item.Name__c));
        }
    }
}