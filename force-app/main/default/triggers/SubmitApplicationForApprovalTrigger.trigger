trigger SubmitApplicationForApprovalTrigger on Place_Orders__c (after insert) {
    List<Id> recordIds = new List<Id>();
    
    for (Place_Orders__c order : Trigger.new) {
        // Check if you want to send approval request for specific conditions
        // For example, only for certain types of orders or based on other criteria.
        // You can add your conditions here.
        
        // Assuming you want to send approval for all new records:
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