trigger AccountTrigger on Account (before insert, before update, after insert, after update,before delete) {
    if(ARGO_Utils.isTriggerActive('AccountTrigger')){ 
      new AccountTriggerHandler().run();
    }   
}