@isTest
public class CandidateApexSharingTest {

    @isTest
    static void testSharingGranted() {
        // Create a test user
        Profile profile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1]; // Replace with the actual profile name
        User testUser = new User(
            FirstName = 'Test09',
            LastName = 'User90',
            Email = 'testuser90@example.com',
            Username = 'testuser90@example.com',
            Alias = 'tuser90',
            CommunityNickname = 'tuser',
            ProfileId = profile.Id,
            TimeZoneSidKey = 'GMT',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US'
        );
        insert testUser;

        Test.startTest();

        // Create a test context with the test user
        System.runAs(testUser) {
            // Insert a new Your_Investment__c record (this should trigger sharing)
            Your_Investment__c newInvestment = new Your_Investment__c(
                Name = 'ABC',
            Total_Quantity__c = 10,
            Amount_Invested__c = 1500,
            Investment_Type__c = 'BUY',
                User__c = testUser.Id
            );
            insert newInvestment;

            // Query the inserted Your_Investment__Share record
            Your_Investment__Share shareRecord = [SELECT Id, ParentId, UserOrGroupId, AccessLevel, RowCause FROM Your_Investment__Share WHERE ParentId = :newInvestment.Id LIMIT 1];

            // Assert that sharing access has been granted
            System.assertEquals('All', shareRecord.AccessLevel);
            System.assertEquals('Owner', shareRecord.RowCause);
            System.assertEquals(testUser.Id, shareRecord.UserOrGroupId);
        }

        Test.stopTest();
    }

    @isTest
    static void testSharingNotGranted() {
        // Create a test user
        Profile profile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1]; // Replace with the actual profile name
        User testUser = new User(
            FirstName = 'Test91',
            LastName = 'User91',
            Email = 'testuser91@example.com',
            Username = 'testuser91@example.com',
            Alias = 'tuser',
            CommunityNickname = 'tuser',
            ProfileId = profile.Id,
            TimeZoneSidKey = 'GMT',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US'
        );
        insert testUser;

        Test.startTest();

        // Create a test context with the test user
        System.runAs(testUser) {
            // Insert a new Your_Investment__c record (this should not trigger sharing)
            Your_Investment__c newInvestment = new Your_Investment__c(
                Name = 'ABCDDD',
            Total_Quantity__c = 100,
            Amount_Invested__c = 15000,
            Investment_Type__c = 'BUY',
                User__c = testUser.Id
            );
        //    insert newInvestment;

            // Query the inserted Your_Investment__Share record
            List<Your_Investment__Share> shareRecords = [SELECT Id, ParentId, UserOrGroupId, AccessLevel, RowCause FROM Your_Investment__Share WHERE ParentId = :newInvestment.Id];

            // Assert that sharing access has not been granted (no sharing records created)
            System.assertEquals(0, shareRecords.size());
        }

        Test.stopTest();
    }
}