trigger OppurtunityTrigger on Opportunity (before insert , before update)  {
    
    for (Opportunity opp : Trigger.New) {
        
        if ( opp.StageName == 'Closed Won' )
        {
            System.debug('Wijden opp' + opp);
            ServiceContract sc = new ServiceContract();
            // get product name 
            List<ACCOUNT> res = [SELECT Name FROM ACCOUNT WHERE Id = :opp.AccountId ];
            System.debug('Wijden res ' + res);
            String ClientName =  (String)res[0].get('Name');
            //Fill service contract data
            sc.Name = 'Contract ' + ClientName + ' ' + System.today() ;
            sc.AccountId= opp.AccountId ;
            sc.Term = (Integer)opp.Contract_Term_Months__c ;
            sc.StartDate = opp.Contract_Start_Date__c ;
            sc.Pricebook2Id = opp.Pricebook2Id ;
            
            insert sc ;
            
            List<OpportunityLineItem> results = [SELECT Id,UnitPrice,Product2Id  FROM OpportunityLineItem WHERE OpportunityId = :opp.Id ];
            
            for (OpportunityLineItem oli : results) {
                // You can print, log, or perform any desired actions for each OpportunityLineItem here
                System.debug('OpportunityLineItem Id: ' + oli.Id);
                System.debug('OpportunityLineItem UnitPrice: ' + oli.UnitPrice);
                System.debug('OpportunityId: Product2Id ' + oli.Product2Id);
                
                List<PricebookEntry> sc_results = [SELECT UnitPrice,Id  FROM PricebookEntry Where Product2Id = :oli.Product2Id and Pricebook2Id = :sc.Pricebook2Id ];
                
                ContractLineItem conLineItem = new ContractLineItem();
                conLineItem.Quantity = 1;
                conLineItem.PricebookEntryId = (Id)sc_results[0].get('Id');
                conLineItem.UnitPrice = oli.UnitPrice ;
                conLineItem.ServiceContractId = sc.Id ;
                
                insert conLineItem;
            }
        }
    }
}