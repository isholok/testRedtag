public class GoalTriggerHandler {
    public static void entry() {
        if (Trigger.isBefore) {
            if (Trigger.isInsert) {
                setGoalDescription ((List<Goal__c>) Trigger.New, null);
            }
            if (Trigger.isUpdate){
                setGoalDescription ((List<Goal__c>) Trigger.New, (Map <Id, Goal__c>) Trigger.oldMap);
            }
        }
    }
    
    private static void setGoalDescription (List<Goal__c> triggerNew, Map <Id, Goal__c> triggerOldMap) {
        List <Goal__c> goalsPR = new List <Goal__c>();
        Id GoalRecordTypeId = Schema.SObjectType.Goal__c.getRecordTypeInfosByDeveloperName().get('Post_Release').getRecordTypeId();
        System.debug('Goal Record Type Id' + GoalRecordTypeId);
        for (Goal__c goal: triggerNew){
            if (goal.RecordTypeId == GoalRecordTypeId 
                && ((triggerOldMap != null 
                &&  goal.Goal_Classification__c != triggerOldMap.get(goal.Id).Goal_Classification__c) 
                || triggerOldMap == null)){
            goalsPR.add(goal);
            }
        }
        List<PR_Service_Plan_Utility__c> servicePlans = [Select Name, Goal_Classification__c, Description__c, RecordTypeId
                                                         FROM PR_Service_Plan_Utility__c
                                                         WHERE RecordType.DeveloperName = 'Goal'];
        Map <String, String> spMap = new Map <String, String>();
        for (PR_Service_Plan_Utility__c sp : servicePlans){
            spMap.put(sp.Goal_Classification__c, sp.Description__c);
        }
        spMap.put(null,'');
        for (Goal__c goalPR : goalsPR){
            if(spMap.containsKey(goalPR.Goal_Classification__c)){
                goalPR.Goal_Description__c = spMap.get(goalPR.Goal_Classification__c);
                 System.debug('Goal'+goalPR);
            }
        }
    }
}