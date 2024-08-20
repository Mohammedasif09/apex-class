@isTest
public class ServiceCloudConfigurationTest {
    
    @testSetup static void setup() {
        // Create Configuration Record
        Configuration__c configuration = new Configuration__c();
        configuration.Name = 'Test Configuration';
        configuration.Object__c = 'case';
        configuration.Skill_Based_Routing__c = false;
        configuration.Model__c = 'MD 303';
        configuration.Operator__c = 'AND';
        configuration.Status_Close_Field__c = 'status';
        configuration.Status_Close_Value__c = 'Working,Escalated';
        configuration.Status__c = 'Active';
        INSERT configuration;
        
        Configuration__c configuration2 = new Configuration__c();
        configuration2.Name = 'Test Configuration2';
        configuration2.Object__c = 'order';
        configuration2.Skill_Based_Routing__c = false;
        configuration2.Model__c = 'MD 304';
        configuration2.Operator__c = 'AND';
        configuration2.Status_Close_Field__c = 'status';
        configuration2.Status_Close_Value__c = 'Working,Escalated';
        configuration2.Status__c = 'Close';
        INSERT configuration2;
        
        Configuration__c configuration3 = new Configuration__c();
        configuration3.Name = 'Test Configuration3';
        configuration3.Object__c = 'case';
        configuration3.Skill_Based_Routing__c = false;
        configuration3.Model__c = 'MD 303';
        configuration3.Operator__c = 'AND';
        configuration3.Status_Close_Field__c = 'status';
        configuration3.Status_Close_Value__c = 'Working,Escalated';
        configuration3.Status__c = 'Close';
        INSERT configuration3;
        
        //Create Skills Records
        Configuration_Skill__c confSkill = new Configuration_Skill__c();
        confSkill.Skill_Name__c = 'Hindi';
        confSkill.Configuration__c = configuration.Id;
        INSERT confSkill;
        
        Configuration_Skill__c confSkill2 = new Configuration_Skill__c();
        confSkill2.Skill_Name__c = '305002';
        confSkill2.Configuration__c = configuration.Id;
        INSERT confSkill2;
        
        Group objG1 = new Group();
        objG1.Name = 'GroupTest1';
        objG1.DeveloperName = 'GroupTest1';
        objG1.Type = 'Queue';
        INSERT objG1;
        
        Group objG2 = new Group();
        objG2.Name = 'GroupTest2';
        objG2.DeveloperName = 'GroupTest2';
        objG2.Type = 'Queue';
        INSERT objG2;
        
        Configuration_Queue__c confQueue = new Configuration_Queue__c();
        confQueue.Name = 'South';
        confQueue.Configuration__c = configuration.Id;
        confQueue.Queue_Id__c = objG1.Id;
        INSERT confQueue;
        
        Configuration_Queue__c confQueue2 = new Configuration_Queue__c();
        confQueue2.Name = 'Ford';
        confQueue2.Queue_Id__c = objG2.Id;
        confQueue2.Configuration__c = configuration.Id;
        INSERT confQueue2;        
        
        Configuration_Skill_Fields__c confField = new Configuration_Skill_Fields__c();
        confField.Configuration__c = configuration.Id;
        confField.Field_Name__c = 'language__c';
        INSERT confField;
        
        Configuration_Skill_Fields__c confField2 = new Configuration_Skill_Fields__c();
        confField2.Configuration__c = configuration.Id;
        confField2.Field_Name__c = 'language__c';
        INSERT confField2;        
        
    }
    
    @isTest
    public static void getAllObjectTast(){
        Map<String,String> allObjectList = ServiceCloudConfiguration.getAllObjList();        
        System.assert(!allObjectList.isEmpty());         
    }  
    
    @isTest
    public static void getFieldsTast(){
        Configuration__c confg = [SELECT Id, Name, Object__c FROM Configuration__c WHERE Name = 'Test Configuration'];
        
		List<ServiceCloudConfiguration.wrapperClassFields> wrapperList = ServiceCloudConfiguration.getFields(confg.Object__c);
        system.assert(wrapperList.size() > 0);        
    }
    
