// RelatingMatchingOppsWithReseller.cls handles the assignment of Reseller lookup fields on Opportunity records based on the Reseller_Email__c field.

public with sharing class RelatingMatchingOppsWithReseller {

    /**
     * Purpose: Assign Reseller lookup fields on Opportunity records based on the Reseller_Email__c field.
     * Parameters: VARIABLE|TYPE|LIMITATION|DEFINITION
     * opps|List<Opportunity>|non-null|List of Opportunity records to be processed
     * 
     * Outputs: None. Only matching in in Lookup field
     * 
     * Example:
     * List<Opportunity> opps = [SELECT Id, Reseller_Email__c FROM Opportunity WHERE ...];
     * OppResellerTriggerHandler.callReseller(opps);
     */
    public static void callReseller(List<Opportunity> opps) {
        
        // Set to collect unique Reseller email addresses from Opportunity records
        Set<String> resellerEmails = new Set<String>();
        
        // Loop through Opportunity records and add non-null Reseller emails to the set
        for (Opportunity opp : opps) {
            if (opp.Reseller_Email__c != null) {
                resellerEmails.add(opp.Reseller_Email__c);
            }
        }
        
        // Map to hold reseller email to reseller Id
        Map<String, Id> emailToResellerIdMap = new Map<String, Id>();
        
        // Query all Resellers with matching emails if any emails were collected
        if (resellerEmails.size() > 0) {
            for (Reseller__c reseller : [SELECT Id, Email__c FROM Reseller__c WHERE Email__c IN :resellerEmails]) {
                emailToResellerIdMap.put(reseller.Email__c, reseller.Id);
            }
        }
        
        // Loop through Opportunities and assign the Reseller lookup field based on the email to Reseller Id map
        for (Opportunity opp : opps) {
            if (opp.Reseller_Email__c != null && emailToResellerIdMap.containsKey(opp.Reseller_Email__c)) {
                opp.Reseller__c = emailToResellerIdMap.get(opp.Reseller_Email__c);
            }
        }
    }
}



// public with sharing class OppResellerTriggerHandler {
//     public static void callReseller(List<Opportunity> opps){
//     Set<String> resellerEmails = new Set<String>();
//     for (Opportunity opp : opps) {
//         if (opp.Reseller_Email__c != null) {
//             resellerEmails.add(opp.Reseller_Email__c);
//         }
//     }
    
//     // Map to hold reseller email to reseller Id
//     Map<String, Id> emailToResellerIdMap = new Map<String, Id>();
    
//     // Query all Resellers with matching emails
//     if (resellerEmails.size() > 0) {
//         for (Reseller__c reseller : [SELECT Id, Email__c FROM Reseller__c WHERE Email__c IN :resellerEmails]) {
//             emailToResellerIdMap.put(reseller.Email__c, reseller.Id);
//         }
//     }
    
//     // Loop through Opportunities and assign the Reseller lookup field
//     for (Opportunity opp : opps) {
//         if (opp.Reseller_Email__c != null && emailToResellerIdMap.containsKey(opp.Reseller_Email__c)) {
//             opp.Reseller__c = emailToResellerIdMap.get(opp.Reseller_Email__c);
//         }
//     }
// }
// }