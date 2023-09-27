public without sharing class InvestmentObjectController {
    @AuraEnabled(cacheable=true)
    public static List<Your_Investment__c> getObjectDetails() {
        // Get the name of the admin profile (replace with actual profile name)
        String adminProfileName = 'System Administrator';

        // Query the admin profile's ID
        String adminProfileId = [SELECT Id FROM Profile WHERE Name = :adminProfileName LIMIT 1].Id;

        // Initialize a list to store Your_Investment__c records
        List<Your_Investment__c> InvestmentList = new List<Your_Investment__c>();

        // Check if the user is an admin
        if (UserInfo.getProfileId() == adminProfileId) {
            // If the user is an admin, retrieve data for all owners
            InvestmentList = [SELECT ID, Name, Total_Quantity__c, Amount_Invested__c FROM Your_Investment__c];
        } else {
            // If the user is not an admin, retrieve data only for their own records
            InvestmentList = [SELECT ID, Name, Total_Quantity__c, Amount_Invested__c FROM Your_Investment__c WHERE OwnerId = :UserInfo.getUserId()];
        }
            
        // Return the list of Your_Investment__c records
        return InvestmentList;
    }
}