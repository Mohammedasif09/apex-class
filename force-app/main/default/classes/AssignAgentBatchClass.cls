public class AssignAgentBatchClass implements Database.Batchable<sObject>, Database.Stateful  {
    List<Pending_Item_Queue__c> pendingTtemQueueList = new List<Pending_Item_Queue__c>();
    Configuration__c configuration;
    List<String> queueIdListString = new List<String>(); 
    public Id queueId;
    double agentCapacity;
    public AssignAgentBatchClass(Configuration__c configuration){
        this.configuration =  configuration ;
        //this.queueId = queueId;
        System.debug('queueId AssignAgentBatchClass ' + queueId);
        agentCapacity = configuration.Agent_Capacity__c;
        //List<String> queueIdListString = new List<String>();
        List<Configuration_Queue__c> configrationQueueList = ServiceQueryUtils.getConfigurationQueue(configuration.Id);
        for(Configuration_Queue__c configurationQueueList :  configrationQueueList){
            queueIdListString.add(configurationQueueList.Queue_Id__c);
        }
    } 
    
    public Database.QueryLocator start(Database.BatchableContext BC) {
        System.debug('coll of start AssignAgentBatchClass');
        
        String query = 'Select Id, Status__c ,Record_Id__c , Configuration_Queue__r.Queue_Id__c ,Object__c From  Pending_Item_Queue__c  ' + 
            ' where Status__c =\'Pending\' and Object__c = '  +  '\'' + configuration.Object__c + '\'' + 
            ' AND Configuration_Queue__r.Queue_Id__c IN : queueIdListString';
        	// + '\'' + queueId + '\'' ;
        System.debug('query :::' + query);
        
        return Database.getQueryLocator(query); 
    }
    public void execute(Database.BatchableContext BC, List<Pending_Item_Queue__c> pendingQueryRecord) {
        System.debug('pendingQueryRecord' + pendingQueryRecord);
        System.debug('queueIdListString' + queueIdListString);
        Set<Id> onlineUser = new Set<Id>();
        List<AgentCapacityCount> userAgentCapacityCount =  new List<AgentCapacityCount>(); 
        List<Pending_Item_Queue__c> updateStatusList; 
        Set<Id> setOfUpdateRecordId = new  Set<Id>();
        Set<Id> userIds = new Set<Id>();
        Set<Id> queueUserIds = new Set<Id>();
        Set<Id> queueIds = new Set<Id>();
        Set<String> recordIds = new Set<String>();
        String objectName;
        for(Pending_Item_Queue__c pendingItemQueue : pendingQueryRecord){
            recordIds.add(pendingItemQueue.Record_Id__c);
            objectName = pendingItemQueue.Object__c;
        }        
        
        for(GroupMember groupMember : [Select UserOrGroupId , GroupId  From GroupMember where  GroupId IN :queueIdListString]){
            queueUserIds.add(groupMember.UserOrGroupId);
        } 
        System.debug('queueUserIds' + queueUserIds);
        
        for(Service_User__c serviceUserObj : [SELECT Id, User__c FROM Service_User__c Where Available_Status__c ='Online']){
            userIds.add(serviceUserObj.User__c);
        }
        System.debug('Online User ' + userIds);
        
        String countUserId =  ' Select count(Id) totalAssignedCases, OwnerId From '  + objectName +  ' WHERE Owner.Type != \'Queue\'' +  
                              ' AND OwnerId IN : userIds'  + 
                              ' Group by OwnerId' +      
                              ' ORDER BY count(Id) ASC ';
        System.debug('countUserId' + countUserId);
        List<AggregateResult>  minUserRecordes  = Database.query(countUserId);
        System.debug('minUserRecordes' + minUserRecordes);
        String query = ' Select Id, OwnerId From ' + objectName + ' Where Id IN : recordIds';
        
        System.debug('query' + query);
        List<SObject> sobjList = Database.query(query);
        System.debug('sobjList' + sobjList);
        Map<Id, Integer> ownerIdsMap = new Map<Id, Integer>();
        
        
        for(AggregateResult agg : minUserRecordes)  {                
            ownerIdsMap.put((Id)agg.get('OwnerId'), (Integer)agg.get('totalAssignedCases'));
            
        }
        System.debug('ownerIdsMap :::' +ownerIdsMap );
        for(User userObj   :  [Select Id From User Where Id In :userIds]) {
            if(ownerIdsMap.get(userObj.Id) == null){
                AgentCapacityCount agentCapacityCount  = new AgentCapacityCount();  
                agentCapacityCount.userId = userObj.Id;
                agentCapacityCount.noOfcases = 0;
                userAgentCapacityCount.add(agentCapacityCount);
            } 
        }
        System.debug('userAgentCapacityCount' + userAgentCapacityCount);
        for(AggregateResult agg : minUserRecordes){
            AgentCapacityCount agentCapacityCountObj =  new AgentCapacityCount();  
            agentCapacityCountObj.userId  = (Id) agg.get('OwnerId');
            agentCapacityCountObj.noOfcases = (Integer)agg.get('totalAssignedCases');
            userAgentCapacityCount.add(agentCapacityCountObj);                   
        }
        
        System.debug('userAgentCapacityCount' + userAgentCapacityCount); 
        Integer agentIndex = 0;
        for(SObject sObj :  sobjList){
            String  ownerId;
            integer size = userAgentCapacityCount.size()-1;
            System.debug('userAgentCapacityCount => ' +  size);
            System.debug('agentIndex' +agentIndex);
            if(userAgentCapacityCount.size()-1 < agentIndex) break;
            if(userAgentCapacityCount.get(agentIndex).noOfcases < agentCapacity) {
                ownerId = userAgentCapacityCount.get(agentIndex).userId;
                userAgentCapacityCount.get(agentIndex).noOfcases += 1; 
                setOfUpdateRecordId.add(sObj.Id);
                sObj.put('OwnerId', ownerId);
            }else if(userAgentCapacityCount.size() > 1){
                ownerId = userAgentCapacityCount.get(++agentIndex).userId;
                userAgentCapacityCount.get(agentIndex).noOfcases += 1;  
                agentIndex += 1;
                setOfUpdateRecordId.add(sObj.Id);
                sObj.put('OwnerId', ownerId);
            } 
            //setOfUpdateRecordId.add(sObj.Id);
            //sObj.put('OwnerId', ownerId);   
        }
        System.debug('setOfUpdateRecordId' + setOfUpdateRecordId);
        System.debug('userAgentCapacityCount'  + userAgentCapacityCount);	
        
        if(userAgentCapacityCount.size() > 0){
            System.debug('sobjList' + sobjList);
            update sobjList;     
        }
        updateStatusList = [Select Id , Record_Id__c ,OwnerId From Pending_Item_Queue__c Where Record_Id__c IN : setOfUpdateRecordId];
        System.debug('updateStatusList' + updateStatusList);
        for(Pending_Item_Queue__c pendingItemQueue : updateStatusList){
            pendingItemQueue.Status__c = 'Assigned';
        	}
        System.debug('updateStatusList' + updateStatusList);
        if(updateStatusList.size() > 0) {
            Update updateStatusList;
        }    
    }      
    public void finish(Database.BatchableContext BC) {        
    }
    
    public class AgentCapacityCount{
        Id userId;
        Integer noOfcases;
    } 
    
}