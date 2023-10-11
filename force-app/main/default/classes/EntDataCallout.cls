public class EntDataCallout {
    public static String logoUrl;
    public static String adresse;
    public static String bio;
    public static Integer nombreEmp;
    public static String dateFondationString;
    public static Date dateFondation;

    public EntDataCallout() {
    }

    @future (callout=true)
    public static void updateEntData(Id accountId) {
        System.debug('wijden get entreprise data');
        

        // Define the external API URL
        String apiUrl = 'https://salesforce-test-api.onrender.com/entreprise/getData';

        // Create an HTTP request
        HttpRequest req = new HttpRequest();
        req.setEndpoint(apiUrl);
        req.setMethod('GET');

        // Create an HTTP object to send the request
        Http http = new Http();

        // Send the request and get the response
        HttpResponse res = http.send(req);

        // Check the response status code
        if (res.getStatusCode() == 200) {
            // Handle the response data here
            Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());

            // Extract the data from the API response
            // (You can modify this part based on your API response structure)
            logoUrl = (String) jsonResponse.get('logo_url');
            adresse = (String) jsonResponse.get('adresse');
            bio = (String) jsonResponse.get('biographie');
            nombreEmp = (Integer) jsonResponse.get('nombre_emp');
            dateFondationString = (String) jsonResponse.get('date_fondation');
            dateFondation = Date.valueOf(dateFondationString);

            // Query the Accounts using the provided IDs
            List<Account> accountsToUpdate = [SELECT Id, logo_url__c, adresse__c, Biographie__c, Nombre_emp__c, Foundation_date__c
                                              FROM Account
                                              WHERE Id = :accountId];

            // Iterate through the queried accounts and update fields
            for (Account acc : accountsToUpdate) {
                acc.logo_url__c = logoUrl;
                acc.adresse__c = adresse;
                acc.Biographie__c = bio;
                acc.Nombre_emp__c = nombreEmp;
               // acc.Foundation_date__c = dateFondation;
            }

            // Update the records in the database
            update accountsToUpdate;
        } else {
            // Handle the case where the request failed
            System.debug('HTTP request failed with status code: ' + res.getStatusCode());
        }
    }
}