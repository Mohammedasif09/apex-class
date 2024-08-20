@isTest
public class configurationControllerTriggerTest {
    
    @testSetup static void getConfigurationSetup(){

		Lead newLead = new Lead();
        newLead.FirstName = 'test';
        newLead.LastName = 'test2';
        newLead.Title = 'test4';
        newLead.Company = 'Capgimini';
        insert newLead;       
        
        Configuration__c configuration = new Configuration__c();
        configuration.Name = 'new configuration';
        configuration.Object__c = 'Case';
        configuration.Skill_Based_Routing__c = true;
        configuration.Model__c = 'MD 404';
        configuration.Status__c = 'close';
        insert configuration;
        
        Configuration__c configuration1 = new Configuration__c();
        configuration1.Name = 'old configuration';
        configuration1.Object__c = 'Lead';
        configuration1.Skill_Based_Routing__c = false;
        configuration1.Status__c = 'open';
        insert configuration1;
        
        Configuration__c configuration3 = new Configuration__c();
        configuration3.Id = configuration.Id;
        configuration3.Name = 'configuration test';
        configuration3.Object__c = 'Order';
        configuration3.Skill_Based_Routing__c = true;
        configuration3.Model__c = 'MD 404';
        update configuration3;
          
        
    }
    
    @isTest
    public static void configurationTriggerTest(){
        
        List<Configuration__c> configurationList = new List<Configuration__c>();
        
        Configuration__c configuration1 = [SELECT Id, Name, Status_Close_Field__c, Object__c FROM Configuration__c WHERE Name = 'new configuration'];
        
        Configuration__c configuration2 = [SELECT Id, Name, Status_Close_Field__c, Object__c FROM Configuration__c WHERE Name = 'old configuration'];
        
        configurationList.add(configuration1);
        configurationList.add(configuration2);
        
        //String saveConfigure = configurationController.saveConfiguration(confList);        
        //configurationController.saveConfiguration(null);
        
        system.assert(configurationList.size()>0);
        
    }    
    
    @isTest
    public static void configurationTest(){
        Configuration confObj = new Configuration();
        confObj.getTotalConfiguration();        
    }
    
    @isTest
    public static void executeTest(){
        
        Lead newLead = new Lead();
        newLead.FirstName = 'test';
        newLead.LastName = 'test2';
        newLead.Title = 'test4';
        newLead.OwnerId = userinfo.getUserId();
        newLead.Company = 'Capgimini';
        insert newLead;
        
        
       /* List<sObject> scope = new List<sObject>();
        scope.add(newLead);
        scope.add(newCase);*/
        
        Configuration_Queue__c conQueue = new Configuration_Queue__c();
        conQueue.Name = 'Suzuki';
        insert conQueue;
        
        Configuration__c configuration = new Configuration__c();
        configuration.Name = 'new configuration';
        configuration.Object__c = 'Case';
        configuration.Skill_Based_Routing__c = false;
        configuration.Status_Close_Field__c = 'Status';
        configuration.Status_Close_Value__c = 'Completed';
        configuration.Model__c = 'MD 404';
        configuration.Status__c = 'active';
        configuration.Agent_Capacity__c = 5;
        insert configuration;
        
        Configuration_Queue__c configurationQueues = new Configuration_Queue__c();
        configurationQueues.Name = 'base queue';
        configurationQueues.Configuration__c = configuration.Id;
        configurationQueues.Queue_Id__c = userinfo.getUserId();        
        insert configurationQueues;
        
        Pending_Item_Queue__c pendingItem = new Pending_Item_Queue__c();
        pendingItem.Status__c = 'Pending';
        pendingItem.Configuration_Queue__c = configurationQueues.Id;
        pendingItem.Object__c = 'Lead';
        pendingItem.Record_Id__c = 'mlkaujibiavg76ta';
        insert pendingItem;
        
        Service_User__c serviceUserRecord = new Service_User__c();
        serviceUserRecord.Available_Status__c = 'Online';
        serviceUserRecord.User__c = userinfo.getUserId();
        serviceUserRecord.Name = 'service user test';
        insert serviceUserRecord;
        
		//  List<Configuration_Queue__c> configureList = new List<Configuration_Queue__c>();
        // configureList.add(conQueue);
        //  configureList.add(configurationQueues);
        //  Insert configureList;
        
        Case newCase = new Case();
        newCase.Origin = 'Phone';
        newCase.Status = 'Working';
        newCase.OwnerId = userinfo.getUserId();
        insert newCase;
        
        /*
        GroupMember grpMember = new GroupMember();
        grpMember.GroupId = '00G5g000000PB31EAG';
        insert grpMember;
		*/
        
        Test.StartTest();
        ConfigurationShedulableClass confObjSchedule = new ConfigurationShedulableClass();        
        //confObjSchedule.execute();
        Test.stopTest(); 
    }
    /*
    @isTest
    public static void executePushBatchTest(){
        
        Configuration_Queue__c conQueue = new Configuration_Queue__c();
        conQueue.Name = 'Suzuki';
        insert conQueue;
        
        Configuration__c configuration = new Configuration__c();
        configuration.Name = 'new configuration';
        configuration.Object__c = 'Case';
        configuration.Skill_Based_Routing__c = true;
        configuration.Status_Close_Field__c = 'Status';
        configuration.Status_Close_Value__c = 'Completed';
        configuration.Model__c = 'MD 404';
        configuration.Status__c = 'close';
        insert configuration;
        
        Configuration_Queue__c configurationQueues = new Configuration_Queue__c();
        configurationQueues.Name = 'base queue';
        configurationQueues.Configuration__c = configuration.Id;
        configurationQueues.Queue_Id__c = conQueue.Id;        
        insert configurationQueues;
        
        List<Configuration_Queue__c> configureList = new List<Configuration_Queue__c>();
        configureList.add(conQueue);
        configureList.add(configurationQueues);
        
        PushBatchClass pushObject = new PushBatchClass(configuration.Object__c,configureList,configuration.Status_Close_Field__c,configuration.Status_Close_Value__c);
        Id jobid= Database.executeBatch(pushObject);
        
    }
	*/
    
    /*
        @isTest
        public static void totalConfigurationTest(){
        	Configuration.getTotalConfiguration();
        	system.assert(noOfConfiguration > 0);
        }
	*/
    
}