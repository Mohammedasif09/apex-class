public with sharing class configurationController {
    @AuraEnabled(cacheable = true)
    public static List<Configuration__c> getConfiguration(){
        return [SELECT Id, Name, Object__c, Status__c,Agent_Capacity__c from Configuration__c];
        
    }
    @AuraEnabled
    public static String saveConfiguration(List<Configuration__c> config){
        System.debug('config'+config);
        try {
            
            upsert config;
            return 'success';
        } catch (Exception e) {
            return 'failed';
        }
    } 
}