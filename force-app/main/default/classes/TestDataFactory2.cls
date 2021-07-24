@isTest
public class TestDataFactory2 {
    @isTest public static Goal__c createGoals () {
        Id ContactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Client').getRecordTypeId();
        Contact contactClient = new Contact (LastName = 'TestContact',
                                             RecordTypeId = ContactRecordTypeID);
        insert contactClient;
        pmdm__Program__c program = new pmdm__Program__c (Name = 'TestProgram',
                                                         pmdm__Status__c = 'Planned',
                                                         Program_Type__c = 'TFC',
                                                         Program_Director__c = UserInfo.getUserId(),
                                                         pmdm__StartDate__c = System.today());
        insert program;
        Id peRecordTypeId = Schema.SObjectType.pmdm__ProgramEngagement__c.getRecordTypeInfosByDeveloperName().get('TFC').getRecordTypeId();
        pmdm__ProgramEngagement__c programEngagement = new pmdm__ProgramEngagement__c (Name = 'TestProgramEng',
                                                                                       pmdm__Contact__c = contactClient.Id,
                                                                                       pmdm__Role__c = 'Client',
                                                                                       pmdm__Stage__c = 'Completed',
                                                                                       pmdm__Program__c = program.Id,
                                                                                       Start_Date__c = System.now(),
                                                                                       Enrollment_Date__c = System.today().addMonths(1),
                                                                                       Level_of_Care_at_Admission__c = 'Moderate'); 
        insert programEngagement;
        
        Service_Plan__c testSp = new Service_Plan__c (Name = 'TestSP',
                                                      Program_Engagement__c = programEngagement.Id,
                                                      Start_Date__c = System.today());
        insert testSp;
        Id GoalRecordTypeId = Schema.SObjectType.Goal__c.getRecordTypeInfosByDeveloperName().get('Post_Release').getRecordTypeId();
        Goal__c goal = new Goal__c(Name = 'TestGoal',
                                   RecordTypeId = GoalRecordTypeId,
                                   Goal_Classification__c = 'Placement Stability and Safety',
                                   Service_Plan__c = testSP.Id,
                                   Start_Date__c = System.today(),
                                   Target_Date__c = System.today().addMonths(1),
                                   Plan_to_Meet_Goal__c = 'test');
        return goal;
    }
    
    @isTest public static PR_Service_Plan_Utility__c createServicePlanUtilityGoalRT () {
        Id SPUtilityId = Schema.SObjectType.PR_Service_Plan_Utility__c.getRecordTypeInfosByDeveloperName().get('Goal').getRecordTypeId(); 	
        PR_Service_Plan_Utility__c testSpUtilityGoal = new PR_Service_Plan_Utility__c (RecordTypeId = SPUtilityId,
                                                                                   Goal_Classification__c = 'Placement Stability and Safety',
                                                                                   Description__c = 'test description Goal');
        return testSpUtilityGoal;
    }
    
    @isTest public static PR_Service_Plan_Utility__c createServicePlanUtilityActionStepRT () {
        Id SPUtilityId = Schema.SObjectType.PR_Service_Plan_Utility__c.getRecordTypeInfosByDeveloperName().get('Action_Step').getRecordTypeId(); 	
        PR_Service_Plan_Utility__c testSPUtilityAS = new PR_Service_Plan_Utility__c (RecordTypeId = SPUtilityId,
                                                                                   Action_Step_Classification__c = 'Communicate the information for person responsible in the event of an emergency',
                                                                                   Description__c = 'test description Action Step');
        return testSPUtilityAS;
    }
    
    @isTest public static Action_Step__c createActionStep () {
        Id ContactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Client').getRecordTypeId();
        Contact contactClient = new Contact (LastName = 'TestContact',
                                             RecordTypeId = ContactRecordTypeID);
        insert contactClient;
        pmdm__Program__c program = new pmdm__Program__c (Name = 'TestProgram',
                                                         pmdm__Status__c = 'Planned',
                                                         Program_Type__c = 'TFC',
                                                         Program_Director__c = UserInfo.getUserId(),
                                                         pmdm__StartDate__c = System.today());
        insert program;
        Id peRecordTypeId = Schema.SObjectType.pmdm__ProgramEngagement__c.getRecordTypeInfosByDeveloperName().get('TFC').getRecordTypeId();
        pmdm__ProgramEngagement__c programEngagement = new pmdm__ProgramEngagement__c (Name = 'TestProgramEng',
                                                                                       pmdm__Contact__c = contactClient.Id,
                                                                                       pmdm__Role__c = 'Client',
                                                                                       pmdm__Stage__c = 'Completed',
                                                                                       pmdm__Program__c = program.Id,
                                                                                       Start_Date__c = System.now(),
                                                                                       Enrollment_Date__c = System.today().addMonths(1),
                                                                                       Level_of_Care_at_Admission__c = 'Moderate'); 
        insert programEngagement;
        Service_Plan__c testSp = new Service_Plan__c (Name = 'TestSP',
                                                      Program_Engagement__c = programEngagement.Id,
                                                      Start_Date__c = System.today());
        insert testSp;
        Id ActionStepTypeId = Schema.SObjectType.Action_Step__c.getRecordTypeInfosByDeveloperName().get('Post_Release').getRecordTypeId();
        Action_Step__c actionS = new Action_Step__c(Name = 'Test Action Step',
                                                    RecordTypeId = ActionStepTypeId,
                                                    Goal_Classification__c = 'Placement Stability and Safety',
                                                    Action_Step_Classification__c = 'Communicate the information for person responsible in the event of an emergency',
                                                    Service_Plan__c = testSP.Id);
        return actionS;
    }
}