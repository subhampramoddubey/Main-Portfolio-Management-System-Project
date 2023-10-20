trigger CQ_SD_RestrictCompleteOnManager_Trigger on CQ_SD_SQX_Manager__c (before update) {
    

    
        CQ_SD_Manager_Trigger_Handler.beforeUpdate(Trigger.new, Trigger.oldMap);

}