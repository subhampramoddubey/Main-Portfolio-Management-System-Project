trigger PlaceOrderTrigger on Place_Orders__c (after update) {


        PlaceOrderTriggerHandler.handleAfterUpdate(Trigger.new, Trigger.oldMap);
    
}
