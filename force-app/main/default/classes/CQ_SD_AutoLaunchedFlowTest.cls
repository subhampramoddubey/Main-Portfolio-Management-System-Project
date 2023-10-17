@isTest
private class CQ_SD_AutoLaunchedFlowTest{

        // Helper method to create a user with a specific permission set
    private static User createUserWithPermissionSet() {
        // Retrieve the desired permission set by name
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'CQ_SD_Common_Permission_Set' LIMIT 1];

        // Retrieve a profile for the user (replace 'Standard User' with the actual profile name)
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1]; 

        // Create a new user with specified attributes
        User u = new User(
            ProfileId = p.Id,
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
        insert u;
        PermissionSetAssignment psa = new PermissionSetAssignment(
            AssigneeId = u.Id,
            PermissionSetId = ps.Id
        );
        insert psa;

        return u;  // Return the created user
    }
 
    @isTest static void testAutoLaunchedFlow() {
        
                // Run the test as the user with the specified permission set
        System.runAs(createUserWithPermissionSet()) {
        
        // 1. Insert a test record without the expected updates from the Flow
        CQ_SD_SQX_Manager__c testCoach = new CQ_SD_SQX_Manager__c(
            Name = 'Test Coach'
        );
        insert testCoach;

 

        // Set up Flow and its variables
        Flow.Interview.CQUI_SD_DateSet_AL_Flow flow = new Flow.Interview.CQUI_SD_DateSet_AL_Flow(
            new Map<String, Object> {
                'InRecord' => testCoach
            }
        );

        Test.startTest();
        // Execute the flow
        flow.start();

        Test.stopTest();
        // Retrieve the OutRecord variable from the flow
        CQ_SD_SQX_Manager__c outCoach = (CQ_SD_SQX_Manager__c)flow.getVariableValue('OutRecord');

        // Validate the expected changes on OutRecord
        System.assertEquals(Date.today().addDays(10), outCoach.CQ_SD_Joinning_Date__c, 'Target date on OutRecord should be 10 days ahead of the current date.');
    }
    }
}