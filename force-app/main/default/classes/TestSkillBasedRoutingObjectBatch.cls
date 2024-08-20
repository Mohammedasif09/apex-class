@isTest
public class TestSkillBasedRoutingObjectBatch {
	
    @isTest    
    public static void skillBasedRoutingObjectBatchTest(){
        /*
        
        Lead newLead = new Lead();
        newLead.FirstName = 'test';
        newLead.LastName = 'Reason';
        newLead.Title = 'test4';
        newLead.Company = 'wipro';
        insert newLead;
        
        Configuration__c configuration = new Configuration__c();
        configuration.Name = 'new configuration';
        configuration.Object__c = 'Lead';
        configuration.Skill_Based_Routing__c = true;
        configuration.Model__c = 'MD 404';
        configuration.Operator__c = 'AND';
        configuration.Agent_Capacity__c = 12;
        configuration.OwnerId = UserInfo.getUserId();
		insert configuration;        
        
        Configuration__c configuration1 = new Configuration__c();
        configuration1.Name = 'old configuration';
        configuration1.Object__c = 'Case';
        configuration1.Skill_Based_Routing__c = false;        
		insert configuration1;
        
        Configuration_Skill_Fields__c configurationFields = new Configuration_Skill_Fields__c();
        //configurationFields.Name = 'Last Name';
       	configurationFields.Field_Name__c = 'LastName';
        configurationFields.Configuration__c = configuration.Id;
        insert configurationFields;
        
        Configuration_Skill__c confSkill = new Configuration_Skill__c();
        confSkill.Skill_Name__c = 'Reason';
        confSkill.Configuration__c = configuration1.Id;
        confSkill.Configuration_Skill_Field__c = configurationFields.Id;
        insert confSkill;
        
        Configuration_Queue__c conQueue = new Configuration_Queue__c();
        conQueue.Name = 'Slave';
        insert conQueue;
        
        Configuration_Queue__c configurationQueues = new Configuration_Queue__c();
        configurationQueues.Name = 'base queue';
        configurationQueues.Configuration__c = configuration.Id;
        configurationQueues.Queue_Id__c = conQueue.Id;
        configurationQueues.OwnerId = UserInfo.getUserId();
        insert configurationQueues;
        
        Configuration_Queue__c configurationQueues1 = new Configuration_Queue__c();
        configurationQueues1.Name = 'advance queue';
        configurationQueues1.Configuration__c = configuration.Id;
        configurationQueues1.Queue_Id__c = conQueue.Id;
        insert configurationQueues1;
        
        List<String> queueIdList = new List<String>();
        queueIdList.add(configurationQueues.Id);
        queueIdList.add(configurationQueues1.Id);
        
        Service_User__c serviceUser = new Service_User__c();
        serviceUser.name = 'test';
        serviceUser.User__c = UserInfo.getUserId();
        insert serviceUser;
        
        Test.startTest();
        SkillBasedRoutingObjectBatch batchObj = new SkillBasedRoutingObjectBatch(configuration, queueIdList);
        Id jobid= Database.executeBatch(batchObj);
        Test.stopTest();
*/
    }
}