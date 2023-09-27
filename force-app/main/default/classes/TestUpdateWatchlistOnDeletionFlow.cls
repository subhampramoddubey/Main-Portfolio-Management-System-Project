@isTest
public class TestUpdateWatchlistOnDeletionFlow {    

    static testMethod void testFlowExecution() {
        // Create a Watchlist record with the same TickerName as your test data
        Watchlist__c watchlistRecord = new Watchlist__c(Name = 'ABC',Ticker__c='ABC',Current_Price__c=99, Stock_Available__c = 110); // Replace 'ABC' with your test TickerName
        insert watchlistRecord;

        // Create a Place Orders record with Order_Path__c = 'Order Pending' and a reference to the Watchlist record
        Place_Orders__c placeOrderRecord = new Place_Orders__c(   
            
            Quantity__c =10,
            Order_Type__c='BUY',
            Order_Path__c = 'Order Pending',
            TickerName__c = 'ABC' // Replace 'ABC' with your test TickerName
        );
        insert placeOrderRecord;

        // Verify that the Watchlist record was created successfully
        System.assertEquals(1, [SELECT COUNT() FROM Watchlist__c WHERE Name = 'ABC']);

        // Delete the Place Orders record to trigger the flow
        delete placeOrderRecord;

        // Query the Watchlist record after the flow execution
        Watchlist__c updatedWatchlist = [SELECT Stock_Available__c FROM Watchlist__c WHERE Name = 'ABC'];

        // Verify that the Stock_Available__c field of the Watchlist record was updated as expected
        Decimal expectedStockAvailable = 100 + placeOrderRecord.Quantity__c;
        System.assertEquals(expectedStockAvailable, updatedWatchlist.Stock_Available__c);
    }
}