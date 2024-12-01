public class AccessTokenService {
    
    public static String getAccessToken(String clientId, String clientSecret, String tokenEndpointUrl) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();

        // Set the token endpoint URL (from Postman settings)
        request.setEndpoint(tokenEndpointUrl);
        
        // Set the HTTP method to POST
        request.setMethod('POST');
        
        // Set headers (Postman auto-generates some, here we set what is necessary)
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        request.setHeader('Accept', '*/*');
        request.setHeader('Connection', 'keep-alive');
        
        // Form the request body to send the client credentials
        String requestBody = 'grant_type=client_credentials' +
                             '&client_id=' + EncodingUtil.urlEncode(clientId, 'UTF-8') +
                             '&client_secret=' + EncodingUtil.urlEncode(clientSecret, 'UTF-8');
        
        // Set the request body
        request.setBody(requestBody);
        
        try {
            // Send the request
            HttpResponse response = http.send(request);
            
            // Parse the response
            if (response.getStatusCode() == 200) {
                // Successful response, extract access token
                Map<String, Object> responseBody = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                String accessToken = (String) responseBody.get('access_token');
                
                // Return the access token
                return accessToken;
            } else {
                // Log error response
                System.debug('Error: ' + response.getBody());
                return null;
            }
        } catch (Exception e) {
            // Handle exceptions
            System.debug('Exception: ' + e.getMessage());
            return null;
        }
    }
    
    // Method to get Accounts from connected org
    public static void getAccountsFromConnectedOrg(String clientId, String clientSecret, String tokenEndpointUrl, String instanceUrl) {
        // Get the access token
        String accessToken = getAccessToken(clientId, clientSecret, tokenEndpointUrl);
        
        if (accessToken != null) {
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            
            // Set the Salesforce instance URL with the Account API endpoint
            request.setEndpoint(instanceUrl + '/services/data/v56.0/query?q=SELECT+Id,Name+FROM+Account');
            
            // Set the method to GET
            request.setMethod('GET');
            
            // Set the Authorization header with the access token
            request.setHeader('Authorization', 'Bearer ' + accessToken);
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('Accept', 'application/json');
            
            try {
                // Send the GET request to retrieve Accounts
                HttpResponse response = http.send(request);
                
                // Parse the response
                if (response.getStatusCode() == 200) {
                    // Deserialize response body into a map
                    Map<String, Object> responseBody = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());

                    // Extract the 'records' from the response body
                    if (responseBody.containsKey('records')) {
                        List<Object> recordsList = (List<Object>) responseBody.get('records');
                        
                        // Iterate over the records
                        for (Object recordObj : recordsList) {
                            Map<String, Object> record = (Map<String, Object>) recordObj;
                            
                            // Safely retrieve Account Id and Name
                            System.debug('Account Id: ' + record.get('Id') + ', Account Name: ' + record.get('Name'));
                        }
                    }
                    
                    // Now perform the DML operation after the callout is completed
                    Opportunity x = [SELECT id, name FROM Opportunity LIMIT 1];
                    x.Description = accessToken;  // Storing the access token in Description for demo purposes
                    System.debug('Opportunity: ' + x.name);
                    update x;  // DML after the callout
                } else {
                    System.debug('Failed to retrieve Accounts: ' + response.getBody());
                }
            } catch (Exception e) {
                System.debug('Exception: ' + e.getMessage());
            }
        } else {
            System.debug('Failed to retrieve access token.');
        }
    }
}














// public class AccessTokenService {
    
//     public static String getAccessToken(String clientId, String clientSecret, String tokenEndpointUrl) {
//         Http http = new Http();
//         HttpRequest request = new HttpRequest();

//         // Set the token endpoint URL (from Postman settings)
//         request.setEndpoint(tokenEndpointUrl);
        
//         // Set the HTTP method to POST
//         request.setMethod('POST');
        
//         // Set headers (Postman auto-generates some, here we set what is necessary)
//         request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
//         request.setHeader('Accept', '*/*');
//         request.setHeader('Connection', 'keep-alive');
        
//         // Form the request body to send the client credentials
//         String requestBody = 'grant_type=client_credentials' +
//                              '&client_id=' + EncodingUtil.urlEncode(clientId, 'UTF-8') +
//                              '&client_secret=' + EncodingUtil.urlEncode(clientSecret, 'UTF-8');
        
//         // Set the request body
//         request.setBody(requestBody);
        
//         try {
//             // Send the request
//             HttpResponse response = http.send(request);
            
//             // Parse the response
//             if (response.getStatusCode() == 200) {
//                 // Successful response, extract access token
//                 Map<String, Object> responseBody = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
//                 String accessToken = (String) responseBody.get('access_token');
//             Opportunity x = [SELECT id, name
//                             FROM Opportunity 
//                             LIMIT 1];

//                 x.Description = accessToken;
//                 System.debug(x.name);
//                 update x;
//                 // Return the access token
//                 return accessToken;
//             } else {
//                 // Log error response
//                 System.debug('Error: ' + response.getBody());
//                 return null;
//             }
//         } catch (Exception e) {
//             // Handle exceptions
//             System.debug('Exception: ' + e.getMessage());
//             return null;
//         }
//     }
// }

