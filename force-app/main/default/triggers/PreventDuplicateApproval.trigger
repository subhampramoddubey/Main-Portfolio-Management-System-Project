trigger PreventDuplicateApproval on Place_Orders__c (before update) {
     PreventDuplicateApprovalHandlerClass.handlePreventDuplicateApproval(Trigger.new, Trigger.oldMap);
}