public class SlackNotifier {
    @future(callout=true)
    public static void sendOpportunityUpdate(List<Id> opportunityIds) {
        // Query the opportunities based on the IDs
        List<Opportunity> opportunities = [SELECT Id, Name, Amount, StageName FROM Opportunity WHERE Id IN :opportunityIds];
        
        String webhookUrl = 'https://hooks.slack.com/services/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'; // Replace with your actual Slack webhook URL
        
        // Prepare the HTTP request
        Http http = new Http();
        
        for (Opportunity opp : opportunities) {
            HttpRequest request = new HttpRequest();
            request.setEndpoint(webhookUrl);
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json');
            
            // Customize your message
            String message = 'Opportunity *' + opp.Name + '* has a significant Amount change.\n' +
                             'New Amount: ' + opp.Amount + '\n' +
                             'Stage: ' + opp.StageName;
            
            // Create the JSON payload
            Map<String, Object> payload = new Map<String, Object>();
            payload.put('text', message);
            String serializedPayload = JSON.serialize(payload);
            
            request.setBody(serializedPayload);
            
            try {
                // Send the HTTP request to Slack
                HttpResponse response = http.send(request);
                
                // Optional: Handle the response
                if (response.getStatusCode() != 200) {
                    System.debug('Error sending message to Slack: ' + response.getBody());
                }
            } catch (Exception e) {
                System.debug('Exception: ' + e.getMessage());
            }
        }
    }
}












// public class SlackNotifier {
//     @future(callout=true)
//     public static void sendOpportunityUpdate(List<Id> opportunityIds) {
//         // Query the opportunities based on the IDs
//         List<Opportunity> opportunities = [SELECT Id, Name, Amount, StageName FROM Opportunity WHERE Id IN :opportunityIds];
        
//         String webhookUrl = 'https://hooks.slack.com/services/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'; // Replace with your actual Slack webhook URL
        
//         // Prepare the HTTP request
//         Http http = new Http();
//         HttpRequest request = new HttpRequest();
//         request.setEndpoint(webhookUrl);
//         request.setMethod('POST');
//         request.setHeader('Content-Type', 'application/json');
        
//         for (Opportunity opp : opportunities) {
//             // Customize your message
//             String message = 'Opportunity *' + opp.Name + '* has been updated.\n' +
//                              'Amount: ' + opp.Amount + '\n' +
//                              'Stage: ' + opp.StageName;
            
//             // Create the JSON payload
//             Map<String, Object> payload = new Map<String, Object>();
//             payload.put('text', message);
//             String serializedPayload = JSON.serialize(payload);
            
//             request.setBody(serializedPayload);
            
//             try {
//                 // Send the HTTP request to Slack
//                 HttpResponse response = http.send(request);
//                 System.debug(response);
                
//                 // Optional: Handle the response
//                 if (response.getStatusCode() != 200) {
//                     System.debug('Error sending message to Slack: ' + response.getBody());
//                 }
//             } catch (Exception e) {
//                 System.debug('Exception: ' + e.getMessage());
//             }
//         }
//     }
// }