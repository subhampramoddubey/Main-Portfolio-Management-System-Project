@isTest
public class TestCQ_SD_EmployeeEdit_TriggerHandler {

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

    @isTest
    static void testBeforeUpdate() {
        System.runAs(createUserWithPermissionSet()) {
            // Insert a Manager record
            CQ_SD_SQX_Manager__c manager = new CQ_SD_SQX_Manager__c(CQ_SD_Requirement_Status__c = 'Application In Progress');
            insert manager;

            CQ_SD_SQX_Manager__c manager2 = new CQ_SD_SQX_Manager__c(CQ_SD_Requirement_Status__c = 'Application Completed');
            insert manager2;

            // Insert a employee record associated with the above manager
            CQ_SD_SQX_Employee__c employee = new CQ_SD_SQX_Employee__c(CQ_SD_SQX_Manager_Lookup__c = manager.Id);
            insert employee;

            // Update the employee record
            Test.startTest();
            employee.CQ_SD_SQX_Manager_Lookup__c = manager2.Id;
            Database.SaveResult result = Database.update(employee, false);
            Test.stopTest();

            // Assert that an error is thrown because the training status is Completed or Closed and changing the parent
            System.assert(!result.isSuccess());
            System.assert(result.getErrors().size() > 0);
            System.assertEquals('Since the Application is Closed, you cannot edit these records!', result.getErrors()[0].getMessage());
        }
    }

    @isTest
    static void testAfterMethod() {
        System.runAs(createUserWithPermissionSet()) {
            // Insert a manager record
            CQ_SD_SQX_Manager__c manager = new CQ_SD_SQX_Manager__c(CQ_SD_Requirement_Status__c = 'Application In Progress');
            insert manager;

            // Insert a employee record associated with the above manager
            CQ_SD_SQX_Employee__c employee = new CQ_SD_SQX_Employee__c(CQ_SD_SQX_Manager_Lookup__c = manager.Id);
            insert employee;

            Test.startTest();

            // Call the after method
            CQ_SD_EmployeeEdit_TriggerHandler.handleAfterMethod(new List<CQ_SD_SQX_Employee__c> { employee });

            Test.stopTest();

            // Assert that the manager record's Verification__c field is updated to 'Yes'
            manager = [SELECT Verification__c FROM CQ_SD_SQX_Manager__c WHERE Id = :manager.Id LIMIT 1];
            System.assertEquals('Yes', manager.Verification__c);
        }
    }
}