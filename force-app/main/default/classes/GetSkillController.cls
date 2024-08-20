public class GetSkillController {
    
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
}