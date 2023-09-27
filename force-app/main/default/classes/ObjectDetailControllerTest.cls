@isTest
public class ObjectDetailControllerTest {

    // Test method for getObjectDetails
    @isTest
    static void testGetObjectDetails() {
        // Create test data - Watchlist records
        List<Watchlist__c> watchlistList = new List<Watchlist__c>();
        for (Integer i = 0; i < 5; i++) {
            watchlistList.add(new Watchlist__c(
                Name = 'Watchlist ' + i,
                Ticker__c = 'ABC',
                Logo__c = 'Logo ' + i,
                Current_Price__c = 10.0 * i,
                Stock_Available__c = 100 * i
            ));
        }
        insert watchlistList;

        // Call the getObjectDetails method from your controller
        List<Watchlist__c> result = ObjectDetailController.getObjectDetails();

        // Verify that the method returns the expected data
        System.assertEquals(5, result.size()); // Ensure the correct number of records is returned

        // Verify that the fields are populated correctly
        for (Integer i = 0; i < 5; i++) {
            Watchlist__c watchlist = result[i];
            System.assertEquals('Watchlist ' + i, watchlist.Name);
            System.assertEquals('Logo ' + i, watchlist.Logo__c);
            System.assertEquals(10.0 * i, watchlist.Current_Price__c);
            System.assertEquals(100 * i, watchlist.Stock_Available__c);
        }
    }
}