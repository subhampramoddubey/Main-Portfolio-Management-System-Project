trigger CandidateApexSharing on Your_Investment__c (after insert) {
    // Check if this is an insert trigger
    if (Trigger.isInsert) {
        // Create a list to store Your_Investment__Share records
        List<Your_Investment__Share> candShares = new List<Your_Investment__Share>();
        Your_Investment__Share candidateShare;

        // Loop through the newly inserted Your_Investment__c records
        for (Your_Investment__c cand : Trigger.new) {
            candidateShare = new Your_Investment__Share();

            // Set the ParentId to the Your_Investment__c record's Id
            candidateShare.ParentId = cand.Id;

            // Set the UserOrGroupId to the User__c field of the Your_Investment__c record
            candidateShare.UserOrGroupId = cand.User__c;

            // Set the access level to 'read'
            candidateShare.AccessLevel = 'read';

            // Set the RowCause
            candidateShare.RowCause = Schema.Your_Investment__Share.RowCause.user__c;

            // Add the Your_Investment__Share record to the list
            candShares.add(candidateShare);
        }

        // Insert the Your_Investment__Share records with sharing access
        Database.SaveResult[] saveResults = Database.insert(candShares, false);

        Integer i = 0;

        // Loop through the results of the insert operation
        for (Database.SaveResult sr : saveResults) {
            if (!sr.isSuccess()) {
                Database.Error err = sr.getErrors()[0];

                // Check if the error is not related to the AccessLevel field
                if (!(err.getStatusCode() == StatusCode.FIELD_FILTER_VALIDATION_EXCEPTION &&
                      err.getMessage().contains('AccessLevel'))) {
                    // Add an error message to the Your_Investment__c record
                    Trigger.newMap.get(candShares[i].ParentId).addError(
                        'Unable to grant sharing access due to the following exception: ' +
                        err.getMessage());
                }
            }
            i++;
        }
    }
}