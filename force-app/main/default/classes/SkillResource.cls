public with sharing class SkillResource {

    public SkillResource() {
    }
   
    @AuraEnabled(cacheable = true)
        public static List<user> getUserList() {
            return [SELECT Id, Name From user  WHERE Profile.UserLicense.Name = 'Salesforce'];
        }

    @AuraEnabled
        public static List<ServiceResource> getServiceResource(String  userId) {
            return [SELECT Id,Name, IsActive, ResourceType, Description  From ServiceResource 
                    WHERE RelatedRecordId = : userId ];
        }

    /*
    @AuraEnabled(cacheable = true)
        public static List<skill> skillList() {
            return [SELECT Id, MasterLabel FROM skill]; 
        }
*/

    @AuraEnabled
        public static String createServiceUserSkill(List<ServiceResourceSkill> srviceUserSkill) {
            try{
               
                     Database.insert(srviceUserSkill, false);
                     return 'success';
                
                   // insert srviceUserSkill;
                    
            }catch (Exception e) {
                // return e.getMessage();
                return 'failed';
            }         
        }

    @AuraEnabled
        public static List<Id> createServiceResource(List<ServiceResource> serviceResourceList) {
            List<Id> serviceResouceId = new List<Id>();
            
            if(serviceResourceList.size() > 0){
              // Database.upsertResult[] results = Database.upsert(serviceResourceList, false);
                upsert serviceResourceList;
                
                for(Integer index =0; index < serviceResourceList.size(); index++) {
                    serviceResouceId.add(serviceResourceList[index].Id);
                }   
            }
            return serviceResouceId;   
        }
}