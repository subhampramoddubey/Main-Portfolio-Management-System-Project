trigger CandidateApexSharing on Your_Investment__c (after insert) {

     if(trigger.isInsert){

        List<Your_Investment__Share> candShrs  = new List<Your_Investment__Share>();


        Your_Investment__Share candidateShr;


        for(Your_Investment__c cand : trigger.new){

            CandidateShr = new Your_Investment__Share();



            CandidateShr.ParentId = cand.Id;



            CandidateShr.UserOrGroupId = cand.User__c;



            CandidateShr.AccessLevel = 'read';



            CandidateShr.RowCause = Schema.Your_Investment__Share.RowCause.user__c;



            candShrs.add(CandidateShr);

        }


        Database.SaveResult[] lsr = Database.insert(candShrs,false);


        Integer i=0;


        for(Database.SaveResult sr : lsr){
            if(!sr.isSuccess()){

                Database.Error err = sr.getErrors()[0];


                if(!(err.getStatusCode() == StatusCode.FIELD_FILTER_VALIDATION_EXCEPTION  
&&  err.getMessage().contains('AccessLevel'))){

                    trigger.newMap.get(candShrs[i].ParentId).
                      addError(
                       'Unable to grant sharing access due to following exception: '
                       + err.getMessage());
                }
            }
            i++;
        }   
    }




 

}