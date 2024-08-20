@isTest
public class TestSkillResource {
    
    @isTest
    public static void getUserList(){
        
        SkillResource newObject = new SkillResource();
        
        SkillResource.getUserList();
        //SkillResource.skillList();
        
        SkillResource.getServiceResource('0Hn5g0000001OeGCAU');
        
        List<ServiceResource> resourceList = new List<ServiceResource>();
        
        ServiceResource newResource = new ServiceResource();
        newResource.name = 'Tab';
        newResource.IsActive = true;
        newResource.Description = 'this is service trsource';
        newResource.RelatedRecordId = '0055g00000DOqR0AAL';
        insert newResource;
        
        resourceList.add(newResource);    
        
        SkillResource.createServiceResource(resourceList);
        
        List<ServiceResourceSkill> serviceSkillList = new List<ServiceResourceSkill>();
        ServiceResourceSkill serviceResourceSkills = new ServiceResourceSkill();
        serviceResourceSkills.SkillLevel = 2;
        serviceResourceSkills.ServiceResourceId = newResource.id;
        serviceResourceSkills.EffectiveStartDate = date.today();
        //insert serviceResourceSkills;
        
        serviceSkillList.add(serviceResourceSkills);
        SkillResource.createServiceUserSkill(serviceSkillList);
        
        SkillResource.createServiceUserSkill(null);
    }

}