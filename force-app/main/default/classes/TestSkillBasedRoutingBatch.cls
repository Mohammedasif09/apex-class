@isTest
public class TestSkillBasedRoutingBatch {
    
    @testSetup static void skillBasedRoutingRecords() { 
        /*
        
		Lead newLead = new Lead();
        newLead.FirstName = 'test';
        newLead.LastName = 'test2';
        newLead.Title = 'test4';
        newLead.Company = 'Capgimini';
        insert newLead;
        
        Configuration__c configuration = new Configuration__c();
        configuration.Name = 'new configuration';
        configuration.Object__c = newLead.Id;
        configuration.Skill_Based_Routing__c = true;
        configuration.Model__c = 'MD 404';
        configuration.Skill_Based_Routing_Field__c = 'Title';
        configuration.Skill_Based_Routing_Value__c = 'Performance';
        configuration.Status_Close_Field__c = 'Title';
        configuration.Status_Close_Value__c = 'Aman';
        configuration.Agent_Capacity__c = 12;
		insert configuration;        
        
        
        Configuration_Skill_Fields__c configurationFields = new Configuration_Skill_Fields__c();
        //configurationFields.Name = 'Last Name';
       	configurationFields.Field_Name__c = 'FirstName';
        configurationFields.Configuration__c = configuration.Id;
        insert configurationFields;
        
        Configuration_Skill__c confSkill = new Configuration_Skill__c();
        confSkill.Skill_Name__c = 'Reason';
        confSkill.Configuration__c = configuration.Id;
        confSkill.Configuration_Skill_Field__c = configurationFields.Id;
        insert confSkill;
        
        Configuration_Queue__c conQueue = new Configuration_Queue__c();
        conQueue.Name = 'Suzuki';
        insert conQueue;
        
        Configuration_Queue__c configurationQueues = new Configuration_Queue__c();
        configurationQueues.Name = 'base queue';
        configurationQueues.Configuration__c = configuration.Id;
        configurationQueues.Queue_Id__c = conQueue.Id;        
        insert configurationQueues;
        
        Configuration_Queue__c configurationQueues1 = new Configuration_Queue__c();
        configurationQueues1.Name = 'advance queue';
        configurationQueues1.Configuration__c = configuration.Id;
        configurationQueues1.Queue_Id__c = conQueue.Id;
        insert configurationQueues1;
        
        List<String> queueIdList = new List<String>();
        queueIdList.add(configurationQueues.Id);
        queueIdList.add(configurationQueues1.Id);
        
		//Skill skills = new Skill();
		//skills.DeveloperName = 'PHP';
		//skills.Description = 'this is programming language';
		//skills.MasterLabel =         
        //insert skills;
        User_Skill__c userSkill = new User_Skill__c();
        userSkill.Skill_Name__c = 'Performance';
        insert userSkill;
        
        User_Skill__c userSkill2 = new User_Skill__c();
        userSkill2.Id = userSkill.Id;
        userSkill2.Skill_Name__c = 'MobilePhone';
        Update userSkill2;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt', Email='testuser102service@gmail.com', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='testuser102service@gmail.com');
        insert u;
        
        Service_User__c serviceUser = new Service_User__c();
        serviceUser.name = 'test';
        serviceUser.User__c = UserInfo.getUserId();
        insert serviceUser;
        
        Service_User__c serviceUser2 = new Service_User__c();
        serviceUser2.name = 'test case';
        insert serviceUser2;
        
       //Skill maintSkill = [SELECT Id, MasterLabel FROM Skill WHERE MasterLabel LIKE 'English' Limit 1];
        
        Service_User_Skill__c serviceUserSkill = new Service_User_Skill__c();
        serviceUserSkill.Service_User__c = serviceUser.Id;
        serviceUserSkill.Skill_Level__c = 3;
        serviceUserSkill.Skill__c = userSkill.Id;
        serviceUserSkill.Start_Date__c = date.today()-5;
        Insert serviceUserSkill;
        
        List<Service_User_Skill__c> serviceUserSkillList = new List<Service_User_Skill__c>();
        serviceUserSkillList.add(serviceUserSkill);
        
        Service_User_Skill__c serviceUserSkillUpdate = new Service_User_Skill__c();
        serviceUserSkillUpdate.Id = serviceUserSkill.Id;
        serviceUserSkill.Service_User__c = serviceUser2.Id;
        serviceUserSkill.Skill__c = userSkill2.Id;
        serviceUserSkill.End_Date__c = date.today();
        Update serviceUserSkillUpdate;
        
	}

    @isTest
    public static void SkillBasedRoutingBatchCall(){
        
		Test.startTest();
        SkillBasedRoutingBatch batchObj = new SkillBasedRoutingBatch();
        Id jobid= Database.executeBatch(batchObj);
        Test.stopTest();
        */
    }
}