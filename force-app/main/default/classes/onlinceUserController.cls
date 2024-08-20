public class onlinceUserController {
    
    @AuraEnabled(cacheable=true)
    public static List<sobject> serviceUserList(String radioButtonVal) {
        /*
        Set<Id> userIds = new Set<Id>();
        for(Service_User__c serviceRecrod : [SELECT Id, User__c  FROM Service_User__c Where Available_Status__c =: radioButtonVal]){
            userIds.add(serviceRecrod.User__c);
        }
       
        List<User> userRecords = new List<User>();
        //userRecords = [SELECT Id, Name FROM User WHERE Id in : userIds];
        Id userId = '0055g00000BZnVlAAL';
        */
        // userInfo.getUserId()
        List<Case> caseRecords = new List<Case>();
        caseRecords = [SELECT Id, OwnerId ,	CaseNumber FROM Case WHERE OwnerId ='0055g00000BZnVlAAL'];
        return caseRecords; 
    }
    
    @AuraEnabled (cacheable = true) 
    Public static  Map<String,String> getObjects(){
         Map<String, Schema.SObjectType> AllObjectMap;
         allObjectMap = Schema.getGlobalDescribe();
        Map<String,String> objectMap = new Map<String, String>();
        objectMap.put('case', 'Case');
        objectMap.put('lead', 'lead');
        objectMap.put('Task','Task');
        objectMap.put('Order','Order');
        Map<String,String> sObjectMap = new Map<String, String>();
        for(String objectName : objectMap.keySet()){
            sObjectMap.put(objectName,objectMap.get(objectName));
        }
        for(string objectName:AllObjectMap.keyset()){
            DescribeSObjectResult dsr = allObjectMap.get(objectName).getDescribe();
            if(dsr.isAccessible() && dsr.isQueryable() && dsr.isCreateable() && dsr.isUpdateable() && dsr.isCustom()){
                String objectLabel = allObjectMap.get(objectName).getDescribe().getLabel();
                if(!objectName.equalsIgnoreCase('Account') && !objectName.equalsIgnoreCase('Contact'))
                    sObjectMap.put(objectName,objectLabel);
            }
        }
        return sObjectMap;   
    }
    
     @AuraEnabled
    public static List<sobject> getRecord(String Obj){
      String objectName =  Obj;
         String Fields =  '';
         if(objectName =='case' )
         {
           Fields = 'Id ,OwnerId ,	CaseNumber From ' ; 
         }
        else{
            Fields = 'Id ,Name ,OwnerId  From ' ; 
        }
         String query = 'SELECT '+  Fields +   +  objectName ;
         System.debug('query + ' + query);
         List<SObject> sobjList = Database.query(query);
        System.debug('sobjList  TestData ====>' + sobjList);
      return sobjList;  
    }
}