trigger ContactTrigger on Contact (before insert , before update) {
    for (Contact con : Trigger.New) {
        if (con.AccountId != null) {
            if ( trigger.isupdate )
            {
                Contact oldRecord = Trigger.oldMap.get(con.Id);
            	if ( oldRecord.AccountId != con.AccountId) {
                // Example: Update a field on the record
                Account acc = [SELECT Id,RecordTypeId FROM Account WHERE Id = :con.AccountId LIMIT 1];
                
                List<AggregateResult> results = [SELECT COUNT(ID) numContacts FROM CONTACT WHERE AccountId = :con.AccountId ];
                Integer nombre_acc =  (Integer)results[0].get('numContacts');
                // Account relatedAccount = ServiceContractHelper.getRelatedAccount(contract.AccountId);
                System.debug('Wijden Nombre de contact  ' + nombre_acc) ;  
                nombre_acc++;
                
                if ( acc.RecordTypeId == '0128d000000YxS3AAK' &&  nombre_acc > 1 ) {
                    con.addError('Un client conssomateur ne peut pas avoir plus d\'un contact à la fois.') ;
                	}
            	}
            }
            else
            {
               
                Account acc = [SELECT Id,RecordTypeId FROM Account WHERE Id = :con.AccountId LIMIT 1];
                
                List<AggregateResult> results = [SELECT COUNT(ID) numContacts FROM CONTACT WHERE AccountId = :con.AccountId ];
                Integer nombre_acc =  (Integer)results[0].get('numContacts');
                // Account relatedAccount = ServiceContractHelper.getRelatedAccount(contract.AccountId);
                System.debug('Wijden Nombre de contact  ' + nombre_acc) ;  
                nombre_acc++;
                
                if ( acc.RecordTypeId == '0128d000000YxS3AAK' &&  nombre_acc > 1 ) {
                    con.addError('Un client conssomateur ne peut pas avoir plus d\'un contact à la fois.') ;
                	}
            	
            }
        }
    }
}