@isTest 
public class GoalTriggerHandlerTest {
    @isTest static void testCreateGoal() {
        Goal__c testGoal = TestDataFactory2.createGoals ();
        PR_Service_Plan_Utility__c testSpUtility = TestDataFactory2.createServicePlanUtilityGoalRT ();
        Test.startTest();
        insert testSpUtility;
        insert testGoal;
        Test.stopTest();
        Goal__c checkGoal = [SELECT Id, Name, Goal_Description__c 
                             FROM Goal__c WHERE Name = 'TestGoal' LIMIT 1];
        PR_Service_Plan_Utility__c checkSPUtility = [SELECT Id, Name, Description__c 
                                                     FROM PR_Service_Plan_Utility__c 
                                                     WHERE Id = :testSpUtility.Id LIMIT 1];
        system.assertEquals (checkGoal.Goal_Description__c, checkSPUtility.Description__c, 
                             'Goal description should be equal to Service Plan Utility description');
    }
    
    @isTest static void testUpdateGoal() {
        Goal__c testGoal =  TestDataFactory2.createGoals ();
        Test.startTest();
        insert testGoal;
        testGoal.Goal_Classification__c = null;
        update testGoal;
        Test.stopTest();
        Goal__c checkGoal = [SELECT Id, Name, Goal_Description__c FROM Goal__c WHERE Name = 'TestGoal' LIMIT 1];
        system.assertEquals (null, checkGoal.Goal_Description__c, 'Goal description should be changed to null');
    }
}