public class ServiceContractCtr {
    public String MstrId{GET;SET;}
    public String baseURL{GET;SET;}
    public Account accObj{GET;SET;}
    public ServiceContract serContObj{GET;SET;}
    public ContractLineItem  ConLineItm{GET;SET;}
    public Product2 prod{GET;SET;}
    public List<ContractLineItemWithProduct> conLineItemsWithProducts{GET;SET;}
    public class ContractLineItemWithProduct {
        public ContractLineItem lineItem { get; set; }
        public Product2 relatedProduct { get; set; }
    }
    
    
    
    public PageReference Cancel()
    {
        PageReference Pdf = NEW PageReference('/'+MstrID);
        pdf.setredirect(TRUE);
        RETURN Pdf;
    }
    
    public ServiceContractCtr(ApexPages.StandardController Controller){
        baseURL = URL.getSalesforceBaseUrl().toExternalForm();
        MstrId = ApexPages.currentPage().getParameters().get('id');
        //SELECT Id, AccountId, ContactId FROM ServiceContract
        serContObj = [SELECT Id, AccountId, ContactId FROM ServiceContract WHERE Id =: MstrId ];
        System.debug('Wijden Account ID ' + serContObj.AccountId);
        accObj = [SELECT Id, Name, Phone, Industry, Rating, Description, Website, TYPE, (SELECT Id, Name, FirstName, LastName, Email, AccountId, Phone, Title FROM Contacts) 
                  FROM Account WHERE Id =: serContObj.AccountId ];
        /*
ConLineItm = [SELECT Id, StartDate, EndDate, Quantity, Product2Id, UnitPrice, TotalPrice FROM ContractLineItem WHERE ServiceContractId =:MstrId ];
System.debug('Wijden ConLineItm ' + ConLineItm);
prod = [SELECT Id, Name, Type__c, Model_annee__c FROM Product2 WHERE Id=:ConLineItm.Product2Id ];*/
       conLineItemsWithProducts = new List<ContractLineItemWithProduct>();
        
        List<ContractLineItem> conLineItems = [
            SELECT Id, StartDate, EndDate, Quantity, Product2Id, UnitPrice, TotalPrice
            FROM ContractLineItem
            WHERE ServiceContractId = :mstrId
        ];
        
        Set<Id> productIds = new Set<Id>();
        for (ContractLineItem lineItem : conLineItems) {
            productIds.add(lineItem.Product2Id);
        }
        
        Map<Id, Product2> productMap = new Map<Id, Product2>([
            SELECT Id, Name, Type__c, Model_annee__c
            FROM Product2
            WHERE Id IN :productIds
        ]);
        
        for (ContractLineItem lineItem : conLineItems) {
            ContractLineItemWithProduct itemWithProduct = new ContractLineItemWithProduct();
            itemWithProduct.lineItem = lineItem;
            itemWithProduct.relatedProduct = productMap.get(lineItem.Product2Id);
            conLineItemsWithProducts.add(itemWithProduct);
        }
        
        System.debug('Contract Line Items with Product Details: ' + conLineItemsWithProducts);
        
    }
}