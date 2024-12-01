trigger OpportunityTriggger on Opportunity (before insert, before update, after insert, after update, before delete, after delete) {


    /**
 * Purpose: This trigger executes before an Opportunity record is inserted or updated to ensure that the Reseller lookup field is set based on the Reseller_Email__c field.
 * 
 * Trigger Events: before insert, before update
 * 
 * Example:
 * If an Opportunity record with Reseller_Email__c = 'reseller@example.com' is inserted or updated, 
 * the trigger will call the OppResellerTriggerHandler.callReseller method to assign the corresponding Reseller__c field.
 */

if (Trigger.isBefore) {
    if (Trigger.isInsert || Trigger.isUpdate ) {
        
        RelatingMatchingOppsWithReseller.callReseller(Trigger.new);
    }
}


if (Trigger.isUpdate) {

//       // Collect the IDs of updated opportunities
//       List<Id> updatedOpportunityIds = new List<Id>();
//       for (Opportunity opp : Trigger.new) {
//           updatedOpportunityIds.add(opp.Id);
//       }
//       // Call the future method with the list of IDs
//       SlackNotifier.sendOpportunityUpdate(updatedOpportunityIds);

// }


  // List to hold IDs of opportunities that meet the 20% change criterion
  List<Id> opportunityIdsToNotify = new List<Id>();
    
  for (Opportunity newOpp : Trigger.new) {
      Opportunity oldOpp = Trigger.oldMap.get(newOpp.Id);
      
      // Ensure that the Amount is not null to avoid null pointer exceptions
      if (oldOpp.Amount != null && newOpp.Amount != null && oldOpp.Amount > 0) {
          // Calculate the percentage change
          Decimal amountDifference = newOpp.Amount - oldOpp.Amount;
          Decimal percentChange = (amountDifference / oldOpp.Amount) * 100;
          
          // Check if the absolute percentage change exceeds 20%
          if (Math.abs(percentChange) > 20) {
              opportunityIdsToNotify.add(newOpp.Id);
          }
      } else if (oldOpp.Amount == null && newOpp.Amount != null) {
          // Handle cases where old Amount is null and new Amount is not null
          opportunityIdsToNotify.add(newOpp.Id);
      } else if (oldOpp.Amount != null && newOpp.Amount == null) {
          // Handle cases where old Amount is not null and new Amount is null
          opportunityIdsToNotify.add(newOpp.Id);
      }
      // Optionally, handle cases where both old and new Amounts are null (if needed)
  }
  
  // Call the future method if there are any opportunities to notify
  if (!opportunityIdsToNotify.isEmpty()) {
      SlackNotifier.sendOpportunityUpdate(opportunityIdsToNotify);
  }

}
}