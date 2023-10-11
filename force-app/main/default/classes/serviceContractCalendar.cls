global with sharing class serviceContractCalendar {

//SELECT Id, Name, StartDate, EndDate FROM ServiceContract
        @AuraEnabled
        global static string getSerCont()
        {
            list<ServiceContract> serviceCont = new list<ServiceContract>();
            serviceCont = [ SELECT Id, Name, StartDate, EndDate FROM ServiceContract];
            return JSON.serialize(serviceCont); 
        }
}