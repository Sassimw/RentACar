public with sharing class rentAcarController {
    @AuraEnabled
    public static ServiceContract insertserCon(ServiceContract serCon,Integer term,Id vehiculeId, Id PriceBookId){
        // return [select id,name,site from account where id=:acc.id];
        serCon.Term = Integer.valueOf(term);
        serCon.Pricebook2Id = '01s8d00000A6q5mAAB';
        //serCon.IsActive = true;
        System.debug('wijden vehiculeId ' + vehiculeId);
        System.debug('this.serCon.Term ' + serCon.Term) ;
        try{
            system.debug('serCon ' + serCon);
            insert serCon;
            addLineItem(vehiculeId, serCon.Id,PriceBookId);
            return serCon;
        }catch(Exception ex){
            throw new AuraHandledException(ex.getMessage());
        }

    }
    

    public static void addLineItem(Id vehicule,Id SerContract,Id PriceBookId){
        System.debug('wijden entre add line item ' + vehicule);
        List<PricebookEntry> results = [SELECT UnitPrice,Id  FROM PricebookEntry Where Product2Id = :vehicule and Pricebook2Id = :PriceBookId ];
        Double priceV =  (Double)results[0].get('UnitPrice');
        
        ContractLineItem conLineItem = new ContractLineItem();
        conLineItem.Quantity = 1;
       // conLineItem.Product2Id = vehicule;
       conLineItem.PricebookEntryId = (Id)results[0].get('Id');
        conLineItem.UnitPrice = priceV ;
        conLineItem.ServiceContractId = SerContract ;
        try{
            System.debug('wijden conLineItem');
            System.debug(conLineItem);
            insert conLineItem;
        }catch(Exception ex){
            throw new AuraHandledException(ex.getMessage());
        }
    }
    @AuraEnabled
    public static Double getUnitPrice(Id vehicule,Id PriceBookId){
        List<PricebookEntry> results = [SELECT UnitPrice,Id  FROM PricebookEntry Where Product2Id = :vehicule and Pricebook2Id = :PriceBookId ];
        Double priceV =  (Double)results[0].get('UnitPrice');
        System.debug('get unit price ' + priceV);
        return priceV;
    }
    
}