Global class SkillsBasedRouting {
    
    @ InvocableMethod
        public static void routeUsingSkills(List<String> cases) {
            
            List<Case> caseObjects = [SELECT Id, Description, Language__c FROM Case WHERE Id in :cases];
            
            for (Case caseObj : caseObjects) {
                // Add SkillsBased PendingServiceRouting
                PendingServiceRouting psrObj = new PendingServiceRouting(
                    CapacityWeight = 1,
                    IsReadyForRouting = FALSE,
                    RoutingModel  = 'MostAvailable', //LeastAvailbale
                    RoutingPriority = 1,
                    RoutingType = 'SkillsBased',
                    ServiceChannelId = getChannelId('Case'),
                    WorkItemId = caseObj.Id
                );
                insert psrObj;
                psrObj = [select id, IsReadyForRouting from PendingServiceRouting where id = : psrObj.id];
                System.debug(' \n **** psrObj **** \n'+psrObj);
                // Now add SkillRequirement(s)
                SkillRequirement srObj = new SkillRequirement(
                    RelatedRecordId = psrObj.id,
                    SkillId = getSkillId(caseObj.Language__c)
                    //SkillLevel = 10
                );
                insert srObj;
                
                // Update PendingServiceRouting as IsReadyForRouting
                psrObj.IsReadyForRouting = TRUE;
                System.debug('\n **** psrObj *** \n'+psrObj);
                update psrObj;
            }
            return;
        }
    
    public static String getChannelId(String channelName) {
        ServiceChannel channel = [Select Id From ServiceChannel Where DeveloperName = :channelName];
        return channel.Id;
    }
    
    public static String getSkillId(String caseLanguage) {
        String skillName = 'English';
        if (caseLanguage != null) {
            skillName = caseLanguage;
        }
        
        //Skill test = [Select Id, DeveloperName From Skill Where DeveloperName =: skillName][0];
        return [Select Id From Skill Where DeveloperName =: skillName].Id;
    }
}