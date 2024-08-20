@isTest
public class TestContactController {
    @isTest
    public static void fetchAccountsTest(){
        ContactController.fetchAccounts('account');
    }
    
    @isTest
    public static void getContactTest(){
        
        ContactRecordController neConstractor = new ContactRecordController();        
        Account acc = new Account();
        acc.name = 'new account';
        acc.Rating = 'Hot';
        insert acc;
        
        //test.startTest(); 
        ContactRecordController.getContact(acc.Id);
        //ContactRecordController.getContact(null);
        
        //test.stopTest();
        
        Contact con0 = new Contact();
        con0.LastName = 'mr Shan';
        con0.Email = 'alishan@gmail.com';
        con0.AccountId = acc.Id;
        insert con0;
        
        //test.startTest();       
        ContactRecordController.deleteContact(con0.Id);
        //ContactRecordController.deleteContact(null);
        //test.stopTest();
        
        Contact con1 = new Contact(); 
        con1.LastName = 'mr Shan';
        con1.Email = 'alishan007@gmail.com';
        //insert con1;
        
        Contact con2 = new Contact();
        con2.LastName = 'alishan';
        con2.Email = 'alishan2@gmail.com';
        con2.LeadSource = 'web';
        
        List<Contact> conList = new List<Contact>();
        conList.add(con1);
        conList.add(con2);

        List<Contact> conList1 = new List<Contact>();
		//conList1.add(con1); 
		
        test.startTest();
        try{
            ContactRecordController.saveContacts(conList);
        } catch (DmlException ex) {
            System.assertEquals('expected text', ex.getMessage());
        }  
        test.stopTest();  
        
        ContactRecordController.saveContacts(conList1);
        //ContactRecordController.saveContacts(conList);
        
    }

}