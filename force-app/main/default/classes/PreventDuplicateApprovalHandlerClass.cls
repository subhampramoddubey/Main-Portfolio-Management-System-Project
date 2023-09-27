public class PreventDuplicateApprovalHandlerClass { 
    public static void handlePreventDuplicateApproval(List<Place_Orders__c> newOrders, Map<Id, Place_Orders__c> oldOrderMap) {
        for (Place_Orders__c newOrder : newOrders) 
        {
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
}