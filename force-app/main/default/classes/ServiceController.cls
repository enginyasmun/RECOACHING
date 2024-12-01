public with sharing class ServiceController {
    @AuraEnabled
    public static void createService(Id caseId, String serviceType) {
        Service__c newService = new Service__c();
        newService.Name = serviceType;
        newService.Case__c = caseId;  // Assuming you have a Case lookup on the Service object
        insert newService;
    }
}