import { LightningElement, wire } from 'lwc';
import getInvestmentData from '@salesforce/apex/InvestmentChartController.fetchInvestments';

export default class InvestmentChart extends LightningElement {
    chartData = [];
    chartOptions = {
        chart: {
            type: 'bar',
        },
        xaxis: {
            categories: [],
        },
        plotOptions: {
            bar: {
                horizontal: false,
            },
        },
        dataLabels: {
            enabled: false,
        },
        title: {
            text: 'Investment Data',
        },
    };

    @wire(getInvestmentData)
    wiredInvestmentData({ error, data }) {
        if (data) {
            this.chartData = data.map(item => item.Amount_Invested__c);
            this.chartOptions.xaxis.categories = data.map(item => item.Name);
        } else if (error) {
            console.error(error);
        }
    }
}