@isTest
public class TestAssignAgentBatchClass {
    
    @isTest
    public static void assignAgentBatchTest(){
        
        Configuration__c configuration = new Configuration__c();
        configuration.Name = 'new configuration';
        configuration.Object__c = 'Lead';
        configuration.Skill_Based_Routing__c = true;
        configuration.Model__c = 'MD 404';
        configuration.Skill_Based_Routing_Field__c = 'Name';
        configuration.Skill_Based_Routing_Value__c = 'Performance';
        configuration.Status_Close_Field__c = 'Title';
        configuration.Status_Close_Value__c = 'Aman';
        configuration.Agent_Capacity__c = 10;
		insert configuration;

		Configuration_Queue__c conQueue = new Configuration_Queue__c();
        conQueue.Name = 'Honda';
        conQueue.Configuration__c = configuration.Id;
        //conQueue.Queue_Id__c
        insert conQueue;
        
        Configuration_Queue__c configurationQueues = new Configuration_Queue__c();
        configurationQueues.Name = 'base queue';
        configurationQueues.Configuration__c = configuration.Id;
        configurationQueues.Queue_Id__c = conQueue.Id;
        insert configurationQueues;
        
        Pending_Item_Queue__c pendingItem = new Pending_Item_Queue__c();
        pendingItem.Status__c = 'Pending';
        pendingItem.Configuration_Queue__c = configurationQueues.Id;
        pendingItem.Object__c = 'Lead';
        pendingItem.Record_Id__c = 'mlkaujibiavg76ta';
        insert pendingItem;
        
        //GroupMember groupName = new GroupMember();
        //groupName.GroupId = '00G5g000000OqdxEAC';
        //groupName.UserOrGroupId = UserInfo.getUserId();
        //INSERT groupName;
        /*
        test.startTest();
        AssignAgentBatchClass obj = new AssignAgentBatchClass(configuration, configurationQueues.Queue_Id__c);
        Id jobid= Database.executeBatch(obj);
        test.stopTest();
		*/
    }    

}