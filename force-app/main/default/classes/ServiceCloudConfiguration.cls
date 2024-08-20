public class ServiceCloudConfiguration {
    
    Public ServiceCloudConfiguration(){}
    @AuraEnabled (cacheable = true) 
    Public static  Map<String,String> getAllObjList(){
        Map<String, Schema.SObjectType> AllObjectMap;
        allObjectMap = Schema.getGlobalDescribe();
        List<selectoption> SobjectList = new List<selectoption>();
        Map<String,String> objectMap = new Map<String, String>();
        objectMap.put('case', 'Case');
        objectMap.put('lead', 'Lead');
        objectMap.put('task','Task');
        objectMap.put('order','Order');
        Map<String,String> sObjectMap = new Map<String, String>();
        // objectMap.put('case', 'Case');
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
        // System.debug('SobjectList'+SobjectList);
        return sObjectMap; 
        
    }
    @AuraEnabled
    public static List<wrapperClassFields> getFields(String obj){
        
        List<SelectOption> fieldNames = new List<SelectOption>();
        List<wrapperClassFields> wrapperList = new List<wrapperClassFields>();
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType ObjSchema = schemaMap.get(Obj);
        Map<String, Schema.SObjectField> fieldMap = ObjSchema.getDescribe().fields.getMap();
        for (String fieldName: fieldMap.keySet()){
            {
                wrapperClassFields wc = new wrapperClassFields();
                wc.label = fieldMap.get(fieldName).getDescribe().getLabel();
                wc.value = fieldName;
                wc.types =  String.valueOf(fieldMap.get(fieldName).getDescribe().getType());
                if(wc.types == 'PICKLIST' || wc.types == 'MULTIPICKLIST' || wc.types == 'STRING' || wc.types == 'DOUBLE' || wc.types == 'NUMBER'  || wc.types == 'PHONE' || wc.types == 'EMAIL'){
                    System.debug('0000'+wc.types);  
                    wrapperList.add(wc);
                }
            }
        }
        system.debug(wrapperList);
        return wrapperList;
    }
    
    @AuraEnabled (cacheable = true) 
    public static  List<String> getPickListvalue(String selectedObject, String field){
        System.debug('selectedObject' +selectedObject);
        System.debug('field' +field);
        String objectName = selectedObject;
        String fieldName =field;
        List<String> fieldPickList = new List<String>();
        System.debug('fieldName---'+fieldName);
        Schema.SObjectType s = Schema.getGlobalDescribe().get(objectName) ;
        Schema.DescribeSObjectResult r = s.getDescribe() ;
        Map<String,Schema.SObjectField> fields = r.fields.getMap() ;
        Schema.DescribeFieldResult fieldResult = fields.get(fieldName).getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            System.debug('hiiiiiiii'+pickListVal.getLabel() +' '+pickListVal.getValue());
            fieldPickList.add(pickListVal.getValue());
        }
        return fieldPickList;   
    }
    
    @AuraEnabled
    public static List<String> saveConfigu(Configuration__c Configuration ,List<String> selectQueuesList, List<String> skills, List<String> fields){
        Boolean updateFlag = false;
        //Boolean chakbox  =  false;
        Id configueationId;
        //System.debug('Configuration'+Configuration);
        // System.debug('skillList ' +  skillList);
        Set<String> queuesId = new  Set<String>();
        //System.debug('selectQueuesList  :::' + selectQueues);
        System.debug('skills   :::' + skills);
            System.debug('fields   :::' + fields);
        System.debug('Configuration.Id'+Configuration.Id);
        try {
            if(!String.isBlank(Configuration.Id)){
                deleteSkillAndFields(Configuration.Id);
                UPDATE Configuration;                
            }else{				               
                INSERT Configuration;
            }
            configueationId = Configuration.Id;            
            System.debug('selectQueuesList :::: Aarry :::' + selectQueuesList);

            
            if(selectQueuesList.size() > 0){
                List<Group> groupList = [select Id,Name from Group where id In : selectQueuesList];
                List<Configuration_Queue__c> recordList = [SELECT Configuration__c, Queue_Id__c, Id, Name FROM Configuration_Queue__c where id In : selectQueuesList];
                List<Configuration_Queue__c> configurationQueueList = new List<Configuration_Queue__c>();
                
                
                System.debug('group Name List ::::'  + groupList);
                for(Group groupObj : groupList){
                    Configuration_Queue__c configurationQueueObj = new Configuration_Queue__c();
                    configurationQueueObj.Name = groupObj.Name;
                    configurationQueueObj.Queue_Id__c = groupObj.Id;
                    System.debug('groupObj.Id'+groupObj.Id);
                    configurationQueueObj.Configuration__c = configueationId;
                    configurationQueueList.add(configurationQueueObj);
                } 
                if(configurationQueueList.size() > 0){
                    UPSERT configurationQueueList ;
                }  
            }
            
            
            if(skills.size() > 0) {
                System.debug('skillList ::::' + skills);
                List<Configuration_Skill__c>  configurationSkillList =  new List<Configuration_Skill__c>();
                for(String  confiSkills : skills){
                    Configuration_Skill__c configurationSkillObj = new Configuration_Skill__c();
                    configurationSkillObj.Skill_Name__c = confiSkills;
                    configurationSkillObj.Configuration__c = configueationId;
                    configurationSkillList.add(configurationSkillObj);
                }
                if(configurationSkillList.size() > 0){
                    INSERT configurationSkillList;
                }                
            }
            
            if(fields.size() > 0) {
                System.debug('skillList ::::' + fields);
                List<Configuration_Skill_Fields__c> configurationFieldsList = new List<Configuration_Skill_Fields__c>();
                for(String  confiFields : fields){
                    Configuration_Skill_Fields__c configurationFieldsObj = new Configuration_Skill_Fields__c();
                    configurationFieldsObj.Field_Name__c = confiFields;
                    configurationFieldsObj.Configuration__c = configueationId;
                    configurationFieldsList.add(configurationFieldsObj);
                }
                if(configurationFieldsList.size() > 0){
                    INSERT configurationFieldsList;
                }                
            }        
            
            List<String> successResult = new List<String>();
            successResult.add('success');
            successResult.add(configueationId);
            
            return successResult; 
            
        } catch (Exception e) { 
            System.debug('getting error '+e);
            List<String> resultErr = new List<String>();
            resultErr.add('error');
            resultErr.add(''+e);
            return resultErr;
        }        
    } 
    
    public static void deleteSkillAndFields (Id configueationId){
        List<Configuration_Queue__C>  configurationRelatedQueueList= [SELECT Id, Name, Queue_Id__c, Configuration__c, OwnerId FROM Configuration_Queue__C where Configuration__c =: configueationId];
        
        Configuration__c configrationRecord = [SELECT Id, (SELECT Id, Name, Queue_Id__c, Configuration__c, OwnerId FROM Configuration_Queues__r),  
                                                     (SELECT Name, Id, Skill_Id__c, Skill_Name__c FROM Configuration_Skills__r),
                                                     (SELECT Id, Name, Field_Name__c FROM Configuration_Skill_Fields__r)
                                                     FROM Configuration__c WHERE Id = :configueationId];
        
        
        if(configrationRecord.Configuration_Queues__r.size() > 0 ){
            DELETE  configrationRecord.Configuration_Queues__r;
        }
        
        if(configrationRecord.Configuration_Skills__r.size() > 0 ){
            DELETE  configrationRecord.Configuration_Skills__r;
        }
        
        if(configrationRecord.Configuration_Skill_Fields__r.size() > 0 ){
            DELETE  configrationRecord.Configuration_Skill_Fields__r;
        }  
    }
    
    @AuraEnabled (cacheable = true) 
    public static List<Group> getQueues(){
        
        return ServiceQueryUtils.getQueues();  
    }
    
    @AuraEnabled (cacheable = true) 
    public static List<Configuration__c> getconfiguration(){
        
        return [SELECT Id, Name FROM Configuration__c];
        
    }
    
    @AuraEnabled (cacheable = true) 
    public static List<User_Skill__c> getUserSkill(){
        return ServiceQueryUtils.getUserSkill();
    }
    
    @AuraEnabled (cacheable = true) 
    public Static Configuration__c getRecordForUpdate(String recordId){
        
        Configuration__c conf = [SELECT Id, Name, Model__c, Status_Close_Value__c, Agent_Capacity__c, Skill_Based_Routing__c, Object__c, Operator__c, 
                                 Status_Close_Field__c, Status__c, Skill_Based_Routing_Field__c, Skill_Based_Routing_Value__c, 
                                 (SELECT Id ,Name, Queue_Id__c FROM Configuration_Queues__r),
                                 (SELECT Id ,Field_Name__c ,Configuration__c  from Configuration_Skill_Fields__r),
                                 (SELECT Id, Name, Configuration__c, Skill_Name__c, Skill_Id__c FROM Configuration_Skills__r)
                                 FROM Configuration__c WHERE Id =: recordId];
        System.debug(conf);
        return conf;
    }
    
    @AuraEnabled(cacheable=true)
    public static Response getSkills(String objectAPIName){       
        List<SelectOption> fieldNames = new List<SelectOption>();
        List<wrapperClass> wrapperList = new List<wrapperClass>();
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType ObjSchema = schemaMap.get(objectAPIName);
        Map<String, Schema.SObjectField> fieldMap = ObjSchema.getDescribe().fields.getMap();
        for (String fieldName: fieldMap.keySet()){                      
            wrapperClass wc = new wrapperClass();
            if(fieldMap.get(fieldName).getDescribe().isUpdateable()){
                wc.label = fieldMap.get(fieldName).getDescribe().getLabel();
                wc.value = fieldName;
                wc.selected = false;
                wrapperList.add(wc);
            }
        }
        
        Response res = new Response();
        res.skillFields = wrapperList;
        res.userSkills =  [SELECT Id, Skill_Name__c FROM User_Skill__c LIMIT 49999];
        return res;
    } 
    
    public class Response{
        @AuraEnabled public List<wrapperClass> skillFields;
        @AuraEnabled public List<User_Skill__c> userSkills;
    }
    
    public class wrapperClass {
        @AuraEnabled public String label;
        @AuraEnabled public String value;
        @AuraEnabled public Boolean selected;
    }
    
    public class wrapperClassFields{
        @AuraEnabled public String label;
        @AuraEnabled public String value;
        @AuraEnabled public String types;
    }
    
    
    /*
@AuraEnabled
public static Map<String,String> getAllFields(String obj){
Map<String,String> fielddMap = new Map<String,String>();
List<String> fieldList = new List<String>();
Map<String,Schema.SObjectType> gd = Schema.getGlobalDescribe(); 


Schema.SObjectType sobjType = gd.get(obj);

Schema.DescribeSObjectResult describeResult = sobjType.getDescribe();
//DescribeSObjectResult describeResult = sobjType.getDescribe(); 

Map<String,Schema.SObjectField> fieldsMap = describeResult.fields.getMap(); 

for(string str: fieldsMap.keySet()){

String pickListType = 'PICKLIST';
string multiPickListType ='MULTIPICKLIST';
String fieldType = String.valueOf(fieldsMap.get(str).getDescribe().getType());
if(pickListType == fieldType || multiPickListType == fieldType){
fielddMap.put(str, fieldsMap.get(str).getDescribe().getLabel()); 
}                 
}

return fielddMap;      
}
*/
    
}