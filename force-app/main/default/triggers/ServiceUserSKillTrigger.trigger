/*
  aouther     = Abdul vahid 
  Date        = 10-08-2021
  Description =  when we create a record and user have  alredy same skill then error is genrate "we cannot select a same skill";
*/

trigger ServiceUserSKillTrigger on Service_User_Skill__c (before insert , before Update) {
    //Before insert
    if(Trigger.isBefore && Trigger.isInsert){
        ServiceUserSKillTriggerHelper.serviceUserSkillInsert(Trigger.new);
    }
    // Before update
    if(Trigger.isBefore && Trigger.isUpdate){
        ServiceUserSKillTriggerHelper.serviceUserSkillUpdate(Trigger.new,Trigger.oldMap);
    }
    
}