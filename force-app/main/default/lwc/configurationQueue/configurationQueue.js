import { LightningElement ,wire,track} from 'lwc';
import getAllObjList from '@salesforce/apex/ServiceCloudConfiguration.getAllObjList';
import getAllFields from '@salesforce/apex/ServiceCloudConfiguration.getAllFields';
import getPickListvalue from '@salesforce/apex/ServiceCloudConfiguration.getPickListvalue'
import saveConfigu from '@salesforce/apex/ServiceCloudConfiguration.saveConfigu';
import getConfiguration from '@salesforce/apex/configurationController.getConfiguration';
import saveConfiguration from '@salesforce/apex/configurationController.saveConfiguration';
//import pickListValueDynamically from '@salesforce/apex/SobjectListController.pickListValueDynamically';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import ServiceResource_OBJECT from '@salesforce/schema/Configuration__c';
import Status__c from '@salesforce/schema/Configuration__c.Status__c';



import SystemModstamp from '@salesforce/schema/Account.SystemModstamp';
export default class ConfigurationQueue extends LightningElement {
    @wire(getObjectInfo, { objectApiName: ServiceResource_OBJECT })
    Configuration__c;

    @wire(getPicklistValues,
        {
            recordTypeId: '$Configuration__c.data.defaultRecordTypeId',
            fieldApiName: Status__c
        })
    ResourceTypeValues;


 



  
    @track configurationList;
    @track keyIndex = 0;
    @track configurationList = [{
             Id:'',
              Name:'',
              Status__c:'',
              Object__c:''}
        
];

    
    @wire (getConfiguration) user({error,data}){
       
        
           if (data) {
               for(let index =0; index<data.length; index++){
                   this.configurationList = [...this.configurationList, {Id : data[index].Id,Name:data[index].Name,Status : data[index].Status__c,Objec : data[index].Object__c}]
               }
               
               let tempList = [];
               data.forEach(element => {
                   tempList.push(element);
               });
               this.configurationList = tempList;
               //console.log(JSON.stringify(data));
           } 
           else  {
               console.log(error);
           }
       }
   changHandler(event){
    //console.log('Access Key = ' , this.configurationList);
    let obj = JSON.parse(JSON.stringify(this.configurationList[event.currentTarget.dataset.accessKey]));
        if(event.target.name === 'configName'){
            obj.Name = event.target.value;
        }
        else if(event.target.name === 'Status'){

            console.log('Status-->>',event.target.value);
            obj.Status__c = event.target.value;
           // JSON.parse(JSON.stringify(this.configurationList[event.currentTarget.dataset.accessKey])).Status__c = event.target.value
            
        }
        else if(event.target.name === 'Object'){ 
            console.log('Objectiii'+event.target.value); 
            obj.Object__c =  event.target.value;  
            //JSON.parse(JSON.stringify(this.configurationList[event.currentTarget.dataset.accessKey])).Object__c = event.target.value
        }
        else if(event.target.name === 'AgentCapacity'){ 
            console.log('Objectiii'+event.target.value); 
            obj.Agent_Capacity__c =  event.target.value;  
            //JSON.parse(JSON.stringify(this.configurationList[event.currentTarget.dataset.accessKey])).Object__c = event.target.value
        }
        this.configurationList[event.currentTarget.dataset.accessKey] = obj;
   }

   handleSave(){
       
    console.log('exe---'+JSON.stringify(this.configurationList));
    saveConfiguration({config : this.configurationList})
    .then(result => {
        console.log('result---' +result);
                       
    }).catch(error=>{
        console.log(this.error);
    })
}
    @track mapData= [];
    @track feildsObj;
    @track fieldData = [];
    @track fieldValue  = [] ;
    @track selectField;
    @track fieldSelect  ;
    @track value;
    loaded = false;
    

    @track object;
    @wire(getAllObjList)
    wiredResult(result) { 
        if (result.data) {
            //mapData = [];
            var conts = result.data;
            console.log('result'+ (JSON.stringify(result)));
            let arr = [];
            for(var key in conts){
                console.log('constkey'+ conts[key]);
                arr.push({label:conts[key], value:key}); //Here we are creating the array to show on UI.
            }
            this.mapData = arr;
        }
    }
    
    handleChange(event){
        console.log('this.fieldValue before '+ this.fieldValue);
        this.fieldValue.splice(0,this.fieldValue.length);
        console.log('this.fieldValue after '+ this.fieldValue);
        console.log('Object = ' + event.target.value);
        let arr = [];
        this.object = event.target.value;
        
        getAllFields({obj: this.object})
        .then(result => {
            console.log('message', result);
            //var conts = result.data;
            console.log('result'+ (JSON.stringify(result)));
            
            
           
            console.log('result---execute'+ (JSON.stringify(result)));
            let arr = [];
            for(var key in result){
                console.log('constkey'+ result[key]);
                arr.push({label:result[key], value:key}); //Here we are creating the array to show on UI.
            }
            this.fieldData = arr;
            result.forEach(element => {
            arr.push({label:element, value:element}); //Here we are creating the array to show on UI.
            this.fieldData = arr;  
            });
            console.log('this result--->'+this.fieldData);
       
        })
        .catch(error => {
            this.error = error;
        });
    }
    handleChangeField(e){
        console.log('Field===>' + e.target.value);
        this.selectField = e.target.value;
        console.log('selectField---',this.selectField);
        getPickListvalue({selectedObject: this.object, field: this.selectField})
        .then(result => {
               
                if(result.length > 0){

                    result.forEach(element => {
                        this.fieldValue = [...this.fieldValue, {value :element, label: element}]
                    });

                
            }else{
                this.fieldValue = []; 
            }
                
            });
    
    }
    handleChangeFieldValue(e){
    //.log('e-->' + e.target.value);
     //this.fieldSelect = e.target.value;
     
    }
   handleValueChange(event){
    
        console.log("value --> "+JSON.stringify(event.detail));
        this.fieldSelect = event.detail[0];
        console.log('this.fieldSelect'+this.fieldSelect[0]);
    }
    @track configInsertList = {
              
        Name:'',
        Status__c:'',
        Object__c:'',
        Agent_Capacity__c:''


    };
     handlesSaveRecord(){
        console.log('this.fiel'+this.fieldSelect);
        const inputData = this.template.querySelectorAll(".frmInput");
        this.configInsertList.Name = inputData[0].value;
        this.configInsertList.Agent_Capacity__c = inputData[1].value;
        this.configInsertList.Status__c = this.fieldSelect;
        this.configInsertList.Object__c=  this.object;
        

     console.log('hii');
          
          console.log('configInsertList-->',(JSON.stringify(this.configInsertList)));

          
          saveConfigu({Configuration : this.configInsertList}).then(result =>{
    console.log("@@@")
      console.log(result)
    
        this.configInsertList.Name ='';
        this.configInsertList.Agent_Capacity__c = '';
        this.configInsertList.Status__c ='';
       this.configInsertList.Object__c ='';
  
  }).catch(error =>{
      console.log(error)

    })
    
    }
    
   

      
    
}