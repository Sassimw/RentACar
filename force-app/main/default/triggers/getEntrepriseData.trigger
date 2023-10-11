trigger getEntrepriseData on Account (after insert, after update) {
    // Create a set to store the IDs of the Accounts that need to be updated
    Set<Id> accountIdsToUpdate = new Set<Id>();
    
    // Check if the Account records have changed
    for (Account acc : Trigger.new) {
        // Call the Apex class method and pass the set of IDs
        EntDataCallout.updateEntData(acc.Id);
    }
}