public class ActionStepTriggerHandler {
    public static void entry() {
        if (Trigger.isBefore) {
            if (Trigger.isInsert) {
                setActionStepDescription ((List<Action_Step__c>) Trigger.New, null);
            }
            if (Trigger.isUpdate){
                setActionStepDescription ((List<Action_Step__c>) Trigger.New, (Map <Id, Action_Step__c>) Trigger.oldMap);
            }
        }
    }

     private static void setActionStepDescription (List<Action_Step__c> triggerNew, Map <Id, Action_Step__c> triggerOldMap) {
       List <Action_Step__c> actionStepsPR = new List <Action_Step__c>();
        Id actionStepRecordTypeId = Schema.SObjectType.Action_Step__c.getRecordTypeInfosByDeveloperName().get('Post_Release').getRecordTypeId();
        System.debug('Action Step Recort Type Id' + actionStepRecordTypeId);
        for (Action_Step__c acStep : triggerNew){
            if (acStep.RecordTypeId == actionStepRecordTypeId 
                && ((triggerOldMap != null 
                &&  acStep.Action_Step_Classification__c != triggerOldMap.get(acStep.Id).Action_Step_Classification__c) 
                || triggerOldMap == null)){
            actionStepsPR.add(acStep);
            }
        }
        List<PR_Service_Plan_Utility__c> servicePlans = [Select Name, Action_Step_Classification__c, Description__c, RecordTypeId
                                                         FROM PR_Service_Plan_Utility__c
                                                         WHERE RecordType.DeveloperName = 'Action_Step'];
        Map <String, String> spMap = new Map <String, String>();
        for (PR_Service_Plan_Utility__c sp : servicePlans){
            spMap.put(sp.Action_Step_Classification__c, sp.Description__c);
        }
        spMap.put(null,'');
        for (Action_Step__c asPR : actionStepsPR){
            if(spMap.containsKey(asPR.Action_Step_Classification__c)){
                asPR.Action_Step_Description__c = spMap.get(asPR.Action_Step_Classification__c);
            System.debug('Action Step' + asPR);
            }
        }
    }
}