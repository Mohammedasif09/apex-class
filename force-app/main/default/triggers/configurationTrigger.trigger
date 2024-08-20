/*
aouther     =  Abdul vahid 
Date        =  02-09-2021
Description =  when we create a record and user have  alredy same Object and static is active then error is genrate "we cannot select a same Object";
*/

trigger configurationTrigger on Configuration__c (before insert ,after insert ,before Update ,  after Update) {
    
    // BEFORE PROCESSS
    if(trigger.isBefore){
        if(Trigger.isInsert){
            configurationTriggerHelper.configurationInsertRecords(Trigger.new);
        }
        if(Trigger.isUpdate){ 
            configurationTriggerHelper.configurationUpdateRecords(Trigger.new,Trigger.oldMap);
        }
    }
    
    
    // AFTER PROCESSS
    /* if(trigger.isAfter){
if(Trigger.isInsert){
configurationTriggerHelper.configurationAfterInsertRecords(Trigger.new);
}

if(Trigger.isUpdate){
configurationTriggerHelper.configurationUpdateRecords(Trigger.new,Trigger.oldMap);
}
} */
    
    
}