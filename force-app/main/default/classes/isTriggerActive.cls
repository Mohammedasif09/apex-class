public class isTriggerActive {
   /*******************************************************************************************************
	 * @description Check is a trigger is active in the metadata settings
	 * @param triggerName the name of the object to look up
	 * @return boolean
	 * @example
	 */
    public static Boolean isTriggerActive(String triggerName){
        Configuration_Settings__mdt  metadataRec = [Select Id , isActive__c ,DeveloperName From Configuration_Settings__mdt Where DeveloperName =:triggerName];    
        return metadataRec?.isActive__c;
    }
}