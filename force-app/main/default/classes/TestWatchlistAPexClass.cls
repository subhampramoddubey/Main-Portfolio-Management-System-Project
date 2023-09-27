@isTest
public class TestWatchlistAPexClass {

    // Test method for the getWatchlist method
    @isTest
    static void testGetWatchlist() {
         Test.startTest();

        // Call the getWatchlist method
        List<Watchlist__c> result = WatchlistAPexClass.getWatchlist();

        // Assert that the result is null
        System.assertEquals(null, result);

        Test.stopTest();

        // Create test data - Watchlist records
        List<Watchlist__c> watchlistRecords = new List<Watchlist__c>();
        for (Integer i = 0; i < 5; i++) {
            watchlistRecords.add(new Watchlist__c(
                Name = 'Watchlist ' + i,
                Ticker__c = 'ABC',
                Current_Price__c = 100.0 + i,
                Stock_Available__c = 50 + i,
                Logo__c = 'Logo ' + i
            ));
        }
        insert watchlistRecords;

        // Call the getWatchlist method from your Apex class
        List<Watchlist__c> returnedWatchlist = WatchlistAPexClass.getWatchlist();

        // Verify that the returned list is not null
        System.assertNotEquals(null, returnedWatchlist);

        // Verify that the returned list contains the expected number of records
        System.assertEquals(5, returnedWatchlist.size());

        // Verify that the fields in the returned records match the test data
        for (Integer i = 0; i < 5; i++) {
            Watchlist__c expectedWatchlist = watchlistRecords[i];
            Watchlist__c actualWatchlist = returnedWatchlist[i];

            System.assertEquals(expectedWatchlist.Name, actualWatchlist.Name);
            System.assertEquals(expectedWatchlist.Current_Price__c, actualWatchlist.Current_Price__c);
            System.assertEquals(expectedWatchlist.Stock_Available__c, actualWatchlist.Stock_Available__c);
            System.assertEquals(expectedWatchlist.Logo__c, actualWatchlist.Logo__c);
        }
    }
}