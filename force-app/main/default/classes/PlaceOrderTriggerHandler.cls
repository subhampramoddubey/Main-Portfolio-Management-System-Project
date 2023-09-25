public class PlaceOrderTriggerHandler {

    public static void handleAfterUpdate(List<Place_Orders__c> newPlaceOrders, Map<Id, Place_Orders__c> oldPlaceOrdersMap) 
    {
        // Create a set to store unique Ticker Names
        Set<String> uniqueTickerNames = new Set<String>();

        // Collect all unique Ticker Names from the updated records with Order_Status__c changed to "Approved"
        for (Place_Orders__c newOrder : newPlaceOrders) {
            Place_Orders__c oldOrder = oldPlaceOrdersMap.get(newOrder.Id);
            if (newOrder.Order_Status__c == 'Approved' && oldOrder.Order_Status__c != 'Approved') {
                uniqueTickerNames.add(newOrder.TickerName__c);
            }
        }

        // Query existing Your Investment records for matching Ticker Names
        Map<String, Your_Investment__c> existingInvestments = new Map<String, Your_Investment__c>(); 
        for (Your_Investment__c investment : [SELECT Id, Name, Total_Quantity__c, Amount_Invested__c FROM Your_Investment__c WHERE Name In :uniqueTickerNames]) {
            existingInvestments.put(investment.Name, investment);
        }

        // Create a list to store new investments to be inserted or updated
        List<Your_Investment__c> investmentsToUpdate = new List<Your_Investment__c>();

        // Iterate through the updated records and update/create Your Investment records
        for (Place_Orders__c newOrder : newPlaceOrders) {
            Place_Orders__c oldOrder = oldPlaceOrdersMap.get(newOrder.Id);
            
            if (newOrder.Order_Status__c == 'Approved' && oldOrder.Order_Status__c != 'Approved') {
                Your_Investment__c investment;
                
                if (existingInvestments.containsKey(newOrder.TickerName__c)) {
                    // Update existing Your Investment record
                    investment = existingInvestments.get(newOrder.TickerName__c);
                    investment.Total_Quantity__c += newOrder.Quantity__c;
                    investment.Amount_Invested__c += newOrder.Amount__c;
                } else {
                    // Create new record
                    investment = new Your_Investment__c(
                        Name = newOrder.TickerName__c,
                        Total_Quantity__c = newOrder.Quantity__c,
                        Amount_Invested__c = newOrder.Amount__c,
                        OwnerId = newOrder.OwnerId
                    );
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
    
    public static void handlePreventDuplicateApproval(List<Place_Orders__c> newOrders, Map<Id, Place_Orders__c> oldOrderMap) 
    {
        for (Place_Orders__c newOrder : newOrders) {
            Place_Orders__c oldOrder = oldOrderMap.get(newOrder.Id);

            // Check if the record is being submitted for approval
            if (newOrder.Order_Path__c == 'Order Pending' &&
                (oldOrder.Order_Path__c == 'Order Approved' || oldOrder.Order_Path__c == 'Order Rejected')) {

                // Prevent the submission and display an error message
                if (oldOrder.Order_Path__c == 'Order Approved') {
                    newOrder.addError('You cannot submit an order for approval when it is already approved.');
                } else if (oldOrder.Order_Path__c == 'Order Rejected') {
                    newOrder.addError('You cannot submit an order for approval when it is already rejected.');
                }
            }
        }
    }

    public static void handleAfterInsert(List<Place_Orders__c> newOrders) {
        List<Id> recordIds = new List<Id>();
        
        for (Place_Orders__c order : newOrders) {
            // Check if you want to send an approval request for specific conditions
            // For example, only for certain types of orders or based on other criteria.
            // You can add your conditions here.
            
            // Assuming you want to send an approval for all new records:
            recordIds.add(order.Id);
        }
        
        if (!recordIds.isEmpty()) {
            Approval.ProcessSubmitRequest approvalRequest = new Approval.ProcessSubmitRequest();
            approvalRequest.setObjectId(recordIds[0]); // Assuming a single record in this example.
            
            // Submit the approval request
            Approval.ProcessResult result = Approval.process(approvalRequest);
            
            // You can handle the result here if needed, e.g., log or notify users.
        }
    }

}
