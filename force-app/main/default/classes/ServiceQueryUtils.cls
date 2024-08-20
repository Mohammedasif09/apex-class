public class ServiceQueryUtils {
    
    public static List<Configuration__c> getConfigurations(){
        
          return [SELECT Id, Object__c, Agent_Capacity__c , Status__c ,Status_Close_Field__c, Status_Close_Value__c ,Skill_Based_Routing__c,Operator__c,	 
                  (SELECT Id, Queue_Id__c FROM Configuration_Queues__r) FROM Configuration__c where Status__c = 'Active'
                   And  Status_Close_Field__c != Null And   Status_Close_Value__c != Null ];
    }
    public static List<Skill_Based_Routing__c>  getSkillBasedroution(){
        
        return [Select Id,Name ,  Field__c , Field_Value__c ,Object__c FROM Skill_Based_Routing__c ];
    }
    
    public static List<Configuration_Skill_Fields__c> ConfigurationSkillFields(Id ConfigurationId){
        System.debug('ConfigurationId ::::>' + ConfigurationId);
        return [SELECT Id ,Field_Name__c  ,Configuration__c  from Configuration_Skill_Fields__c where Configuration__C =:ConfigurationId];
        
    }
    
    public static List<Configuration_Skill__c> configurationSkill(Id ConfigurationId){
        
       return [SELECT Id, Name, Configuration__c, Skill_Name__c, Skill_Id__c FROM Configuration_Skill__c where Configuration__C =:ConfigurationId];
       
    }
    
    // Send service user Skill available status   
    public static List<Service_User_Skill__c> serviceUserSkillList(){
        return [SELECT Id, Service_User__r.User__c , Service_User__r.Available_Status__c , Skill__r.Skill_Name__c From Service_User_Skill__c
                where Service_User__r.Available_Status__c ='Online'];
    }
  
    public static List<Group> getQueues(){
      return [select Name from Group where Type = 'Queue'];  
    }
    
    public static List<User_Skill__c> getUserSkill(){
         return [Select Skill_Name__c From User_Skill__c];
    } 
    
    public static List<Pending_Item_Queue__C>  getpendingItemQueue(String configurationObject){
        return  [SELECT Status__c, Id, Record_Id__c, Object__c, Configuration_Queue__c FROM Pending_Item_Queue__C where 
                 Status__c ='Pending' AND Object__c =:configurationObject];
    }
    
    public static List<Configuration_Queue__C> getConfigurationQueue(String ConfigurationId){
       return [SELECT Id, Name, Queue_Id__c, Configuration__c FROM Configuration_Queue__C where Configuration__c =:ConfigurationId];
        
    }
}