@isTest
public class TestGetAllObjectsListController {
    
    @isTest
    public static void getAllObjListTest(){
        
        GetAllObjectsListController constractor = new GetAllObjectsListController();
        
        String selectedObject = constractor.SelectedObject;
        String objectList = constractor.objList;
        String SelectedField = constractor.selectedField;
        
        constractor.getAllObjList();
        
        GetAllObjectsListController.getAllFields('Account');
        
    }

}