    @isTest
    public static void getPickListvalueTast(){
        Configuration__c getPickListvalue = [SELECT Id, Name, Status_Close_Field__c, Object__c FROM Configuration__c WHERE Name = 'Test Configuration'];
        
        List<String> pickListvalue = ServiceCloudConfiguration.getPickListvalue(getPickListvalue.Object__c, getPickListvalue.Status_Close_Field__c);        
        System.assert(pickListvalue.size() > 0);         
    }
    
    @isTest
    public static void saveConfigurationTast(){
        ServiceCloudConfiguration controller = new ServiceCloudConfiguration();
        Configuration__c configuration = [SELECT Id, Name, Model__c, Skill_Based_Routing__c, Agent_Capacity__c, Status_Close_Value__c, Object__c, Operator__c,
                                          Status_Close_Field__c, Status__c FROM Configuration__c WHERE Name = 'Test Configuration'];
        
        Configuration__c configuration2 = [SELECT Id, Name, Model__c, Skill_Based_Routing__c, Agent_Capacity__c, Status_Close_Value__c, Object__c, Operator__c,
                                          Status_Close_Field__c, Status__c FROM Configuration__c WHERE Name = 'Test Configuration2'];
        
        Configuration__c configuration3 = [SELECT Id, Name, Model__c, Skill_Based_Routing__c, Agent_Capacity__c, Status_Close_Value__c, Object__c, Operator__c,
                                          Status_Close_Field__c, Status__c FROM Configuration__c WHERE Name = 'Test Configuration3'];
        
        List<Configuration_Queue__c> confQueueList = [SELECT Id, Name, Queue_Id__c,Configuration__c FROM Configuration_Queue__c];
        
        List<String> queuesList = new List<String>();        
        for(Configuration_Queue__c conf : confQueueList){
            queuesList.add(conf.Queue_Id__c);            
        }
        
        List<Configuration_Skill__c> confList = [SELECT Id, Skill_Name__c, Configuration__c FROM Configuration_Skill__c];
        
        List<String> skillList = new List<String>();        
        for(Configuration_Skill__c confSkill : confList){
            skillList.add(confSkill.Skill_Name__c);            
        }
        
        List<Configuration_Skill_Fields__c> confFieldList = [SELECT Id, Field_Name__c, Configuration__c FROM Configuration_Skill_Fields__c];
        
        List<String> fieldsList = new List<String>();        
        for(Configuration_Skill_Fields__c conf : confFieldList){
            fieldsList.add(conf.Field_Name__c);            
        }
        
        List<String> saveConfiguration = ServiceCloudConfiguration.saveConfigu(configuration, queuesList, skillList, fieldsList);
        
        System.assert(saveConfiguration.size() > 0);
    }
    
    @isTest
    public static void getQueuesTast(){
        List<Group> queue = ServiceCloudConfiguration.getQueues();
        System.assert(queue.size() > 0);
    }   
    
    @isTest
    public static void getconfigurationTast(){
        List<Configuration__c> configur = ServiceCloudConfiguration.getconfiguration();
        System.assert(configur.size() > 0);
    }
    
    @isTest
    public static void getUserSkillTast(){
    List<User_Skill__c> userSkill = ServiceCloudConfiguration.getUserSkill();
    System.assert(userSkill.size() == 0);
    }
	
    
    @isTest
    public static void getRecordForUpdateTast(){
        Configuration__c confRecord = [SELECT ID From Configuration__c WHERE Model__c = 'MD 304'];
        Configuration__c confDetail = ServiceCloudConfiguration.getRecordForUpdate(confRecord.Id);
        System.assert(!String.isBlank(confDetail.Id));
    }  
    
    @isTest
    public static void getSkillTest(){
        Configuration__c confg = [SELECT Id, Name, Object__c FROM Configuration__c WHERE Name = 'Test Configuration2'];
        ServiceCloudConfiguration.Response skillList = ServiceCloudConfiguration.getSkills(confg.Object__c);
        System.assert(skillList.skillFields.size() > 0);
        
    }
}