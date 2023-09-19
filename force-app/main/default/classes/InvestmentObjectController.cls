public without sharing class InvestmentObjectController {
    @AuraEnabled(cacheable=true)
    public static List<Your_Investment__c> getObjectDetails() {
        
        String adminProfileName = 'System Administrator'; // Replace with the actual name of your admin profile

		String adminProfileId = [SELECT Id FROM Profile WHERE Name = :adminProfileName LIMIT 1].Id;
        
        List<Your_Investment__c> InvestmentList = new List<Your_Investment__c>();
        
             if (UserInfo.getProfileId() == adminProfileId) {
    // If the user is an admin, retrieve data for all owners
	 InvestmentList = [SELECT ID, Name, Total_Quantity__c, Amount_Invested__c FROM Your_Investment__c];
                 
} else {        
	
		InvestmentList = [SELECT ID,Name,Total_Quantity__c,Amount_Invested__c FROM Your_Investment__c WHERE OwnerId = :UserInfo.getUserId()];
    
          
}
        
         return InvestmentList;
    }
    }