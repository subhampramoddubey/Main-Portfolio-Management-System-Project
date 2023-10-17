@isTest
public class TestCQ_SD_Part_Family_Class {
    
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
    static void testGetRecords() {
        System.runAs(createUserWithPermissionSet()) {
            
            // Setup Part Family test data
            compliancequest__SQX_Part_Family__c partFamily = new compliancequest__SQX_Part_Family__c(Name = 'TestFamily');
            insert partFamily;
            
            // Setup SQX Part test data
            compliancequest__SQX_Part__c part1 = new compliancequest__SQX_Part__c(
                Name = 'TestPart1',
                compliancequest__Part_Number__c = '12345',
                compliancequest__Part_Type__c = 'TypeA',
                compliancequest__Part_Risk_Level__c = 5,
                compliancequest__Part_Family__c = partFamily.Id // Assigning the Part Family to the Part
            );
            insert part1;
            
            // Test with searchTerm and part family
            Map<String, Object> currentRecord = new Map<String, Object> {
                'CQ_SD_SQX_Part_Family_Lookup__c' => part1.compliancequest__Part_Family__c
            };
            List<SObject> result = CQUI_SD_Filter_Product_By_PartFamily.getRecords(currentRecord, 'TestPart1');
            System.assertEquals(1, result.size(), 'Expected one record');
            
            // Test with searchTerm but without part family
            currentRecord.put('CQ_SD_SQX_Part_Family_Lookup__c', null);
            result = CQUI_SD_Filter_Product_By_PartFamily.getRecords(currentRecord, 'TestPart1');
            System.assertEquals(0, result.size(), 'Expected zero records without part family');
            
            // Test without searchTerm but with part family
            currentRecord.put('CQ_SD_SQX_Part_Family_Lookup__c', part1.compliancequest__Part_Family__c);
            result = CQUI_SD_Filter_Product_By_PartFamily.getRecords(currentRecord, '');
            System.assertEquals(1, result.size(), 'Expected one record without searchTerm');
            
            // Test without currentRecord
            result = CQUI_SD_Filter_Product_By_PartFamily.getRecords(null, 'TestPart1');
            System.assertEquals(0, result.size(), 'Expected zero records without currentRecord');
        }
    }
}