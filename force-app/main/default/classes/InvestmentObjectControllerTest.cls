@isTest
public class InvestmentObjectControllerTest {
    // Test method for getObjectDetails
    @isTest
    static void testGetObjectDetails() {
        // Create a test user
        Profile userProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1]; // Replace with the appropriate profile name
        User testUser = new User(
            FirstName = 'Test2222',
            LastName = 'Userr2222',
            Email = 'testuserr2222@example.com',
            Username = 'testuserr2222@example.com',
            Alias = 'tuser22',
            CommunityNickname = 'tuser',
            ProfileId = userProfile.Id,
            TimeZoneSidKey = 'GMT',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US'
        );
         insert testUser;

		Profile adminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1]; // Replace with the appropriate profile name
        
        // Create a second test user with a different OwnerId
        User testUser2 = new User(
            FirstName = 'Test32',
            LastName = 'Userr32',
            Email = 'testuserr32@example.com',
            Username = 'testuserr32@example.com',
            Alias = 'tuserr32',
            CommunityNickname = 'tuserr2',
            ProfileId = adminProfile.Id, // Set the profile directly
            TimeZoneSidKey = 'GMT',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US'
        );
        insert testUser2;

        // Create a test record of Your_Investment__c associated with testUser
        Your_Investment__c investment1 = new Your_Investment__c(
            Name = 'Test Investment 1',
            OwnerId = testUser.Id
        );
        insert investment1;

        // Create a test record of Your_Investment__c associated with testUser2
        Your_Investment__c investment2 = new Your_Investment__c(
            Name = 'Test Investment 2',
            OwnerId = testUser2.Id
        );
        insert investment2;

        // Set the user context to testUser (an admin)
        System.runAs(testUser) {
            // Call the getObjectDetails method from your controller
            List<Your_Investment__c> result = InvestmentObjectController.getObjectDetails();

            // Verify that the method returns the expected data for all owners
            System.assertEquals(1, result.size()); // Ensure both records are returned
            System.assertEquals('Test Investment 1', result[0].Name); // Ensure the correct record is returned
           // System.assertEquals('Test Investment 2', result[1].Name); // Ensure the correct record is returned
        }

        // Set the user context to testUser2 (a non-admin)
        System.runAs(testUser2) {
            // Call the getObjectDetails method from your controller
            List<Your_Investment__c> result = InvestmentObjectController.getObjectDetails();

            // Verify that the method returns the expected data for the specific OwnerId
            System.assertEquals(2, result.size()); // Ensure only one record is returned
            System.assertEquals('Test Investment 1', result[0].Name); // Ensure the correct record is returned
        }
    }
}