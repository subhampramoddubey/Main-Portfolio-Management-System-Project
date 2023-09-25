@isTest
public class InvestmentChartControllerTest {

    // Test method to cover the fetchInvestments method
    static testMethod void testFetchInvestments() {
        // Create a test user
        Profile profile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1]; // Replace with the appropriate profile name
        User testUser = new User(
            FirstName = 'Test111',
            LastName = 'User111',
            Email = 'testuser111@example.com',
            Username = 'testuser111@example.com',
            Alias = 'tuser',
            CommunityNickname = 'tuser',
            ProfileId = profile.Id,
            TimeZoneSidKey = 'GMT',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US'
        );
        insert testUser;

        // Set the current user context to the test user
        System.runAs(testUser) {
            // Create a test Your_Investment__c record owned by the test user
            Your_Investment__c investment = new Your_Investment__c(
                Name = 'Test Investment',
                Amount_Invested__c = 1000.00
            );
            insert investment;

            // Call the fetchInvestments method from the controller
            List<Your_Investment__c> investments = InvestmentChartController.fetchInvestments();

            // Assert that the returned list contains the test investment record
            System.assertEquals(1, investments.size());
            System.assertEquals('Test Investment', investments[0].Name);
            System.assertEquals(1000.00, investments[0].Amount_Invested__c);
        }
    }
}