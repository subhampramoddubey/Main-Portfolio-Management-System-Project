trigger SubmitApplicationForApprovalTrigger on Place_Orders__c (after insert) {
    PlaceOrdertriggerHandler.handleAfterInsert(Trigger.new);
}