trigger contacttrigger on Contact (after insert , after Update) {
    /*List<Account> accountList =  new  List<Account>();
    Set<Id> accountIds = new Set<Id>();
    List<Account> updateAccount =  new List<Account>();
    if(Trigger.isAfter && Trigger.isInsert){
        if(ContactTriggerHandler.isFirstTime){
            ContactTriggerHandler.isFirstTime = false;
            for(Contact contact : Trigger.new){
                if(contact.AccountId == Null){
                    Account accountObj =  new  Account();
                    accountObj.Name  = contact.LastName; 
                    accountObj.Phone = contact.Phone;
                    accountObj.Fax   = contact.Fax;
                    accountList.add(accountObj);
                }
                else{
                    accountIds.add(contact.AccountId);
                }
            }   
            
        }    
    }
    
    List<Account> selectaccountList = [Select Id, Description,(Select Id ,LastName , AccountId FROM Contacts) From Account Where Id IN: accountIds];
    for(Account accountObj : selectaccountList) {
          String str = '';
        for(Contact contactObj : accountObj.Contacts){
            integer len = 0;
            if(accountObj.Description == Null && len > 0){ 
                 str += contactObj.LastName;
                 len = 1;
            }
            else{
               str += ',';
               str += contactObj.LastName;
            }  
        }
        accountObj.Description = str; 
        updateAccount.add(accountObj); 
    }
    
    if(accountList.size() > 0)  {
        insert accountList;   
    }
    
    if(updateAccount.size() > 0){
        Update updateAccount; 
    }*/
    
}


/*
contactObj.AccountId = account.Id;
contactObj.FirstName = account.Name;
contactObj.Phone = account.Phone;
contactList.add(contactObj);
*/