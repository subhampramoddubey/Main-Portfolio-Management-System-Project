public class WatchlistAPexClass {

    @AuraEnabled
    public static List<Watchlist__c> getWatchlist(){
        List<Watchlist__c> watchlistList = [SELECT ID,Name,Current_Price__c,Stock_Available__c,Logo__c FROM Watchlist__c];
    
            if(!watchlistList.isEmpty()){
                return watchlistList;
            }
            
            return NULL;
            }
}