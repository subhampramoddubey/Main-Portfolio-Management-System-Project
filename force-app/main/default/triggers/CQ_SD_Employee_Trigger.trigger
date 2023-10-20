trigger CQ_SD_Employee_Trigger on CQ_SD_SQX_Employee__c (before update,after insert, after delete) {
        
    if(trigger.isBefore && trigger.isUpdate) {
    CQ_SD_EmployeeEdit_TriggerHandler.handleBeforeUpdate(Trigger.new,Trigger.oldMap);
    }
    
    if(trigger.isAfter && trigger.isInsert){

         CQ_SD_EmployeeEdit_TriggerHandler.handleAfterMethod(Trigger.new); 

    }
    if(trigger.isAfter && trigger.isDelete){

         CQ_SD_EmployeeEdit_TriggerHandler.handleAfterMethod(Trigger.old); 

    }
    
    
    
}