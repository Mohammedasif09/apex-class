public with sharing class SkillAddRemoveController {
    public SkillAddRemoveController() {

    }
    @AuraEnabled(cacheable = true)
        public static List<ServiceResource> getServiceResource(List<ServiceResource> serviceResourceList){

            return [SELECT Id,Name, IsActive, ResourceType, Description  From ServiceResource];
        }

    @AuraEnabled
    public static List<ServiceResourceSkill> getSkills(String serviceResourceId ){
        List<ServiceResourceSkill> ServiceResourceSkillList = new List<ServiceResourceSkill>();
            
        for(ServiceResourceSkill listOfServiceResourceSkill:  [SELECT  Id, Skill.MasterLabel, SkillLevel, EffectiveStartDate, EffectiveEndDate FROM ServiceResourceSkill WHERE  ServiceResourceId =: serviceResourceId]){
            ServiceResourceSkillList.add(listOfServiceResourceSkill);     
        }    
    return ServiceResourceSkillList;
    }
    @AuraEnabled
        public static string deleteServiceResourceSkill(List<Id> ServiceResourceskillIds){
           
            try {
                if(ServiceResourceskillIds.size() > 0){
                    Database.delete(ServiceResourceskillIds);     
                }
                return 'success';
            } catch (Exception e) {
                return 'failed';
                
            }       
    }
}