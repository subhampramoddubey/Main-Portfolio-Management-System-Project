public with sharing class InvestmentChartController {
    @AuraEnabled(cacheable=true)
    public static List<Your_Investment__c> fetchInvestments() {
        // Get the current user's ID
        String currentUserID = UserInfo.getUserId();

        // Use the current user's ID in the SOQL query to filter records
        return [SELECT Id, Name, Amount_Invested__c FROM Your_Investment__c WHERE OwnerId = :currentUserID];
    }
}