public class PlaidMCAService {
    @AuraEnabled
    public static List<String> getPlaidLinks(Id opportunityId) {
        String endpoint = '/plaid_links/' + opportunityId;
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:PlaidMCA' + endpoint);
        req.setMethod('GET');
        
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        if (res.getStatusCode() == 200) {
            return (List<String>) JSON.deserialize(res.getBody(), List<String>.class);
        } else {
            throw new CalloutException('Error from PlaidMCA API: ' + res.getBody());
        }
    }
}