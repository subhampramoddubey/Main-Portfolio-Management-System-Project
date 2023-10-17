public class CQ_SD_Manager_Trigger_Handler {
    
    // Method to handle actions before updating CQ_SD_SQX_Manager__c records
    public static void beforeUpdate(List<CQ_SD_SQX_Manager__c> newManagers, Map<Id, CQ_SD_SQX_Manager__c> oldManagers) {
        for (CQ_SD_SQX_Manager__c newManager : newManagers) {
            // Get the corresponding old manager record
            CQ_SD_SQX_Manager__c oldManager = oldManagers.get(newManager.Id);
            
            // Check if the old manager's requirement status is 'Application Closed'
            if (oldManager.CQ_SD_Requirement_Status__c == 'Application Closed') {
                // Prevent updating the status to Closed and add an error
                newManager.CQ_SD_Requirement_Status__c.addError('Updating the status to Closed is not allowed.');
            }
        }
    }
}