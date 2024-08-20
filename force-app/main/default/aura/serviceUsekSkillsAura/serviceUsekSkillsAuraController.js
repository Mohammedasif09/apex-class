({    
    doInit : function(component, event, helper) {
        //console.log(component.get("v.pageReference").state);
        var urlString = window.location.href;
        if(urlString.includes('1.') && urlString.includes('%3D')){
            var splitData = urlString.split('1.').pop().split('%3D')[0]; 
            var data = window.atob(splitData);
            var parseData = JSON.parse(data);
            var recordId = parseData.attributes.recordId;
           	 
            
            component.set("v.userRecord", recordId);
            console.log(recordId);
        }else{
            console.log('parseData.attributes.recordId');  
        }
        //console.log(window.atob(splitData).attributes.recordId);
    }
    
})