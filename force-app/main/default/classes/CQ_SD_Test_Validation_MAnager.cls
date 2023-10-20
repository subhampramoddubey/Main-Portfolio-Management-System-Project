@isTest
public class CQ_SD_Test_Validation_MAnager {
    
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
    
    // Test method to validate a custom date validation rule for Manager objects
    @isTest static void testDateCondition() {
        
        System.runAs(createUserWithPermissionSet()) {
            
            // Create a test Manager record with an intentionally invalid date configuration
            CQ_SD_SQX_Manager__c testManager = new CQ_SD_SQX_Manager__c(
                Name = 'Test Restaurant',
                CQ_SD_Reporting_Date__c = Date.today(),
                CQ_SD_Joinning_Date__c = Date.today().addDays(-1) // Making Joinning date 1 day before the initiated date
            );
            
            
            
            // Define an exception variable to capture the expected validation exception
            Exception expectedException;
            
            
            
            try {
                // Attempt to insert the testManager record, expecting a validation exception
                insert testManager;
            } catch (System.DmlException e) {
                expectedException = e;
            }
            
            
            
            // Assertions to validate the expected validation behavior
            System.assertNotEquals(null, expectedException, 'Expected a DML Exception due to the validation rule.');
            System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION', expectedException.getDmlType(0).name(), 'Expected a custom validation exception.');
            System.assert(expectedException.getMessage().contains('Reporting Date Cannot be Greater then Joinning Date'), 'Expected validation error message: 	Reporting Date Cannot be Greater then Joinning Date');
        }
    }
    }