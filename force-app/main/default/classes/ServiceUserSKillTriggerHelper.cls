public class ServiceUserSKillTriggerHelper {
    public static void serviceUserSkillInsert(list<Service_User_Skill__c> ServiceUserSkillNewList)  {
        Set<Id> serviceUserSkillOldId = new Set<Id>();
        Set<String> serviceUserSkill = new Set<String>();
        if(ServiceUserSkillNewList.size() > 0){
            System.debug('@#@#@#@#----' +ServiceUserSkillNewList);
            for(Service_User_Skill__c 	serviceUserSkillRecord : ServiceUserSkillNewList){
                if(serviceUserSkillRecord.Skill__c != null){
                    serviceUserSkillOldId.add(serviceUserSkillRecord.Skill__c);
                    serviceUserSkill.add(serviceUserSkillRecord.Service_User__c);
                }
            }
        }
        List<Service_User_Skill__c> serviceUserSkillOldList = [SELECT Id , Service_User__c , Skill__c  FROM Service_User_Skill__c 
                                                               WHERE Skill__c =: serviceUserSkillOldId AND Service_User__c =: serviceUserSkill];
        if(serviceUserSkillOldList.size() > 0){
            for(Service_User_Skill__c  serviceUserOldList : ServiceUserSkillNewList){
                serviceUserOldList.Skill__c.addError('we can not select a same skill');
            }   
        }
        
    }
    
    public static void serviceUserSkillUpdate(list<Service_User_Skill__c> ServiceUserSkillNewList ,Map<Id , Service_User_Skill__c> serviceOldMap) {
        Set<Id> serviceUserSkillOldId = new Set<Id>();
        Set<String> serviceUserSkill = new Set<String>();
        if(ServiceUserSkillNewList.size() > 0){
            for(Service_User_Skill__c serviceUserSkillRecord : ServiceUserSkillNewList){
                if( serviceOldMap!= null && serviceOldMap.get(serviceUserSkillRecord.id).Skill__c != serviceUserSkillRecord.Skill__c ){
                    System.debug('ServiceUserSkillNewList----' +ServiceUserSkillNewList);
                    serviceUserSkillOldId.add(serviceUserSkillRecord.Skill__c);
                    serviceUserSkill.add(serviceUserSkillRecord.Service_User__c);
                }
            }
        }
        List<Service_User_Skill__c> serviceUserSkillOldList = [SELECT Id , Service_User__c , Skill__c  FROM Service_User_Skill__c 
                                                               WHERE Skill__c =: serviceUserSkillOldId AND Service_User__c =: serviceUserSkill];
        system.debug('serviceUserSkillOldList.size()'+serviceUserSkillOldList.size());
        if(serviceUserSkillOldList.size() > 0){
            for(Service_User_Skill__c  serviceUserOldList : ServiceUserSkillNewList){
                serviceUserOldList.Skill__c.addError('We can not select a same skill');
            }   
        }
    }
}