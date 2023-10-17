public class CQ_SD_Manager_Trigger_Handler { 
    
	
    public static void beforeUpdate(List<CQ_SD_SQX_Manager__c> newManagers, Map<Id, CQ_SD_SQX_Manager__c> oldManagers) {
        for (CQ_SD_SQX_Manager__c newManager : newManagers) {
            CQ_SD_SQX_Manager__c oldManager = oldManagers.get(newManager.Id);

            if (oldManager.CQ_SD_Requirement_Status__c == 'Application Closed') {
                newManager.CQ_SD_Requirement_Status__c.addError('Updating the status to Closed is not allowed.');
            }
        }
    }
}