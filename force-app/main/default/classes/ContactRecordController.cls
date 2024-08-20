public with sharing class ContactRecordController {
    public ContactRecordController() {
        
    } 
    
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContact(String accId){
        return [SELECT Id, LastName, FirstName, Phone, Email, AccountId FROM Contact WHERE AccountId =: accId];
    }
    
    @AuraEnabled
    public static string deleteContact(String contactId){
        String message = '';
        if(contactId != null){
            Database.DeleteResult obj = Database.delete(contactId);
            system.debug('DR'+obj);
            if(obj.isSuccess() == true){
                message = 'Success';
            }else{
                message = 'Unable to delete';
            }
        }
        return message;
    }
    
    @AuraEnabled
    public static string saveContacts(List<Contact> contacts){
        try {
            upsert contacts Id;
            return 'Success';
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}