@isTest
public class TestPreventDuplicateApproval {

    // Test method for the trigger logic
    @isTest
    static void testTrigger() {
        // Create a test user
        Profile profile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1]; // Replace with the appropriate profile name
        User testUser = new User(
            FirstName = 'Testcc',
            LastName = 'Usercc',
            Email = 'testuserre@example.com',
            Username = 'testuserre@example.com',
            Alias = 'tuser',
            CommunityNickname = 'tuser',
            ProfileId = profile.Id,
            TimeZoneSidKey = 'GMT',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US'
        );
        insert testUser;

        // Create a test record of Place_Orders__c  
        Place_Orders__c oldOrder = new Place_Orders__c(
            Quantity__c=12,
            TickerName__c='ABC',
            Order_Type__c='BUY',
            Order_Path__c = 'Order Approved'
        );
        insert oldOrder;

        // Attempt to update the record to 'Order Pending'
        oldOrder.Order_Path__c = 'Order Pending';
        update oldOrder;

        // Query the updated record
        Place_Orders__c updatedOrder = [SELECT Order_Path__c FROM Place_Orders__c WHERE Id = :oldOrder.Id LIMIT 1];

        // Verify that an error message was added to the record
        System.assertEquals('You cannot submit an order for approval when it is already approved.', updatedOrder.Order_Path__c);

        // Attempt to update the record to 'Order Rejected'
        updatedOrder.Order_Path__c = 'Order Rejected';
        update updatedOrder;

        // Query the updated record again
        updatedOrder = [SELECT Order_Path__c FROM Place_Orders__c WHERE Id = :updatedOrder.Id LIMIT 1];

        // Verify that a different error message was added to the record
        System.assertEquals('You cannot submit an order for approval when it is already rejected.', updatedOrder.Order_Path__c);
    }
}