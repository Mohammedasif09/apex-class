import { LightningElement,wire,track } from 'lwc';
import getConfiguration from '@salesforce/apex/configurationController.getConfiguration';
import saveConfiguration from '@salesforce/apex/configurationController.saveConfiguration';

export default class AddRowConfiguration extends LightningElement {
    @wire (getConfiguration) user({error,data}){
        
        if (data) {
                
            let tempList = [];
            data.forEach(element => {
                tempList.push(element);
            });
            this.ConfigurationList = tempList;
            console.log(JSON.stringify(data));
        } 
        else  {
            console.log(error);
        }
    }
   


    changHandler(event){
     let obj = JSON.parse(JSON.stringify(this.ConfigurationList[event.currentTarget.dataset.accessKey]));
         if(event.target.name === 'configName'){
             console.log('tiii'+event.target.value);
             obj.Name = event.target.value;
             console.log('tiii 2' ,this.ConfigurationList[event.currentTarget.dataset.accessKey]);
         }
         else if(event.target.Status === 'Status'){
             JSON.parse(JSON.stringify(this.ConfigurationList[event.currentTarget.dataset.accessKey])).Status__c = event.target.value
         }
         else if(event.target.Object === 'Object'){      
             JSON.parse(JSON.stringify(this.ConfigurationList[event.currentTarget.dataset.accessKey])).Object__c = event.target.value
         }
         this.ConfigurationList[event.currentTarget.dataset.accessKey] = obj;
    }

    addRow() {
     console.log('hii');
     //this.keyIndex++;
     let tempList = [];
     tempList = this.ConfigurationList;
      console.log('Final List 1= ', JSON.stringify(this.ConfigurationList));
      tempList.push({
                 Id : null,
                  Name : '',
                  Status__c : '',
                  Object__c : ''});
      this.ConfigurationList = tempList;
      
     console.log('Final List = ', JSON.stringify(this.ConfigurationList));
 }
 

    handleSave(){
    
     console.log('exe---'+JSON.stringify(this.ConfigurationList));
    saveConfiguration({config : this.ConfigurationList})
     .then(result => {
         console.log('result---' +result);
                        
     }).catch(error=>{
         console.log(this.error);
     })
 }

 
}