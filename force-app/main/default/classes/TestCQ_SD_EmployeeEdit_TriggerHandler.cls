@isTest
public class TestCQ_SD_EmployeeEdit_TriggerHandler {
    
    private static User createUserWithPermissionSet() {
        
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'CQ_SD_Common_Permission_Set' LIMIT 1];
        
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1]; 
        
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
        insert u;
        
        // Assign the permission set to the user
        PermissionSetAssignment psa = new PermissionSetAssignment(
            AssigneeId = u.Id,
            PermissionSetId = ps.Id
        );
        insert psa;
        
        return u;
    }
    
    
    
    @isTest
    static void testBeforeUpdate() {
        System.runAs(createUserWithPermissionSet()){
            // Insert a Coach record
            CQ_SD_SQX_Manager__c coach = new CQ_SD_SQX_Manager__c(CQ_SD_Requirement_Status__c = 'Application In Progress');
            insert coach;
            
            
            
            CQ_SD_SQX_Manager__c coach2 = new CQ_SD_SQX_Manager__c(CQ_SD_Requirement_Status__c = 'Application Completed');
            insert coach2;
            
            
            
            // Insert a Player record associated with the above coach
            CQ_SD_SQX_Employee__c player = new CQ_SD_SQX_Employee__c(CQ_SD_SQX_Manager_Lookup__c = coach.Id);
            insert player;
            
            
            
            // Update the Player record
            Test.startTest();
            
            
            
            player.CQ_SD_SQX_Manager_Lookup__c = coach2.Id;
            Database.SaveResult result = Database.update(player, false);
            Test.stopTest();
            
            
            
            // Assert that an error is thrown because the training status is Completed or Closed and changing the parent
            System.assert(!result.isSuccess());
            System.assert(result.getErrors().size() > 0);
            System.assertEquals('Since the Application is Closed you cannot edit these records!', result.getErrors()[0].getMessage());
        }
    }
    
    
    /*     @isTest static void testBeforeUpdate() {
// Prepare test data
CQ_SD_SQX_Manager__c manager = new CQ_SD_SQX_Manager__c(CQ_SD_Requirement_Status__c = 'Application Closed');
insert manager;



// Should throw an error when attempting to update a manager with status 'Application Closed'
Test.startTest();
manager.CQ_SD_Requirement_Status__c = 'Application In Progress';
Database.SaveResult result = Database.update(manager, false);
Test.stopTest();



System.assert(!result.isSuccess());
System.assertEquals('Updating the status to Closed is not allowed.', result.getErrors()[0].getMessage());
}
*/ 
    
    @isTest
    static void testAfterMethod() {
        System.runAs(createUserWithPermissionSet()){
            // Insert a Coach record
            CQ_SD_SQX_Manager__c coach = new CQ_SD_SQX_Manager__c(CQ_SD_Requirement_Status__c = 'Application In Progress');
            insert coach;
            
            
            
            // Insert a Player record associated with the above coach
            CQ_SD_SQX_Employee__c player = new CQ_SD_SQX_Employee__c(CQ_SD_SQX_Manager_Lookup__c = coach.Id);
            insert player;
            
            
            
            Test.startTest();
            
            
            
            // Call the after method
            CQ_SD_EmployeeEdit_TriggerHandler.handleAfterMethod(new List<CQ_SD_SQX_Employee__c> { player });
            
            
            
            Test.stopTest();
            
            
            
            // Assert that the Coach record's Verification__c field is updated to 'Yes'
            coach = [SELECT Verification__c FROM CQ_SD_SQX_Manager__c WHERE Id = :coach.Id LIMIT 1];
            System.assertEquals('Yes', coach.Verification__c);
            
        }
    }
    
    
}