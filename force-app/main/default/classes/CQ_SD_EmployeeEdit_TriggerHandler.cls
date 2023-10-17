public class CQ_SD_EmployeeEdit_TriggerHandler {
    
    public static void handleBeforeUpdate(List<CQ_SD_SQX_Employee__c> newPlayers,Map<id,CQ_SD_SQX_Employee__c> oldMap) {
        Set<Id> MIds = new Set<Id>();
        // Collect the parent coach IDs with restricted training status
        for (CQ_SD_SQX_Employee__c player : newPlayers) {
            MIds.add(player.CQ_SD_SQX_Manager_Lookup__c);
        }
        Map<Id, CQ_SD_SQX_Manager__c> coaches = new Map<Id, CQ_SD_SQX_Manager__c>(
            [SELECT Id, CQ_SD_Requirement_Status__c FROM CQ_SD_SQX_Manager__c WHERE Id IN :MIds]
        );
        // Check if any child record is associated with a restricted parent and prevent updates
        for (CQ_SD_SQX_Employee__c player : newPlayers) {
            CQ_SD_SQX_Manager__c coach = coaches.get(player.CQ_SD_SQX_Manager_Lookup__c);
            CQ_SD_SQX_Employee__c oldPlayer=oldMap.get(player.id);
            if(oldPlayer.CQ_SD_SQX_Manager_Lookup__c!=player.CQ_SD_SQX_Manager_Lookup__c){
                player.addError('cannot edit these records!');
            }
            if (coach.CQ_SD_Requirement_Status__c == 'Application Completed' || coach.CQ_SD_Requirement_Status__c == 'Application Closed') {
                player.addError('Since the Application is Closed you cannot edit these records!');
            }
        }
    }

	
    public static void handleAfterMethod(List<CQ_SD_SQX_Employee__c> Players){


        Set<Id> CoachIdsToUpdate = new Set<Id>();
        for (CQ_SD_SQX_Employee__c player : Players) {
            if (player.CQ_SD_SQX_Manager_Lookup__c != null) {
                CoachIdsToUpdate.add(player.CQ_SD_SQX_Manager_Lookup__c);
            }
        }

        List<AggregateResult> results=[
            Select CQ_SD_SQX_Manager_Lookup__c , COUNT(Id) playerCount
            From CQ_SD_SQX_Employee__c
            Where CQ_SD_SQX_Manager_Lookup__c IN :CoachIdsToUpdate
            GROUP BY CQ_SD_SQX_Manager_Lookup__c
        ];

        Map<Id,Integer> coachToPlayerCount=new Map<Id,Integer>();
        for(AggregateResult ar: results){
            coachToPlayerCount.put((Id)ar.get('CQ_SD_SQX_Manager_Lookup__c'),(Integer)ar.get('playerCount'));
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