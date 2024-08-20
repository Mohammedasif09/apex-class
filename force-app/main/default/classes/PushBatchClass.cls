public class PushBatchClass implements Database.Batchable<sObject>, Database.Stateful {
   public final String configurationObject; //pushBatchClass// objectName
    Map<Id, Id> queueIdMap;
    Set<Id> setOfQueueIds;
    Set<Id> pendingItemQueueIds;
    String statusCloseField ;
    String statusCloseValue;
    
    List<Configuration_Queue__c> configurationQueueList = new List<Configuration_Queue__c>();
    public  PushBatchClass(String configuObject,List<Configuration_Queue__c> newConfigQueues, String statusCloseField, String statusCloseValue){
        configurationObject = configuObject;
        configurationQueueList = newConfigQueues;
        this.statusCloseField = statusCloseField;
        this.statusCloseValue = statusCloseValue;
        setOfQueueIds = new Set<Id>();
        queueIdMap = new Map<Id, Id>();
        pendingItemQueueIds =  new  Set<Id>();
    }
    public Database.QueryLocator start(Database.BatchableContext BC) {
        for(Configuration_Queue__c  ConfigurationQueue : configurationQueueList){
            //setOfQueueIds.add(ConfigurationQueue.Queue_Id__c);
            queueIdMap.put(ConfigurationQueue.Queue_Id__c, ConfigurationQueue.Id);
            System.debug('setOfQueueIds' + setOfQueueIds);
            System.debug('setOfQueueIds' + statusCloseValue);
            }
        
        List<Pending_Item_Queue__C>   pendingItemQueueList = ServiceQueryUtils.getpendingItemQueue(configurationObject);
        System.debug('pendingItemQueueList ::::' + pendingItemQueueList);
        for(Pending_Item_Queue__C  pendingItemQueueObj : pendingItemQueueList){
            pendingItemQueueIds.add(pendingItemQueueObj.Record_Id__c);
        }
        System.debug('pendingItemQueueIds :::' +pendingItemQueueIds);
        setOfQueueIds = queueIdMap.keySet();
        System.debug('setOfQueueIds'+setOfQueueIds);
        //List<String> statusCloseValueList =  statusCloseValue.split('\\r\\n');
        List<String> statusCloseValueList =  statusCloseValue.split(',');
        System.debug('statusCloseValueList ' + statusCloseValueList);
        String query = 'SELECT Id, ' + statusCloseField +  ' ,OwnerId From '+ configurationObject  + ' where OwnerId IN: setOfQueueIds  '+ ' And ' +  
            			statusCloseField +   ' Not IN :  statusCloseValueList ' + ' And Id Not IN :  pendingItemQueueIds' ; 
        System.debug('query' + query);
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List<sObject> scope) {
        System.debug('hiii');
        System.debug('Scope' + scope);
        List<Pending_Item_Queue__c> pendingItemQueueList =new  List<Pending_Item_Queue__c>(); 
        if(scope.size() > 0){
            for(sObject s : scope){
                System.debug('s--->>' + s);
                Pending_Item_Queue__c pendingItemQueue = new Pending_Item_Queue__c();
                pendingItemQueue.Record_Id__c =s.id;
                pendingItemQueue.Object__c = configurationObject;
                pendingItemQueue.Status__c = 'pending';
                pendingItemQueue.Configuration_Queue__c = queueIdMap.get((Id)s.get('OwnerId'));
                pendingItemQueueList.add(pendingItemQueue);
                System.debug('pendingItemQueue' + pendingItemQueue ); 
            }
            insert pendingItemQueueList;
        }   
    }
    public void finish(Database.BatchableContext BC) {
      // execute any post-processing operationsconfig like sending email
        System.debug('FINISH PushBatchClass');
         List<Configuration__c> configrations = ServiceQueryUtils.getConfigurations();
        System.debug('pushBatchClass configrations--->' + configrations);
        for(Configuration__c config : configrations){
            //for(Configuration_Queue__c configQueue : config.Configuration_Queues__r ) {
                   System.debug('Hy coll of AssignAgentBatchClass in  PushBatchClass');
                   //Database.executeBatch(new AssignAgentBatchClass(config),5); 
            //}  
        }     
    }  
}