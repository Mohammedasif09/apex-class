@isTest
public class TestSkillAddRemoveController {
    @isTest
    public static void getServiceResourceTest(){
        
        SkillAddRemoveController newObject = new SkillAddRemoveController();
        
        List<ServiceResource> resourceList = new List<ServiceResource>();
        ServiceResource newResource = new ServiceResource();
        newResource.name = 'Tab';
        newResource.IsActive = true;
        newResource.Description = 'this is service trsource';
        newResource.RelatedRecordId = '0055g00000DOqR0AAL';
        insert newResource;
        
        resourceList.add(newResource);    
        
        SkillAddRemoveController.getServiceResource(resourceList);
        
        SkillAddRemoveController.getSkills(newResource.id);
        
		List<Id> resourceIdList = new List<Id>();  
        resourceIdList.add(newResource.id);
        SkillAddRemoveController.deleteServiceResourceSkill(resourceIdList);
    }

}