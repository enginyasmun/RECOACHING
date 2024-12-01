public with sharing class PaymentController {
    private static final String TOKEN_URL = 'https://login.salesforce.com/services/oauth2/token';
    private static final String ENDPOINT_URL = 'https://cs191.salesforce.com/services/apexrest/test/Payment';
    private static final String CLIENT_ID = '3MVG9NYvTkhtdEI4bnbjjZNtQFUiiBMRZgG2gROgVEt0mZALaKQYFq29WqgdS4kVjrUWAvus8h0Rxgwkrr0rQ';
    private static final String CLIENT_SECRET = '3D7B9E83FE04D740709063D780E60662C98C8F6EFD5FA17954DC096AA8B22798';
    private static final String REFRESH_TOKEN = '5Aep8614S5Oxg.jnj.ASVuVuotEVilg80d4o.08yeIp7RK7hGj3rCN.3g52_q2gHDn_2dbNMyONmUvQ7vBcakp_';

    @AuraEnabled
    public static String sendPayment(Id caseId) {

  try {
     List<Distribution__c> distributions = [SELECT Id, External_Id__c, Amount__c, Status__c 
                                               FROM Distribution__c 
                                               WHERE Case__c = :caseId AND Status__c = 'Approved'];

  
       

String accessToken = getAccessToken();
if (accessToken == null) {
for (Distribution__c dist : distributions) {
    dist.Status__c = 'Integration Failed';
    update dist;
}
   
return 'Failed to get access token';
}

        if (distributions.isEmpty()) {
            return 'No Distributions to send';
        }

        for (Distribution__c dist : distributions) {
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(ENDPOINT_URL);
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('Authorization', 'Bearer ' + accessToken);

            Map<String, Object> requestBody = new Map<String, Object>();
            requestBody.put('disbursementNumber', dist.External_Id__c);
            requestBody.put('amount', dist.Amount__c);

            request.setBody(JSON.serialize(requestBody));
            HttpResponse response = http.send(request);

            if (response.getStatusCode() == 200) {
                dist.Status__c = 'Sent';
            } else {
                dist.Status__c = 'Integration Failed';
            }

            update dist;
        }

        return 'Success';
    
} catch (Exception e) {
    return 'No Distribution with Status : Approved ';
  }
    }
    private static String getAccessToken() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(TOKEN_URL);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        request.setBody('grant_type=refresh_token' +
                        '&client_id=' + CLIENT_ID +
                        '&client_secret=' + CLIENT_SECRET +
                        '&refresh_token=' + REFRESH_TOKEN);

        try {
            HttpResponse response = http.send(request);
            System.debug('Response Status: ' + response.getStatusCode());
            System.debug('Response Body: ' + response.getBody());

            if (response.getStatusCode() == 200) {
                Map<String, Object> authResponse = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                return (String) authResponse.get('access_token');
            } else {
                System.debug('Failed to get access token: ' + response.getBody());
                return null;
            }
        } catch (Exception e) {
            System.debug('Exception: ' + e.getMessage());
            return null;
        }
    }

    @AuraEnabled(cacheable=true)
    public static Boolean hasApprovedDistributions(Id caseId) {
        List<Distribution__c> distributions = [SELECT Id FROM Distribution__c WHERE Case__c = :caseId AND Status__c = 'Approved'];
        return !distributions.isEmpty();
    }
}