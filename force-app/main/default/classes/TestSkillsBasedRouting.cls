@isTest
public class TestSkillsBasedRouting {
    @isTest
    public static void userSkillsTest(){
        
        List<String> caseList = new List<String>();
        Case caseName = new Case();
        caseName.Origin = 'Email';
        caseName.Status = 'New';
        caseName.Subject = 'Rest Case';
        insert caseName;
        
        caseList.add(caseName.id);
        
        SkillsBasedRouting.routeUsingSkills(caseList);
        
        SkillsBasedRouting.getSkillId('English');
        
    }

}