public class WatchlistAPexClass {

    /**
     * Aura-enabled method to retrieve a list of Watchlist records.
     * 
     * @return List of Watchlist records or null if the list is empty.
     */
    @AuraEnabled
    public static List<Watchlist__c> getWatchlist() {
        // Query Watchlist records from the database
        List<Watchlist__c> watchlistList = [SELECT ID, Name, Current_Price__c, Stock_Available__c, Logo__c FROM Watchlist__c];

        // Check if the list is not empty
        if (!watchlistList.isEmpty()) {
            return watchlistList;
        }

        // Return null if the list is empty
        return null;
    }
}