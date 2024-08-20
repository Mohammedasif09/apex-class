public with sharing class SkillBasedRoutingRules {
    public SkillBasedRoutingRules() {}
    @AuraEnabled (cacheable = true) 
    Public static  Map<String,String> getObjects(){
         Map<String, Schema.SObjectType> AllObjectMap;
         allObjectMap = Schema.getGlobalDescribe();
        Map<String,String> objectMap = new Map<String, String>();
        objectMap.put('case', 'Case');
        objectMap.put('lead', 'Lead');
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
    public static List<wrapperClass> getFields(String Obj){
       
        List<SelectOption> fieldNames = new List<SelectOption>();
        List<wrapperClass> wrapperList = new List<wrapperClass>();
            Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
            Schema.SObjectType ObjSchema = schemaMap.get(Obj);
            Map<String, Schema.SObjectField> fieldMap = ObjSchema.getDescribe().fields.getMap();
            for (String fieldName: fieldMap.keySet()){
                {
                    wrapperClass wc = new wrapperClass();
                    wc.label = fieldMap.get(fieldName).getDescribe().getLabel();
                    wc.value = fieldName;
                    wc.types =  String.valueOf(fieldMap.get(fieldName).getDescribe().getType());
                    if(wc.types == 'PICKLIST' || wc.types == 'MULTIPICKLIST' || wc.types == 'STRING' || wc.types == 'DOUBLE' || wc.types == 'NUMBER'){
                      System.debug('0000'+wc.types);  
                    wrapperList.add(wc);
                    }
                }
                }
        system.debug(wrapperList);
        return wrapperList;
    }
    
    @AuraEnabled(cacheable = true)
        public static List<User_Skill__c> skills(){
            return  [SELECT Id, Skill_Name__c FROM User_Skill__c ];
        
        }

    @AuraEnabled (cacheable = true) 
    public static  List<String> getPicklistValue(String obj, String picVal){
        String objectName = obj;
        String fieldName = picVal;
        List<String> fieldPickList = new List<String>();
        System.debug('fieldName---'+fieldName);
         Schema.SObjectType s = Schema.getGlobalDescribe().get(objectName) ;
         Schema.DescribeSObjectResult r = s.getDescribe() ;
                Map<String,Schema.SObjectField> fields = r.fields.getMap() ;
                Schema.DescribeFieldResult fieldResult = fields.get(fieldName).getDescribe();
                List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
                for( Schema.PicklistEntry pickListVal : ple){
                fieldPickList.add(pickListVal.getValue());
                }
        return fieldPickList;  
    }

    public class wrapperClass{
        @AuraEnabled public String label;
        @AuraEnabled public String value;
        @AuraEnabled public String types;
    }
}