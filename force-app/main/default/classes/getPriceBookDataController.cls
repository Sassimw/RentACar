public with sharing class getPriceBookDataController {
    @AuraEnabled(cacheable=true)
    public static List<Pricebook2> getPriceBooks() {
      return [SELECT Id, Name FROM Pricebook2 WHERE IsActive = true];
    }
}