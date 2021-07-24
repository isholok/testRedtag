/**
 * @author Mykhailo Senyuk
 * @date 28/04/2021.

This code is the property of Provisio Partners and copy or reuse is prohibited.
Copyright @2018 Provisio Partners Illinois Ltd. All Rights Reserved.
support@provisiopartners.org
 **/
public with sharing class AccountTriggerHandler {
	
	public static Set<Id> previousUsersIds;
	
	public static void entry() {
		if (Trigger.isBefore) {
			if (Trigger.isUpdate) {
				setPreviousUsersReadAccess((Map<Id, Account>) Trigger.oldMap, (Map<Id, Account>) Trigger.newMap);
			}
		}
		if (Trigger.isAfter) {
			if (Trigger.isUpdate) {
				shareAccount((Map<Id, Account>) Trigger.oldMap, (Map<Id, Account>) Trigger.newMap);
			}
		}
	}
	
	/**
	 * @description get previous shared users
	 */
	private static void setPreviousUsersReadAccess(Map<Id, Account> oldMap, Map<Id, Account> newMap) {
		Set<Id> accountIds = new Set<Id>();
		
		for (Id accountId : newMap.keySet()) {
			if (oldMap.get(accountId).OwnerId != newMap.get(accountId).OwnerId) {
				accountIds.add(accountId);
			}
		}
		
		previousUsersIds = new Set<Id>();
		List<AccountShare> accountShares = [
			SELECT Id, AccountId, Account.Name, AccountAccessLevel, UserOrGroup.Name, ContactAccessLevel
			FROM AccountShare
			WHERE AccountId IN :accountIds
		];
		
		for (AccountShare accountShare : accountShares) {
			previousUsersIds.add(accountShare.UserOrGroupId);
		}
		
	}
	
	/**
	 * @description When Account Owner is changed and Program of a new owner is different, update access to Contact and Account
	 */
	private static void shareAccount(Map<Id, Account> oldMap, Map<Id, Account> newMap) {
		List<SObject> sharedRecords = new List<SObject>();
		Set<Id> usersIds = new Set<Id>();
		
		for (Id accountId : newMap.keySet()) {
			if (oldMap.get(accountId).OwnerId != newMap.get(accountId).OwnerId) {
				usersIds.add(newMap.get(accountId).OwnerId);
			}
		}
		
		List<User> users = [
			SELECT Id, BCFS_Program_List_Values__c
			FROM User
			WHERE Id IN :usersIds
			AND BCFS_Program_List_Values__c != NULL
		];
		if (users.isEmpty()) {
			return ;
		}
		Set<String> programs = new Set<String>();
		
		for (User user : users) {
			programs.addAll(user.BCFS_Program_List_Values__c.split(';'));
		}
		
		String programsIncludes = '(\'' + String.join(new List<String>(programs), '\',\'') + '\')';
		
		List<User> usersForShare = Database.query('' +
			'SELECT Id, BCFS_Program_List_Values__c ' +
			'FROM User ' +
			'WHERE BCFS_Program_List_Values__c INCLUDES ' + programsIncludes
		);
		
		Map<String, Set<Id>> usersIdsByProgramName = new Map<String, Set<Id>>();
		for (User user : usersForShare) {
			for (String programName : user.BCFS_Program_List_Values__c.split(';')) {
				if (!usersIdsByProgramName.containsKey(programName.toLowerCase())) {
					usersIdsByProgramName.put(programName.toLowerCase(), new Set<Id>());
				}
				usersIdsByProgramName.get(programName.toLowerCase()).add(user.Id);
			}
		}
		
		Map<Id, Set<Id>> usersByOwnerId = new Map<Id, Set<Id>>();
		for (User user : users) {
			for (String programName : user.BCFS_Program_List_Values__c.split(';')) {
				if (usersIdsByProgramName.containsKey(programName.toLowerCase())) {
					if (!usersByOwnerId.containsKey(user.Id)) {
						usersByOwnerId.put(user.Id, new Set<Id>());
					}
					usersByOwnerId.get(user.Id).addAll(usersIdsByProgramName.get(programName.toLowerCase()));
				}
			}
		}
		
		for (Id accountId : newMap.keySet()) {
			for (Id userId : previousUsersIds) {
				if (!usersByOwnerId.get(newMap.get(accountId).OwnerId).contains(userId)) {
					sharedRecords.add(
						new AccountShare(
							AccountId = accountId,
							UserOrGroupId = userId,
							AccountAccessLevel = 'Read',
							OpportunityAccessLevel = 'None'
						)
					);
				}
			}
			for (Id userId : usersByOwnerId.get(newMap.get(accountId).OwnerId)) {
				sharedRecords.add(
					new AccountShare(
						AccountId = accountId,
						UserOrGroupId = userId,
						AccountAccessLevel = 'Edit',
						OpportunityAccessLevel = 'None'
					)
				);
			}
			
		}
		
		List<Database.UpsertResult> sr = Database.upsert(sharedRecords, false);
	}
}