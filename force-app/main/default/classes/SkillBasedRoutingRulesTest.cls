@isTest
public class SkillBasedRoutingRulesTest {
    @isTest
    static void testLoadData() {
        User_Skill__c userList = new User_Skill__c(Skill_Name__c ='Honda');
        
        Test.startTest();
        insert userList;         
        Test.stopTest();
        
        SkillBasedRoutingRules controller = new SkillBasedRoutingRules() ;
        Map<String,String> objectsList = SkillBasedRoutingRules.getObjects();
        SkillBasedRoutingRules.getFields('Configuration__c');
        List<String> pickList = SkillBasedRoutingRules.getPicklistValue('Configuration__c','Status__c');
        
        List<User_Skill__c> skillsName = SkillBasedRoutingRules.skills();
        
        List<SkillBasedRoutingRules.wrapperClass> wrapperList = SkillBasedRoutingRules.getFields('Configuration__c');
        system.assert(wrapperList.size() > 0);
        
    }
}