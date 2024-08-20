public class ConfigurationShedulableClass implements Schedulable  {
    public void execute(SchedulableContext sc ){ 
        System.debug('ConfigurationShedulableClass ');
        System.debug('Schedulable.execute called');
        List<Configuration__c>   ConfigurationList = [Select Id, Object__c , Status__c, Status_Close_Field__c , Status_Close_Value__c ,Skill_Based_Routing__c,Operator__c,Agent_Capacity__c,
                                                      (Select Id ,Name ,Queue_Id__c, OwnerId From Configuration_Queues__r where Queue_Id__c != null)
                                                       From Configuration__c where Status__c ='active'];
        System.debug('ConfigurationShedulableClass ConfigurationList' + ConfigurationList);
        for(Configuration__c conObj : ConfigurationList){
            if(conObj.Skill_Based_Routing__c){
                Database.executeBatch(new SkillBasedRoutingObjectBatch(conObj),10); 
            }
            else{
                System.debug('ConfigurationList => ' + ConfigurationList);
                Database.executeBatch(new PushBatchClass(conObj.Object__c, conObj.Configuration_Queues__r, conObj.Status_Close_Field__c,conObj.Status_Close_Value__c),200);   
            }            
        }
    }         
}


/* System.debug('ConfigurationShedulableClass ::::' + configurationNewList.size());
        List<Configuration__c> configurationActiveStatusList = new List<Configuration__c>();
        for(Configuration__c configurationObj : configurationNewList){
            if(configurationObj.Status__c.equals('Active')){
                configurationActiveStatusList.add(configurationObj);
            }
        }
        
        System.debug('configurationActiveStatusList :::: '   + configurationActiveStatusList);
        for(Configuration__c conObj : configurationActiveStatusList){
            if(conObj.Skill_Based_Routing__c){
                System.debug('Coll batch class ');
                 Database.executeBatch(new SkillBasedRoutingObjectBatch(conObj),10); 
            }
           // else{
             //  Database.executeBatch(new PushBatchClass(conObj.Object__c, conObj.Configuration_Queues__r, conObj.Status_Close_Field__c,conObj.Status_Close_Value__c),200); 
            //}     
        }
        */