trigger PlaceOrderTrigger on Place_Orders__c (after update) {
    // Create a set to store unique Ticker Names
    Set<String> uniqueTickerNames = new Set<String>();

    // Collect all unique Ticker Names from the updated records with Order_Status__c changed to "Approved"
    for (Place_Orders__c order : Trigger.new) {
        if (order.Order_Status__c  == 'Approved' && Trigger.oldMap.get(order.Id).Order_Status__c != 'Approved') {
            uniqueTickerNames.add(order.TickerName__c);
        }
    }

    // Query existing Your Investment records for matching Ticker Names
    Map<String, Your_Investment__c> existingInvestments = new Map<String, Your_Investment__c>(); 
    for (Your_Investment__c investment : [SELECT Id, Name, Total_Quantity__c, Amount_Invested__c FROM Your_Investment__c WHERE Name In :uniqueTickerNames]){
        
        existingInvestments.put(investment.Name, investment);
    }


    // Create a list to store new investments to be inserted
    List<Your_Investment__c> investmentsToUpdate  = new List<Your_Investment__c>();
    
      // Iterate through the updated records and update/create Your Investment records
    for (Place_Orders__c order : Trigger.new) {
        if (order.Order_Status__c == 'Approved' && Trigger.oldMap.get(order.Id).Order_Status__c != 'Approved') {
            
            Your_Investment__c investment;
            
             if (existingInvestments.containsKey(order.TickerName__c)) {
                
                 // Update existing Your Investment record
               
                 investment = existingInvestments.get(order.TickerName__c);
                investment.Total_Quantity__c += order.Quantity__c;
                investment.Amount_Invested__c += order.Amount__c;
            } else {
                // Create new record
                investment = new Your_Investment__c( Name = order.TickerName__c, Total_Quantity__c = order.Quantity__c,Amount_Invested__c = order.Amount__c,OwnerId = order.OwnerId);
            }
            
             investmentsToUpdate.add(investment);
        }
    }

    // Update or insert Your Investment records
    if (!investmentsToUpdate.isEmpty()) {
        List<Database.SaveResult> results = Database.insert(investmentsToUpdate, false);
        
        // Handle any errors if needed
        for (Database.SaveResult result : results) {
            if (!result.isSuccess()) {
                // Handle the error, such as logging it or notifying the user.
            }
        }
    }
}