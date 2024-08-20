import { LightningElement ,api, track, wire } from 'lwc';
import getRecord from '@salesforce/apex/onlinceUserController.getRecord';
import { NavigationMixin, CurrentPageReference } from 'lightning/navigation'; 
export default class UtilityBarService extends NavigationMixin(LightningElement) {
    showMenu = false;
    isshowSpinner = true;
    @track objectLists = [];
    @api strTitle;
    @track data;
    @track radiostatus = 'Offline';
    @track objectN
    arr;
    hasRendered = true;
    CurrentPageReference 
    // objectN = window.location.pathname;
     
    options = [
        {'label': 'Online', 'value': 'online'},
        {'label': 'Offline', 'value': 'offline'},
        {'label': 'Buzy', 'value': 'busy'}
    ];

      
    
    columns = [
        { label: ' Name ', fieldName: 'Name' },
        {type: "button", typeAttributes: {  
              
            name: 'view',  
            title: 'view',  
            iconName: 'action:approval', 
            value: 'view',  
            iconPosition: 'left'  
        }}  
    ];
    
    @wire(CurrentPageReference)
    pageRef;

    get status(){
        return this.radiostatus;
    }
    
     

    renderedCallback(){
        window.addEventListener('locationchange', function(){
            console.log('location changed!');
        })
    }
   /* constructor() {
        super(); 
        console.log('i am constructor ' , this.pageRef)   
        console.log('connected' , this.pageRef)
    } */

   /* connectedCallback() {
        //let arr ;
        objectN = 	window.location.pathname.split('/');
        let arr =  objectN[3]; 
        this.data = [];
        getRecord({ Obj:  arr }) // To get ServiceResource Related User
        .then(result => {
            this.data = JSON.parse(JSON.stringify(result));
            //this.objectFields = result;
        });
    } */

    
handleshow() {
    if(this.showMenu){
        this.showMenu =false;
    }
    else {
        this.showMenu = true;
    }
}

handleclick(event) {
    console.log('this.pageRef' , this.pageRef)
    const radioButtonVal = event.detail.value;
    this.radiostatus = radioButtonVal;
    this.showMenu = false;
    
    this.objectN  =	this.pageRef.attributes.objectApiName;
        console.log('objectN ======' ,this.objectN)
        //this.arr =  objectN[3]; 
        this.data = [];
        if(this.objectN == 'Case'){
            console.log('hello sir');
            this.columns = [] ;
            this.columns = [
                { label: 'Case Number', fieldName: 'CaseNumber' },
                {type: "button", typeAttributes: {  
                      
                    name: 'view',  
                    title: 'view',  
                    iconName: 'action:approval', 
                    value: 'view',  
                    iconPosition: 'left'  
                }}  
            ];
        }
        else{
            this.columns = [] ;
            this.columns = [
                { label: ' Name ', fieldName: 'Name' },
                {type: "button", typeAttributes: {  
                      
                    name: 'view',  
                    title: 'view',  
                    iconName: 'action:approval', 
                    value: 'view',  
                    iconPosition: 'left'  
                }}  
            ];

        }
        getRecord({ Obj:  this.objectN }) // To get ServiceResource Related User
        .then(result => {
            this.data = JSON.parse(JSON.stringify(result));
            //this.objectFields = result;
        }); 
}
handleRowAction(event){

    const Name = event.detail.action.name;
    const row = event.detail.row.Id;
    console.log('Name Data ====>' ,Name);
    console.log('Name Row ====>' , row);
    this[NavigationMixin.Navigate]({
        type: 'standard__recordPage',
        attributes: {
            recordId: row,
            objectApiName: this.Object,
            actionName: 'view'
        },
    });
}

}