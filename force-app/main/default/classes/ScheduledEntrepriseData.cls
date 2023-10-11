global class ScheduledEntrepriseData implements Schedulable {
    global void execute(SchedulableContext ctx) {
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
            String logoUrl = (String) jsonResponse.get('logo_url');
            String adresse = (String) jsonResponse.get('adresse');
            String bio = (String) jsonResponse.get('biographie');
            Integer nombreEmp = (Integer) jsonResponse.get('nombre_emp');
            String dateFondationString = (String) jsonResponse.get('date_fondation');
            Date dateFondation = Date.valueOf(dateFondationString);
            
            // Query the Accounts using the provided IDs
            EntData__c entData = new EntData__c();
            entData.logo_url_c__c = logoUrl;
            entData.adresse_c__c = adresse;
            entData.Biographie_c__c = bio;
            entData.Nombre_emp_c__c = nombreEmp;
            // acc.Foundation_date__c = dateFondation;
        
        
        // Update the records in the database
        upsert entData;
    } else {
        // Handle the case where the request failed
        System.debug('HTTP request failed with status code: ' + res.getStatusCode());
    }
}   

}