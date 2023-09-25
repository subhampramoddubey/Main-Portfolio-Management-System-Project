@isTest
public class TestPlaceOrdersFlow {
    // Define a test method to create a Place Orders record and trigger the Flow
    static testMethod void testFlow() {
        // Create a test record for Watchlist
        Watchlist__c watchlistRecordToInsert = new Watchlist__c(
            Name = 'Test Watchlist',
            Ticker__c='ABC',
            Current_Price__c = 100,
            Stock_Available__c = 50
        );
        
        // Insert the test record to get a valid Id
        insert watchlistRecordToInsert;

        // Query the inserted Watchlist record to get its Id
        Watchlist__c watchlistRecord = [SELECT Id FROM Watchlist__c WHERE Id = :watchlistRecordToInsert.Id];

        // Create a Place Orders record to trigger the Flow
        Place_Orders__c placeOrderRecord = new Place_Orders__c(
            Ticker__c = watchlistRecord.Id, // Use the Id of the Watchlist record as the Ticker__c value
            Quantity__c = 10, // Set the Quantity__c as needed
            TickerName__c='ABC' , 
            Order_Type__c='BUY'
        );

        // Start Test
        Test.startTest();
        
        // Insert the Place Orders record to trigger the Flow
        insert placeOrderRecord;

        // Query the updated Watchlist record after the Flow runs
        Watchlist__c updatedWatchlistRecord = [SELECT Stock_Available__c FROM Watchlist__c WHERE Id = :watchlistRecord.Id];

        // Assert that the Stock_Available__c field is updated correctly
        System.assertEquals(40, updatedWatchlistRecord.Stock_Available__c); // The updated value after Flow

        // End Test
        Test.stopTest();
    }
}