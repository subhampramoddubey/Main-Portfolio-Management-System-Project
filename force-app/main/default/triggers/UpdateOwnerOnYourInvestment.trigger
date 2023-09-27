trigger UpdateOwnerOnYourInvestment on Your_Investment__c (after insert) {
    if (Trigger.isAfter && Trigger.isInsert) {
        UpdateOwnerOnYourInvestmentHandler.handleAfterInsert(Trigger.new);
    }
}