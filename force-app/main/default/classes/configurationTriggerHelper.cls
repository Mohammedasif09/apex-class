public class configurationTriggerHelper {
    
    public static void configurationInsertRecords(List<Configuration__c> configurationNewList){
        
        Set<String>  configurationObject =  new  Set<String>();
        Set<String>  configurationStatus =  new  Set<String>();
        for(Configuration__c configurationObj : configurationNewList) {
            if(configurationObj.Object__c != Null && configurationObj.Status__c != Null){
                configurationObject.add(configurationObj.Object__c);
                configurationStatus.add(configurationObj.Status__c);
            }   
        }
        List<Configuration__c> configurationRecords =[Select Id , Object__c , Status__c From Configuration__c 
                                                      WHERE Object__c IN :configurationObject And Status__c IN:configurationStatus];
        System.debug('configurationRecords' + configurationRecords);
        
        if(configurationRecords.Size() > 0){
            for(Configuration__c configurationObj : configurationNewList){
                configurationObj.Object__c.addError('we are not select same object to active');   
            }
        }
    }
    
    public static void configurationAfterInsertRecords(List<Configuration__c> configurationNewList){
        //ConfigurationShedulableClass scheObj = new ConfigurationShedulableClass();
        //System.debug('configurationTriggerHelper '  + configurationNewList);
        //scheObj.execute(configurationNewList);
       
        
    } 
     	 	 	
        
    public static void configurationUpdateRecords(List<Configuration__c>configurationNewList,Map<Id , Configuration__c> configurationOldMap){
        Set<String>  configurationObject =  new  Set<String>();
        Set<String>  configurationStatus =  new  Set<String>();
        for(Configuration__c configurationObj : configurationNewList ){
            if(configurationOldMap.get(configurationObj.Id).Object__c != configurationObj.Object__c){
               configurationObject.add(configurationObj.Object__c);
               configurationStatus.add(configurationObj.Status__c); 
            } 
        }
         List<Configuration__c> configurationRecords =[Select Id , Object__c , Status__c From Configuration__c 
                                                      WHERE Object__c =: configurationObject And Status__c =:configurationStatus];
         System.debug('configurationRecords' + configurationRecords);
         if(configurationRecords.Size() > 0){
            for(Configuration__c configurationObj : configurationNewList){
                configurationObj.Object__c.addError('we are not select same object to active');   
            }
        }
    } 
}