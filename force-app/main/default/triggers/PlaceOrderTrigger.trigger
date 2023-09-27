trigger PlaceOrderTrigger on Place_Orders__c (before update, after insert, after update) {
    if (Trigger.isBefore && Trigger.isUpdate) {
        PreventDuplicateApprovalHandlerClass.handlePreventDuplicateApproval(Trigger.new, Trigger.oldMap);
    }

    if (Trigger.isAfter && Trigger.isInsert) {
        PlaceOrderTriggerHandler.handleAfterInsert(Trigger.new);
    }

    if (Trigger.isAfter && Trigger.isUpdate) {
        PlaceOrderTriggerHandler.handleAfterUpdate(Trigger.new, Trigger.oldMap);
    }
}