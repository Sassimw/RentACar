public class EntDataCalloutQueabale implements Queueable {
    private List<Account> accountsToUpdate;

    public EntDataCalloutQueabale(List<Account> accountsToUpdate) {
        this.accountsToUpdate = accountsToUpdate;
    }

    public void execute(QueueableContext context) {
        // Check if there are records to update
        if (accountsToUpdate.isEmpty()) {
            return;
        }

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

        // Handle the response and update records as needed (similar to previous code)
        if (res.getStatusCode() == 200) {
            // Handle the response data here
            Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());

            // Extract the data from the API response
            String logoUrl = (String) jsonResponse.get('logo_url');
            String adresse = (String) jsonResponse.get('adresse');
            String bio = (String) jsonResponse.get('biographie');
            Integer nombreEmp = (Integer) jsonResponse.get('nombre_emp');
            String dateFondationString = (String) jsonResponse.get('date_fondation');
            Date dateFondation = Date.valueOf(dateFondationString);
            // Iterate through the queried accounts and update fields
            for (Account acc : accountsToUpdate) {
                acc.logo_url__c = logoUrl;
                acc.adresse__c = adresse;
                acc.Biographie__c = bio;
                acc.Nombre_emp__c = nombreEmp;
                //acc.Foundation_date__c = dateFondation;
            }

            // You can update the records in the database here
            update accountsToUpdate;
        } else {
            // Handle the case where the request failed
            System.debug('HTTP request failed with status code: ' + res.getStatusCode());
        }
    }
}