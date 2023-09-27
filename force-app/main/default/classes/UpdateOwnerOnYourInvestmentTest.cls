@isTest
public class UpdateOwnerOnYourInvestmentTest {

    @isTest
    static void testTriggerAndHandler() {
        // Create a test user
        Profile profile = [SELECT Id FROM Profile WHERE Name = 'Investing parties' LIMIT 1]; // Replace with the appropriate profile name
        User testUser = new User(
            FirstName = 'Test',
            LastName = 'User',
            Email = 'testuserqwe@example.com',
            Username = 'testuserqwe@example.com',
            Alias = 'tuser',
            CommunityNickname = 'tuser',
            ProfileId = profile.Id,
            TimeZoneSidKey = 'GMT',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US'
        );
        insert testUser;

        // Create a test Place_Orders__c record without Your_Investment_Lookup__c initially 
        Place_Orders__c placeOrder = new Place_Orders__c(
            Quantity__c=10,
            Order_Type__c='BUY',
            TickerName__c = 'ABC',
            OwnerId = testUser.Id,
            Your_Investment_Lookup__c = null
        );
        insert placeOrder;

        // Create a test Your_Investment__c record without OwnerId initially
        Your_Investment__c investment = new Your_Investment__c(
            Name = 'Test Investment',
            User__c = testUser.Id
        );
        insert investment;

        // Update the Place_Orders__c record to set Your_Investment_Lookup__c
        placeOrder.Your_Investment_Lookup__c = investment.Id;
        update placeOrder;

        // Verify that the OwnerId of the Your_Investment__c record has been updated
        investment = [SELECT OwnerId FROM Your_Investment__c WHERE Id = :investment.Id];
        System.assertEquals(testUser.Id, investment.OwnerId);
    }
}