public with sharing class skillResourceController {
    public skillResourceController() {

    }
    @AuraEnabled(cacheable = true)
   
   public static List<Service_User__c> getList(){

     return  [SELECT Id, Available_Status__c from Service_User__c];
   }
    
    
   
}