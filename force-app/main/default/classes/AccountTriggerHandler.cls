public without sharing class AccountTriggerHandler  extends TriggerHandler {
    
    List<Account> accountList;
    Map<Id,Account> newAccountMap;
    Map<Id,Account> oldAccountMap;
    
    public AccountTriggerHandler(){
        accountList = Trigger.new;
        newAccountMap = (Map<Id,Account>)Trigger.newMap;
        oldAccountMap = (Map<Id,Account>)Trigger.oldMap;
    }
    public override void afterInsert(){
        afterInsert(accountList);
    }
    
    public static void afterInsert(List<Account> accountList){
        List<Contact> contactList =  new List<Contact>();
        for(Account account : accountList){
            Contact contactObj =  new Contact();
            contactObj.LastName = account.Name;
            contactObj.AccountId = account.id;
            contactList.add(contactObj);
        } 
        
        if(contactList.size() > 0){
            Insert contactList;
        }     
    }    
}