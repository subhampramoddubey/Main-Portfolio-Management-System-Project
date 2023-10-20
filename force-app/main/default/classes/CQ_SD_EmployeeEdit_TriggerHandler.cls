public class CQ_SD_EmployeeEdit_TriggerHandler {
    
    // Method to handle updates before they are committed
    public static void handleBeforeUpdate(List<CQ_SD_SQX_Employee__c> newEmployee, Map<Id, CQ_SD_SQX_Employee__c> oldMap) {
        Set<Id> managerIds = new Set<Id>();
        
        // Collect the parent manager IDs for employees with restricted training status
        for (CQ_SD_SQX_Employee__c employee : newEmployee) {
            managerIds.add(employee.CQ_SD_SQX_Manager_Lookup__c);
        }
        
        // Retrieve the managers with restricted training status
        Map<Id, CQ_SD_SQX_Manager__c> managers = new Map<Id, CQ_SD_SQX_Manager__c>(
            [SELECT Id, CQ_SD_Requirement_Status__c FROM CQ_SD_SQX_Manager__c WHERE Id IN :managerIds]
        );
        
        // Check if any child record is associated with a restricted parent and prevent updates
        for (CQ_SD_SQX_Employee__c employee : newEmployee) {
            CQ_SD_SQX_Manager__c manager = managers.get(employee.CQ_SD_SQX_Manager_Lookup__c);
            CQ_SD_SQX_Employee__c oldEmployee = oldMap.get(employee.Id);
            
            // Check if the manager has changed
            if (oldEmployee.CQ_SD_SQX_Manager_Lookup__c != employee.CQ_SD_SQX_Manager_Lookup__c) {
                employee.addError('Cannot edit these records!');
            }
            
            // Check if the manager's status restricts updates
            if (manager.CQ_SD_Requirement_Status__c == 'Application Completed' || manager.CQ_SD_Requirement_Status__c == 'Application Closed') {
                employee.addError('Since the Application is Closed, you cannot edit these records!');
            }
        }
    }
	
    // Method to handle updates after they are committed
    public static void handleAfterMethod(List<CQ_SD_SQX_Employee__c> Players) {
        Set<Id> CoachIdsToUpdate = new Set<Id>();
        
        // Collect the manager IDs for updated employees
        for (CQ_SD_SQX_Employee__c employee : Players) {
            if (employee.CQ_SD_SQX_Manager_Lookup__c != null) {
                CoachIdsToUpdate.add(employee.CQ_SD_SQX_Manager_Lookup__c);
            }
        }
        
        // Retrieve employee counts per manager
        List<AggregateResult> results = [
            SELECT CQ_SD_SQX_Manager_Lookup__c, COUNT(Id) playerCount
            FROM CQ_SD_SQX_Employee__c
            WHERE CQ_SD_SQX_Manager_Lookup__c IN :CoachIdsToUpdate
            GROUP BY CQ_SD_SQX_Manager_Lookup__c
        ];
        
        Map<Id, Integer> coachToPlayerCount = new Map<Id, Integer>();
        
        for (AggregateResult ar : results) {
            coachToPlayerCount.put((Id)ar.get('CQ_SD_SQX_Manager_Lookup__c'), (Integer)ar.get('playerCount'));
        }
        
        List<CQ_SD_SQX_Manager__c> coachesToUpdate = new List<CQ_SD_SQX_Manager__c>();
        
        for (Id coachId : CoachIdsToUpdate) {
            CQ_SD_SQX_Manager__c coach = new CQ_SD_SQX_Manager__c(Id = coachId);
            coach.Verification__c = (coachToPlayerCount.containsKey(coachId) && coachToPlayerCount.get(coachId) > 0) ? 'Yes' : 'No';
            coachesToUpdate.add(coach);
        }
        
        if (!coachesToUpdate.isEmpty()) {
            update coachesToUpdate;
        }
    }
}