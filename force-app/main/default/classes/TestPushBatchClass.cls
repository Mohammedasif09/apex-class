@isTest
public class TestPushBatchClass {

    @isTest
    public static void pushBatchTestMethod(){
        List<Configuration_Queue__c> configurationQueueList = new List<Configuration_Queue__c>();
        
        Configuration__c configuration = new Configuration__c();
        configuration.Name = 'new configuration';
        configuration.Object__c = 'Lead';
        configuration.Skill_Based_Routing__c = true;
        configuration.Model__c = 'MD 404';
        configuration.Skill_Based_Routing_Field__c = 'Name';
        configuration.Skill_Based_Routing_Value__c = 'Performance';
        configuration.Status_Close_Field__c = 'Title';
        configuration.Status_Close_Value__c = 'Aman';
        configuration.Agent_Capacity__c = 12;
		insert configuration;
        
        Configuration_Queue__c configurationQueues = new Configuration_Queue__c();
        configurationQueues.Name = 'base queue';
        configurationQueues.Configuration__c = configuration.Id;
        //configurationQueues.Queue_Id__c = conQueue.Id;        
        insert configurationQueues;
        
        Configuration_Queue__c configurationQueues1 = new Configuration_Queue__c();
        configurationQueues1.Name = 'advance queue';
        configurationQueues1.Configuration__c = configuration.Id;
        //configurationQueues1.Queue_Id__c = conQueue.Id;
        insert configurationQueues1;
        
        configurationQueueList.add(configurationQueues);
        configurationQueueList.add(configurationQueues1);
        
        
        test.startTest();
        PushBatchClass obj = new PushBatchClass(configuration.Object__c, configurationQueueList, configuration.Status_Close_Field__c, configuration.Status_Close_Value__c);
        test.stopTest();     
    }
}