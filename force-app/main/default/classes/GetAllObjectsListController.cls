public class GetAllObjectsListController {
    Public string SelectedObject{get;set;}
    Public string selectedField{get;set;}
    public string objList{get;set;}
    Public Map<String, Schema.SObjectType> AllObjectMap;
    Public GetAllObjectsListController(){
        AllObjectMap = New Map<String, Schema.SObjectType>();
        allObjectMap = Schema.getGlobalDescribe();
    }
    
    Public Map<String,String> getAllObjList(){
        List<selectoption> SobjectList = new List<selectoption>();
        Map<String,String> objectMap = new Map<String, String>();
        objectMap.put('case', 'Case');
        
        Map<String,String> sObjectMap = new Map<String, String>();
        //objectMap.put('case', 'Case');
        
        for(String objectName : objectMap.keySet()){
            sObjectMap.put(objectName,objectMap.get(objectName));
        }
        for(string objectName:AllObjectMap.keyset()){
            DescribeSObjectResult dsr = allObjectMap.get(objectName).getDescribe();
            
            
            if(dsr.isAccessible() && dsr.isQueryable() && dsr.isCreateable() && dsr.isUpdateable() && dsr.isCustom()){
                String objectLabel = allObjectMap.get(objectName).getDescribe().getLabel();
                if(!objectName.equalsIgnoreCase('Account') && !objectName.equalsIgnoreCase('Contact'))
                    sObjectMap.put(objectName,objectLabel);
            }
            
        }
        System.debug('SobjectList'+SobjectList);
        return sObjectMap; 
        
    }
     

    
}