trigger ServiceContractTrigger on ServiceContract (before insert , before update) {

 	Id idContract ;
    for (ServiceContract contract : Trigger.New) {
        // Perform your logic here for each record
        // For example, you can access fields of the current record using obj.FieldName__c
        contract.enddate = contract.startdate.addMonths(contract.Term);
        // Example: Update a field on the record
        System.debug(' wijden contract  LineItemCount  ' + contract.LineItemCount);
 		System.debug(' wijden contract  totalVehicules__c  ' + contract.totalVehicules__c);       
        System.debug(' wijden contract  AccountId  ' + contract.AccountId); 
        Account acc = [SELECT Id,RecordTypeId FROM Account WHERE Id = :contract.AccountId LIMIT 1];
        // Account relatedAccount = ServiceContractHelper.getRelatedAccount(contract.AccountId);
        System.debug(' wijden contract  RecordTypeId  1  ' + acc.RecordTypeId) ;  
            if ( acc.RecordTypeId == '0128d000000YxS3AAK' &&  contract.LineItemCount > 1 && contract.totalVehicules__c > 1 ) {
                contract.addError('Un client conssomateur ne peut pas louer plus q\'un véhicule à la fois. ') ;
            }
        
        // test sur chevauchement des dates 
          List<AggregateResult> results = [SELECT COUNT(ID) numContracts FROM ServiceContract WHERE ( ( startdate < :contract.startdate and enddate > :contract.startdate )
                                          or ( startdate > :contract.startdate   and  enddate < :contract.enddate  )  
                                          or ( startdate > :contract.startdate   and enddate > :contract.enddate   and startdate < :contract.enddate  ) ) 
                                          and AccountId = :contract.AccountId and id <> :contract.id ];
          Integer numContracts =  (Integer)results[0].get('numContracts');
        System.debug(' wijden contract  numContracts     ' + numContracts) ;  
        
        if ( acc.RecordTypeId == '0128d000000YxS3AAK' &&  numContracts >= 1 ) {
                contract.addError('Un client conssomateur ne peut pas avoire plus q\'un contrat dans la meme periode. ') ;
            }

    }
   // List<ServiceContract> sContract = Trigger.New;
	//Trigger.New.get(idContract).addError('test')  ;
 
}