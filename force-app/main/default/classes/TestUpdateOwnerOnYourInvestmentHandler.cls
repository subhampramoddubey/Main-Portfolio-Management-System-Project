@isTest
public class TestUpdateOwnerOnYourInvestmentHandler {

    // Test method for handleAfterInsert
    @isTest
    static void testHandleAfterInsert() {
        // Create test data - Your_Investment__c records
        List<Your_Investment__c> newInvestments = new List<Your_Investment__c>();
        for (Integer i = 0; i < 5; i++) {
            newInvestments.add(new Your_Investment__c(
                Name = 'Investment ' + i
            ));
        }
        insert newInvestments;

        // Create test data - Place_Orders__c records related to Your_Investment__c records       [Quantity__c, Order_Type__c]
        List<Place_Orders__c> placeOrders = new List<Place_Orders__c>();
        for (Integer i = 0; i < 5; i++) {
            placeOrders.add(new Place_Orders__c(
                TickerName__c = 'Order' + i,
                Quantity__c = 11 + i,
                Order_Type__c='BUY',
                Your_Investment_Lookup__c = newInvestments[i].Id,
                OwnerId = UserInfo.getUserId() // Set the owner to the current user for simplicity
            ));
        }
        insert placeOrders;

        // Call the handleAfterInsert method from your handler
        UpdateOwnerOnYourInvestmentHandler.handleAfterInsert(newInvestments);

        // Verify that the owners of Your_Investment__c records have been updated
        for (Integer i = 0; i < 5; i++) {
            System.assertEquals(placeOrders[i].OwnerId, newInvestments[i].OwnerId);
        }
    }
}