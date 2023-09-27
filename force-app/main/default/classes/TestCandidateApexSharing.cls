@isTest
public class TestCandidateApexSharing {

    // Test method for the trigger logic
    static testMethod void testTrigger() {
        // Create a demo user for testing
        Profile profile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1]; // Replace 'Standard User' with the appropriate profile name
        User demoUser = new User(
            FirstName = 'Demo11',
            LastName = 'User11',
            Email = 'demo11@example.com',
            Username = 'demo11@example.com',
            Alias = 'duser11',
            CommunityNickname = 'duser11',
            ProfileId = profile.Id,
            TimeZoneSidKey = 'GMT',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US'
        );
        insert demoUser;

        // Create a test record of Your_Investment__c with the user field set to the demo user's Id
        Your_Investment__c investment = new Your_Investment__c(
            Name = 'Test Investment',
            OwnerId = demoUser.Id // Set the User__c field to the demo user's Id
        );

        // Insert the test record
        insert investment;

        // Query the inserted Your_Investment__Share record
        Your_Investment__Share shareRecord = [SELECT Id, ParentId, UserOrGroupId, AccessLevel, RowCause FROM Your_Investment__Share WHERE ParentId = :investment.Id LIMIT 1];

         // Add debug statements to check if the trigger is executed
        System.debug('Share record created: ' + shareRecord);
        
        // Assert that the Your_Investment__Share record was created with the expected values
        System.assertEquals('All', shareRecord.AccessLevel);
        System.assertEquals('Owner', shareRecord.RowCause);
        System.assertEquals(demoUser.Id, shareRecord.UserOrGroupId);
    }
}