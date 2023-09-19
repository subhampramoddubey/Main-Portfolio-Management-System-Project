import { LightningElement } from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import WATCHLIST_OBJECT from '@salesforce/schema/Watchlist__c';
import Ticker from '@salesforce/schema/Watchlist__c.Ticker__c';
import Ticker_Name from '@salesforce/schema/Watchlist__c.Name';
import Stocks_Available from '@salesforce/schema/Watchlist__c.Stock_Available__c';
import Current_Price from '@salesforce/schema/Watchlist__c.Current_Price__c';
import Logo_URL from '@salesforce/schema/Watchlist__c.Logo__c';

export default class createPositionRecord extends LightningElement {

    objectApiName=WATCHLIST_OBJECT;
    fields = [Ticker,Ticker_Name,Stocks_Available,Current_Price, Logo_URL];

    handleSuccess(event){
        const toastEvent=new ShowToastEvent({
            title:"Watchlist Created !",
            message: "Watchlist has been created.",
            variant: "success"
        });

        this.dispatchEvent(toastEvent);
    }

}