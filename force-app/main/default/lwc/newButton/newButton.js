// cardWithFlowButton.js
import { LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class CardWithFlowButton extends NavigationMixin(LightningElement) {
    handleButtonClick() {
        // Specify the URL of your Flow
        const flowUrl = '/flow/Get_Order_Details'; // Replace with your Flow's URL

        // Use the NavigationMixin to navigate to the Flow URL
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: flowUrl,
            },
        });
    }
}