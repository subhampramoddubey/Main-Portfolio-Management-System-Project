public without sharing class ObjectDetailController {
    @AuraEnabled(cacheable=true)
    public static List<Watchlist__c> getObjectDetails() {
List<Watchlist__c> watchlistList = [SELECT ID,Logo__c,Name,Current_Price__c,Stock_Available__c FROM Watchlist__c];
    

                return watchlistList;
            
            
        
    }}