@isTest
public class PlaceOrderTriggerHandlerTest {

    @isTest
    static void testHandlePreventDuplicateApproval() {
        // Create a test user for context
        Profile profile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        User testUser = new User(
            FirstName = 'Test',
            LastName = 'User',
            Email = 'testuse23r@example.com',
            Username = 'testuserrrr@example.com',
            Alias = 'tuser',
            CommunityNickname = 'tuser',
            ProfileId = profile.Id,
            TimeZoneSidKey = 'GMT',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US'
        );
        insert testUser;

        // Create test Place_Orders__c records
        Place_Orders__c order1 = new Place_Orders__c(
            Quantity__c = 10,
            Order_Type__c = 'BUY',
            TickerName__c = 'ABC', 
            Order_Path__c = 'Order Pending'
        );
        Place_Orders__c order2 = new Place_Orders__c(
            Quantity__c = 10,
            Order_Type__c = 'BUY',
            TickerName__c = 'ABC', 
            Order_Path__c = 'Order Approved'
        );
        Place_Orders__c order3 = new Place_Orders__c(
            Quantity__c = 10,
            TickerName__c = 'ABC', 
            Order_Type__c = 'BUY',
            Order_Path__c = 'Order Rejected'
        );
        insert new List<Place_Orders__c> { order1, order2, order3 };

        // Map of old Order Path values for the test orders
        Map<Id, Place_Orders__c> oldOrderMap = new Map<Id, Place_Orders__c>();
        oldOrderMap.put(order1.Id, order1);
        oldOrderMap.put(order2.Id, order2);
        oldOrderMap.put(order3.Id, order3);

         // Set the context user
        System.runAs(testUser) {
            Test.startTest();

            // Call the handler method
            PreventDuplicateApprovalHandlerClass.handlePreventDuplicateApproval(new List<Place_Orders__c> { order1, order2, order3 }, oldOrderMap);

            Test.stopTest();

            // Verify error messages by catching exceptions
            try {
                update new List<Place_Orders__c> { order1, order2, order3 };
            } catch (DmlException e) {
                System.assert(e.getMessage().contains('You cannot submit an order for approval when it is already approved.'));
                System.assert(e.getMessage().contains('You cannot submit an order for approval when it is already rejected.'));
            }
        }
    }
}