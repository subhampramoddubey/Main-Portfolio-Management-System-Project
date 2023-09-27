public class UpdateOwnerOnYourInvestmentHandler {
    public static void handleAfterInsert(List<Your_Investment__c> newInvestments) {
        // Create a map to store the owner IDs of related 'Place Orders' records
        Map<Id, Id> placeOrderOwners = new Map<Id, Id>();

        // Collect the owner IDs of related 'Place Orders' records
        for (Place_Orders__c placeOrder : [SELECT Id, OwnerId, Your_Investment_Lookup__c FROM Place_Orders__c WHERE Your_Investment_Lookup__c IN :newInvestments]) {
            placeOrderOwners.put(placeOrder.Your_Investment_Lookup__c, placeOrder.OwnerId);
        }

        // Iterate through the 'Your Investment' records being inserted
        for (Your_Investment__c investment : newInvestments) {
            // Check if there is a related 'Place Orders' record and its owner ID
            if (placeOrderOwners.containsKey(investment.Id)) {
                // Set the owner of the 'Your Investment' record to match the 'Place Orders' owner
                investment.OwnerId = placeOrderOwners.get(investment.Id);
            }
        }
    }
}