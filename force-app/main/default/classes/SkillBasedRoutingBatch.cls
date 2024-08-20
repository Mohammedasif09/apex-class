public class SkillBasedRoutingBatch implements Database.Batchable<sObject>, Database.Stateful {
    public String objectName; 
    Public String skillBasedRoutionField;
    String statusCloseField ;
    String statusCloseValue;
    public double agentCapacity;
    public Database.QueryLocator start(Database.BatchableContext BC) {
        String query =  'SELECT Id, Object__c, Status_Close_Field__c, Status_Close_Value__c, Agent_Capacity__c,Skill_Based_Routing_Field__c, Skill_Based_Routing_Value__c, Skill_Based_Routing__c FROM Configuration__c ' + 
            ' Where Skill_Based_Routing__c = true ' +
            ' And Skill_Based_Routing_Field__c  != Null ' +
            ' And Skill_Based_Routing_Value__c  != Null'  + 
            ' And Status_Close_Field__c  != Null' + 
            ' And 	Status_Close_Value__c != Null';
        System.debug('query:::' + query);
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List<Configuration__c> configurationSkillList) {
        Set<String> SkillRoutionList  = New Set<String>();
        Set<Id> serviceUserIds =  new Set<Id>();
        List<AgentCapacityCount> userAgentCapacityCount =  new List<AgentCapacityCount>();
        Set<Id> setOfUpdateRecordId = new  Set<Id>();
        Set<String> recordIds = new Set<String>();
        Set<String> skillBasedRoutionValueSet =  new  Set<String>(); 
        List<Pending_Item_Queue__c> updateStatusList; 
        System.debug('configurationSkillList :::' + configurationSkillList);
        for(Configuration__c configurationObj : configurationSkillList){
            SkillRoutionList.add( configurationObj.Skill_Based_Routing_Value__c );
            objectName = configurationObj.Object__c;
            skillBasedRoutionField =configurationObj.Skill_Based_Routing_Field__c;
            skillBasedRoutionValueSet.add(configurationObj.Skill_Based_Routing_Value__c); 
            agentCapacity = configurationObj.Agent_Capacity__c;
            statusCloseField = configurationObj.Status_Close_Field__c;
            statusCloseValue = configurationObj.Status_Close_Value__c;   
        }
       
        
        
        List<Service_User_Skill__c> serviceUserSkillList = [SELECT Id, Service_User__r.User__c From Service_User_Skill__c where Skill__r.Skill_Name__c IN:SkillRoutionList];
        
        System.debug('serviceUserSkillList :::' + serviceUserSkillList);
        
        for(Service_User_Skill__c serviceUserSkillObj : serviceUserSkillList){
            serviceUserIds.add(serviceUserSkillObj.Service_User__r.User__c); 
        }
        System.debug('serviceUserIds' + serviceUserIds);
        
        String countUserId =  ' Select count(Id) totalAssignedCases, OwnerId From '  + objectName +  ' WHERE OwnerId IN :serviceUserIds ' +  
            ' Group by OwnerId' +  
            ' HAVING count(Id) < ' + (Integer) agentCapacity  +   
            ' ORDER BY count(Id) ASC ';
        
        System.debug('countUserId  :: ' + countUserId);
        List<AggregateResult>  minUserRecordes = Database.query(countUserId);
        
        System.debug('minUserRecordes::: > ' + minUserRecordes);
        
        
        Map<Id, Integer> ownerIdsMap = new Map<Id, Integer>();
        for(AggregateResult agg : minUserRecordes)  {               
            ownerIdsMap.put((Id)agg.get('OwnerId'), (Integer)agg.get('totalAssignedCases'));   
        }
        system.debug('ownerIdsMap'+ownerIdsMap);
        for(User userObj   :  [Select Id From User Where Id In :serviceUserIds]) {
        	system.debug('userObj'+userObj);
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
            agentCapacityCountObj.userId  = (Id)agg.get('OwnerId');
            agentCapacityCountObj.noOfcases = (Integer)agg.get('totalAssignedCases');
            userAgentCapacityCount.add(agentCapacityCountObj);                   
        } 
        
        System.debug('userAgentCapacityCount' + userAgentCapacityCount);    
        List<String> statusCloseValueList =  statusCloseValue.split('\\r\\n');
        String records = ' Select Id, OwnerId From ' + objectName + ' Where '  + skillBasedRoutionField  + ' =: skillBasedRoutionValueSet' + ' And ' +
                           statusCloseField +   '  IN :  statusCloseValueList';
        system.debug('records'+records);
        List<SObject> sobjList = Database.query(records);
        System.debug('sobjList' + sobjList);
        Integer agentIndex = 0;
        for(Sobject sobj : sobjList){
            String  ownerId;
            integer size = userAgentCapacityCount.size()-1;
            System.debug('userAgentCapacityCount => ' +  size);
            System.debug('agentIndex' +agentIndex);
            if(userAgentCapacityCount.size() == agentIndex) break;
            if(userAgentCapacityCount.get(agentIndex).noOfcases < agentCapacity) {
                ownerId = userAgentCapacityCount.get(agentIndex).userId;
                userAgentCapacityCount.get(agentIndex).noOfcases += 1; 
            }else{
                ownerId = userAgentCapacityCount.get(++agentIndex).userId;
                userAgentCapacityCount.get(agentIndex).noOfcases += 1;  
                agentIndex += 1;
            } 
            setOfUpdateRecordId.add(sObj.Id);
            sObj.put('OwnerId', ownerId);     
        }	
         if(userAgentCapacityCount.size() > 0){
            System.debug('sobjList' + sobjList);
            update sobjList;     
        }   
    }
    
    public void finish(Database.BatchableContext BC) {        
    
    }
    
    public class AgentCapacityCount{
        Id userId;
        Integer noOfcases;
    } 
}