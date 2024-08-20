public class Configuration {
    public Configuration(){
        
    }
    public Integer getTotalConfiguration(){
        return[SELECT Id, Name from Configuration__c where createddate =: System.today()].size();
    }

}