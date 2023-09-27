@isTest
public class SubmitApplicationForApprovalTriggerTest {
    @isTest
    static void testSubmitApplicationForApprovalTrigger() {
        // Create a test user
        Profile standardProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        User testUser = new User(
            FirstName = 'Test11',
            LastName = 'User11',
            Email = 'testuser1111@example.com',
            Username = 'testuser1111@example.com',
            Alias = 'TUser11',
            TimeZoneSidKey = 'GMT',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = standardProfile.Id,
            LanguageLocaleKey = 'en_US'
        );
        insert testUser;

        // Create a test Place_Orders__c record
        Place_Orders__c testOrder = new Place_Orders__c(
            TickerName__c = 'AAPL', // Required field
            Quantity__c = 100, // Required field
            Order_Type__c = 'Buy', // Required field
            Order_Path__c = 'Order Pending', // Assuming your initial state is 'Order Pending'
        	Purchase_Date__c = System.today(),
            Amount__c = 1000,
            Order_Status__c = 'Approved'
           
        );
        insert testOrder;

        Test.startTest();

        // Insert your test records and invoke the trigger
        List<Place_Orders__c> testRecords = new List<Place_Orders__c>();
        testRecords.add(testOrder);
        insert testRecords;

        Test.stopTest();

        // Verify the trigger's behavior
        // Query the records after the trigger execution
        List<Place_Orders__c> updatedRecords = [SELECT Id, Order_Path__c FROM Place_Orders__c WHERE Id = :testOrder.Id];

        // Assert that the approval status has been updated as expected
        System.assertEquals('Order Pending', updatedRecords[0].Order_Path__c); // Replace with the actual field name
    }
}