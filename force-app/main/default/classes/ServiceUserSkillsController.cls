public class ServiceUserSkillsController {
    
    @AuraEnabled (cacheable=true)
    public static List<Service_User__c> getServiceUser(){
        return [SELECT Name, Id, User__c, Description__c, Is_Active__c, Available_Status__c FROM Service_User__c];
    } 
    
    @AuraEnabled (cacheable=true)
    public static List<User_Skill__c> getServiceUserSkills(String serviceUser){
        Set<Id> skillIds =  new Set<Id>(); 
        List<Service_User_Skill__c> serviceUserSkillList =  [SELECT Id, Service_User__c , Skill__c FROM Service_User_Skill__c where Service_User__c =:serviceUser];
        for(Service_User_Skill__c serviceUSerSkill : serviceUserSkillList){
            if(serviceUSerSkill.Skill__c != Null){
                skillIds.add(serviceUSerSkill.Skill__c);
            }     
        }
        return [SELECT Skill_Name__c, Id, Name FROM User_Skill__c Where Id Not IN : skillIds];
    }
    
    @AuraEnabled
    public static List<String> saveServiceUserSkills(List<Service_User_Skill__c> serviceUserSkill){
        try{
            //INSERT serviceUserSkill;
            /* 
if(serviceSkills.size() > 0) {               
List<Service_User_Skill__c> userSkillList = new List<Service_User_Skill__c>();
System.debug('inner for loop'+serviceUserSkill);
for(String  confiFields : serviceSkills){
System.debug('inner for loop'+confiFields);
Service_User_Skill__c userSkillObj = new Service_User_Skill__c();
userSkillObj.Service_User__c = serviceUserSkill.Service_User__c;
userSkillObj.Skill__c = confiFields;
userSkillObj.Skill_Level__c = serviceUserSkill.Skill_Level__c;
userSkillObj.Start_Date__c = serviceUserSkill.Start_Date__c;
userSkillObj.End_Date__c   = serviceUserSkill.End_Date__c;   
userSkillList.add(userSkillObj); 
System.debug('inner for loop2'+confiFields);
}
*/
            if(serviceUserSkill.size() > 0){
                System.debug('inner insert'+serviceUserSkill);
                INSERT serviceUserSkill;
            }                
            
            System.debug('getting success '+serviceUserSkill[0].Service_User__c);
            List<String> successResult = new List<String>();
            successResult.add(''+serviceUserSkill[0].Service_User__c);
            successResult.add('Success');
            return successResult;
        }
        catch (Exception e){
            System.debug('getting error '+e);
            List<String> errorResult = new List<String>();
            errorResult.add(''+e);
            errorResult.add('Error');
            return errorResult;
        }        
    }
}