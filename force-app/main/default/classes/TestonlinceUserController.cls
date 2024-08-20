@isTest
public class TestonlinceUserController {
    
    @isTest
    public static void serviceUserListTest(){
        
        Service_User__c serviceUser = new Service_User__c();
        serviceUser.Name = 'Md Test';
        serviceUser.Is_Active__c = true;
        serviceUser.Available_Status__c = 'online';
        insert serviceUser;

        test.startTest();
		onlinceUserController.serviceUserList(serviceUser.Available_Status__c);
        
        onlinceUserController.getObjects();
        
        onlinceUserController.getRecord('case');
        
        onlinceUserController.getRecord('lead');
        test.stopTest(); 
		        
    }

}