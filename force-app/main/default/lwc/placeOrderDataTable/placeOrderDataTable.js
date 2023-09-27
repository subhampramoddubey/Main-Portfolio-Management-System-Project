import { LightningElement, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import { FlowAttributeChangeEvent } from 'lightning/flowSupport'; // Import FlowAttributeChangeEvent
import getObjectDetails from '@salesforce/apex/InvestmentObjectController.getObjectDetails';
import { FlowNavigationNextEvent } from 'lightning/flowSupport'; // Import FlowNavigationNextEvent


export default class ObjectDetailDataTable extends NavigationMixin(LightningElement) {
    objectDetails;
    objectRecords = [];
    flowContext = {}; // Add this property to store the Flow context


    handleButtonClick() {
        // Specify the URL of your Flow
        const flowUrl = '/flow/Get_SELL_Order_Details'; // Replace with your Flow's URL

        // Use the NavigationMixin to navigate to the Flow URL
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: flowUrl,
            },
        });
    }
    


  handleFlowEnd(event) {
        if (event.detail.flowStatus === 'FINISHED') {
            const flowNavigationNextEvent = new FlowNavigationNextEvent();
            this.dispatchEvent(flowNavigationNextEvent);
        } else if (event.detail.flowStatus === 'ERROR') {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'An error occurred in the Flow.',
                    variant: 'error',
                })
            );
        }
    }

    

    @wire(getObjectDetails)
    wiredObjectDetails({ error, data }) {
        if (data) {
            this.objectDetails = data;
        } else if (error) {
            console.error('Error fetching data: ', error);
        }
    }
}