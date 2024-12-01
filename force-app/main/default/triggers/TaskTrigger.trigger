trigger TaskTrigger on Task (before insert, before update, after insert, after update, before delete, after delete) {

/**
 * Purpose: This trigger executes after a Task record is inserted, updated, or deleted to update the related Opportunity's completed_task__c field 
 * based on the count of completed tasks and the Score field based on the total number of tasks.
 * 
 * Trigger Events: after insert, after update, after delete
 * 
 * Example:
 * If a Task record with WhatId linked to an Opportunity is inserted, updated, or deleted, 
 * the trigger will call the TaskTriggerHandler methods to update the corresponding Opportunity's completed_task__c and Score fields.
 */

 if (Trigger.isAfter) {
    if (Trigger.isInsert) {
        TaskScoreOpportunityHandler.handleAfterInsert(Trigger.new);
    } else if (Trigger.isDelete) {
        TaskScoreOpportunityHandler.handleAfterDelete(Trigger.old);
    } else if (Trigger.isUpdate) {
        TaskScoreOpportunityHandler.handleAfterUpdate(Trigger.old, Trigger.new);
    }
}
}