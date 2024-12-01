/**
 * Purpose: This handler class is used to update the Opportunity fields based on related Task records.
 * It updates the Opportunity's completed_task__c field with the count of completed tasks and the Score field 
 * with the total number of tasks whenever tasks are inserted, updated, or deleted.
 * 
 * Methods:
 * - handleAfterInsert: Handles the logic after Task records are inserted.
 * - handleAfterDelete: Handles the logic after Task records are deleted.
 * - handleAfterUpdate: Handles the logic after Task records are updated.
 * - updateOpportunityFields: Updates the Opportunity fields based on the related Task records.
 * 
 * Example:
 * If Task records related to an Opportunity are inserted, updated, or deleted,
 * the corresponding Opportunity's completed_task__c and Score fields are updated accordingly.
 */
public with sharing class TaskScoreOpportunityHandler{

    /**
     * Handles the logic after Task records are inserted.
     * @param newTasks - List of newly inserted Task records
     */
    public static void handleAfterInsert(List<Task> newTasks) {
        Set<Id> opportunityIds = new Set<Id>(); // Set to store Opportunity IDs related to the new tasks
        for (Task task : newTasks) { // Iterate through each new Task
            if (task.WhatId != null && task.WhatId.getSObjectType() == Opportunity.SObjectType) { // Check if the Task is related to an Opportunity
                opportunityIds.add(task.WhatId); // Add the Opportunity ID to the set
            }
        }
        updateOpportunityFields(opportunityIds); // Update the related Opportunity fields
    }

    /**
     * Handles the logic after Task records are deleted.
     * @param oldTasks - List of deleted Task records
     */
    public static void handleAfterDelete(List<Task> oldTasks) {
        Set<Id> opportunityIds = new Set<Id>(); // Set to store Opportunity IDs related to the deleted tasks
        for (Task task : oldTasks) { // Iterate through each deleted Task
            if (task.WhatId != null && task.WhatId.getSObjectType() == Opportunity.SObjectType) { // Check if the Task was related to an Opportunity
                opportunityIds.add(task.WhatId); // Add the Opportunity ID to the set
            }
        }
        updateOpportunityFields(opportunityIds); // Update the related Opportunity fields
    }

    /**
     * Handles the logic after Task records are updated.
     * @param oldTasks - List of old Task records before the update
     * @param newTasks - List of new Task records after the update
     */
    public static void handleAfterUpdate(List<Task> oldTasks, List<Task> newTasks) {
        Set<Id> opportunityIds = new Set<Id>(); // Set to store Opportunity IDs related to the updated tasks
        
        for (Integer i = 0; i < newTasks.size(); i++) { // Iterate through each updated Task
            Task oldTask = oldTasks[i]; // Get the old Task record
            Task newTask = newTasks[i]; // Get the new Task record
            
            if (newTask.WhatId != null && newTask.WhatId.getSObjectType() == Opportunity.SObjectType) { // Check if the new Task is related to an Opportunity
                opportunityIds.add(newTask.WhatId); // Add the Opportunity ID to the set
            } else if (oldTask.WhatId != null && oldTask.WhatId.getSObjectType() == Opportunity.SObjectType) { // Check if the old Task was related to an Opportunity
                opportunityIds.add(oldTask.WhatId); // Add the Opportunity ID to the set
            }
        }
        updateOpportunityFields(opportunityIds); // Update the related Opportunity fields
    }

    /**
     * Updates the Opportunity fields based on the related Task records.
     * @param opportunityIds - Set of Opportunity IDs to update
     */
    private static void updateOpportunityFields(Set<Id> opportunityIds) {
        List<Opportunity> opportunitiesToUpdate = new List<Opportunity>(); // List to store Opportunities to be updated

        for (Id oppId : opportunityIds) { // Iterate through each Opportunity ID
            Opportunity opp = [SELECT Id, Completed_Task__c, Score__c FROM Opportunity WHERE Id = :oppId LIMIT 1]; // Query the Opportunity record
            List<Task> relatedTasks = [SELECT Id, Status FROM Task WHERE WhatId = :oppId]; // Query related Task records
            Integer completedTaskCount = 0; // Initialize the count of completed tasks
            Integer taskCount = 0; // Initialize the count of total tasks

            for (Task task : relatedTasks) { // Iterate through each related Task
                taskCount++; // Increment the total task count
                if (task.Status == 'Completed') { // Check if the Task status is 'Completed'
                    completedTaskCount++; // Increment the count of completed tasks
                }
            }

            opp.Completed_Task__c = completedTaskCount; // Set the count of completed tasks on the Opportunity
            opp.Score__c = taskCount; // Set the total task count as the score on the Opportunity
            opportunitiesToUpdate.add(opp); // Add the Opportunity to the list of Opportunities to update
        }

        if (!opportunitiesToUpdate.isEmpty()) { // Check if there are any Opportunities to update
            update opportunitiesToUpdate; // Update the Opportunities
        }
    }
}