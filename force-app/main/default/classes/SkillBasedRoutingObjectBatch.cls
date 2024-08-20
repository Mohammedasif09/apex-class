public class SkillBasedRoutingObjectBatch implements Database.Batchable<sObject>, Database.Stateful {
    
    Configuration__c configuration;
    //@ configurationSkillFields : 
    public List<Configuration_Skill_Fields__c> configurationSkillFields;
    public Map<String,List<String>> FieldsSkillsList;
    //@ setOnlinceUser : set of Online User Skill Name
    public List<String> setOnlinceUser;
    //@ fields : add a skill base fields 
    public String fields = '';
    //@ fieldsAndValus : add a skill base fields and skill 
    Public String fieldsAndValus = '';
    //@ objectName : Add a object Name 
    public String objectName = '';
    //@ operator : Add a operator values
    public String operator = '' ; 
    //@ queueIdList : set of queue Id 
    public Set<String> queueIdList;
    //@ ConfigurationId : add a configuration Id
    public Id ConfigurationId;
    double agentCapacity;
    
    public String statusCloseField;
    
    public String statusCloseValue;
    
    /**
    * @constructor 
    * @param {Object}  Configuration              : the object of configuration 
    * @param {List<string>} Configuration Queue   : the list of configuration queues
    */
    public SkillBasedRoutingObjectBatch(Configuration__c configuration){ // ,List<String> queueIdLis){
        configurationSkillFields =  new  List<Configuration_Skill_Fields__c>();
         FieldsSkillsList  = new Map<String,List<String>>();
         ConfigurationId = configuration.Id;
         statusCloseField = configuration.Status_Close_Field__c;
         statusCloseValue = configuration.Status_Close_Value__c;    
         this.queueIdList = new Set<String>();
         setOnlinceUser = new List<String>();
         List<String> queueIdListString = new List<String>();
        List<Configuration_Queue__c> configrationQueueList = ServiceQueryUtils.getConfigurationQueue(ConfigurationId);
        for(Configuration_Queue__c configurationQueueList :  configrationQueueList){
            queueIdListString.add(configurationQueueList.Queue_Id__c);
        }
       filterRecords(configuration, queueIdListString);      
    } 
     /**
     * @description : 
     * @return      : this is return Object Records of Skill bsae Routing   
	*/
    public Database.QueryLocator start(Database.BatchableContext BC) {
        //get Object Records of Skill bsae Routing   
        System.debug('fields :::: > ' + fields);
        System.debug('fieldsAndValus :::::>' + fieldsAndValus);
         List<String> statusCloseValueList =  statusCloseValue.split(',');
        System.debug('statusCloseValueList'  + statusCloseValueList);
        String query ='SELECT '+ fields + ' Id ,OwnerId ,'+ statusCloseField  + ' From ' +   objectName + ' Where ' + ' ( '  + fieldsAndValus + ')' +  'AND OwnerId IN:queueIdList' + ' AND ' + statusCloseField +   ' Not IN :  statusCloseValueList';
        System.debug('minUserRecordes <===> ' + query);
        //Database.QueryLocator q = Database.getQueryLocator(query);
        //system.debug('queue'+q); 
        return Database.getQueryLocator(query);    
    }
    
    /**
     * @description: this assign a ownerId base of skill base routing 
	 * @param {sObjectList} sObject : this is object records base on Skill base routing: 
	*/
    public void execute(Database.BatchableContext BC, List<sObject> sObjectList) {
        System.debug('ExecuteData:::: > ' + sObjectList);       
       //List<User_Skill__c> userSkillList = new List<User_Skill__c>();
       List<Service_User_Skill__c> serviceUserSkillList = new List<Service_User_Skill__c>();
       List<AgentCapacityCount> userAgentCapacityCount =  new List<AgentCapacityCount>();
        // Set Of UserId 
       Set<Id> userIds =  new Set<Id>(); 
       
        // get service user available status 'Online' 
        serviceUserSkillList  =ServiceQueryUtils.serviceUserSkillList();
        System.debug('serviceUserSkillList ===>' + serviceUserSkillList);
        if(serviceUserSkillList.size() > 0){
            for(Service_User_Skill__c serviceUserSkill : serviceUserSkillList){ 
                    userIds.add(serviceUserSkill.Service_User__r.User__c); 
            } 
        }
        System.debug('userIds :::: >' + userIds);
        List<sObject> updateSobjectList =  new  List<sObject>();
        System.debug('userIds ===>' + userIds);
        //  get Object Records Count base on OwnerId  And count(Id) < of agentCapacity and arrange assending records base of count(Id)
        String countUserId = ' Select count(Id) totalAssignedCases, OwnerId From '  + objectName +  ' WHERE OwnerId IN : userIds' +
                             ' Group by OwnerId' +   
                             ' ORDER BY count(Id) ASC';
      
        
        System.debug('countUserId  :: ' + countUserId);
        List<AggregateResult>  minUserRecordes = Database.query(countUserId);
        
        System.debug('minUserRecordes ====> ' + minUserRecordes);
        
        Map<Id, Integer> ownerIdsMap = new Map<Id, Integer>();
        for(AggregateResult agg : minUserRecordes)  {               
            ownerIdsMap.put((Id)agg.get('OwnerId'), (Integer)agg.get('totalAssignedCases'));   
        }
        
        
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
            if((Integer)agg.get('totalAssignedCases') < agentCapacity){
                AgentCapacityCount agentCapacityCountObj =  new AgentCapacityCount();  
                agentCapacityCountObj.userId  = (Id)agg.get('OwnerId');
                agentCapacityCountObj.noOfcases = (Integer)agg.get('totalAssignedCases');	
                userAgentCapacityCount.add(agentCapacityCountObj);   
            }                
        }
        System.debug('userAgentCapacityCount ::::' + userAgentCapacityCount);
        Integer agentIndex = 0;
        System.debug('sObjectList Before + ' + sObjectList);
        for(Sobject sobj : sObjectList){
            String  ownerId;
            integer size = userAgentCapacityCount.size()-1;
            System.debug('userAgentCapacityCount => ' +  size);
            System.debug('agentIndex' +agentIndex);
            if(userAgentCapacityCount.size()-1 < agentIndex) break;
            if(userAgentCapacityCount.get(agentIndex).noOfcases < agentCapacity) {
                ownerId = userAgentCapacityCount.get(agentIndex).userId;
                //System.debug('ownerId :::' + ownerId );
                userAgentCapacityCount.get(agentIndex).noOfcases += 1;
                 sObj.put('OwnerId', ownerId);
                //System.debug('noOfcases :::' +  userAgentCapacityCount.get(agentIndex).noOfcases);
   
            }else if(userAgentCapacityCount.size() > 1){
                ownerId = userAgentCapacityCount.get(++agentIndex).userId;
                userAgentCapacityCount.get(agentIndex).noOfcases += 1;  
                //agentIndex += 1;
                 sObj.put('OwnerId', ownerId);
                System.debug('agentIndex else ::: ' + agentIndex);
            } 
             //sObj.put('OwnerId', ownerId);   
        }	
        
        if(userAgentCapacityCount.size() > 0){
            System.debug('sObjectList After list' + sObjectList);
            update sObjectList;     
        }   
    } 
    
    public void finish(Database.BatchableContext BC) {        
        
    }
      
    /**
       * @description: this is carate a string base on skill and operator
       * @param {Object}  Configuration              : the object of configuration 
       * @param {List<string>} Configuration Queue   : the list of configuration queues 
	*/
    private void filterRecords(Configuration__c configuration, List<String> queueIdList){
        this.configuration =  configuration ;
        ConfigurationId = this.configuration.Id;
        objectName = configuration.Object__c;
        operator  = configuration.Operator__c; 
        System.debug('ConfigurationId :::' +  ConfigurationId);
        System.debug('operator  :::: >' + operator );
        agentCapacity = configuration.Agent_Capacity__c;
        
        List<Configuration_Skill__c> configurationSkillList = new  List<Configuration_Skill__c>();
        
        for(String queueIdObj : queueIdList){
            this.queueIdList.add(queueIdObj);
        }
        
        configurationSkillFields = ServiceQueryUtils.ConfigurationSkillFields(ConfigurationId);
        configurationSkillList   = ServiceQueryUtils.configurationSkill(ConfigurationId);
        
        
        System.debug('configurationSkillFields :::>' + configurationSkillFields);
        System.debug('configurationSkillList :::>' + configurationSkillList);
        
        
        for(Configuration_Skill_Fields__c configurationSkillFieldsObj :  configurationSkillFields) {           
            fieldsAndValus += '( '; 
            for(Configuration_Skill__c  configurationSkillObj : configurationSkillList){
                System.debug(':::::: >' + configurationSkillFieldsObj.Field_Name__c);
                fieldsAndValus += configurationSkillFieldsObj.Field_Name__c   + ' = ' + '\'' +  configurationSkillObj.Skill_Name__c  +  '\'' + ' OR ' ;
            }
             fieldsAndValus=  fieldsAndValus.subString(0, fieldsAndValus.length()-3);
            fieldsAndValus += ')' +  (operator.equals('AND') ? ' AND ' : ' OR ');
            System.debug('fieldsAndValus ::::>' + fieldsAndValus);
             fields += configurationSkillFieldsObj.Field_Name__c + ',';
        } 
        fieldsAndValus=  fieldsAndValus.subString(0, fieldsAndValus.length()-4); 
        System.debug('fields :::: > ' + fields);
        System.debug('fieldsAndValus :::::>' + fieldsAndValus);
    }
    
    public class AgentCapacityCount{
        Id userId;
        Integer noOfcases;    
    }     
}