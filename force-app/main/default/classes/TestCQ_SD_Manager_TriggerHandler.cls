@isTest
public class TestCQ_SD_Manager_TriggerHandler {
    
        
    // Helper method to create a user with a permission set
    private static User createUserWithPermissionSet() {
        // Retrieve the desired permission set by name
        PermissionSet psets = [SELECT Id FROM PermissionSet WHERE Name = 'CQ_SD_Common_Permission_Set' LIMIT 1];
        
        // Retrieve a profile for the user (replace 'Standard User' with the actual profile name)
        Profile pro = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1]; 
        
        // Create a new user with specified attributes
        User user = new User(
            ProfileId = pro.Id,
            Alias = 'standt',
            Email = 'standarduser@testorg.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Testing',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'standarduser@testo1rg.com'
        );
        // Insert the user and assign the permission set
        insert user;
        PermissionSetAssignment psa = new PermissionSetAssignment(
            AssigneeId = user.Id,
            PermissionSetId = psets.Id
        );
        insert psa;
        
        return user;  // Return the created user
    }


    static testMethod void testBeforeUpdate() {
        
                // Run the test as the user with the specified permission set
        System.runAs(createUserWithPermissionSet()) {
            
        // Create a test CQ_SD_SQX_Manager__c record with 'Application Closed'
        CQ_SD_SQX_Manager__c managerClosed = new CQ_SD_SQX_Manager__c(
            Name = 'Manager Closed',
            CQ_SD_Requirement_Status__c = 'Application Closed'
        );
        insert managerClosed;

        // Create a map of old records
        Map<Id, CQ_SD_SQX_Manager__c> oldMap = new Map<Id, CQ_SD_SQX_Manager__c>();
        oldMap.put(managerClosed.Id, managerClosed);

        // Call the beforeUpdate method for managerClosed
        Test.startTest();
        CQ_SD_Manager_Trigger_Handler.beforeUpdate(
            new List<CQ_SD_SQX_Manager__c>{managerClosed},
            oldMap
        );
        Test.stopTest();

        // Verify that an error has been added for managerClosed
        System.assert(ApexPages.hasMessages(), 'An error should be added for managerClosed');
    }
    }
}