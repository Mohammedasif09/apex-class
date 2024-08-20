import { LightningElement, wire,track } from 'lwc';
import getUserList from '@salesforce/apex/SkillResource.getUserList';
import getServiceResource from '@salesforce/apex/SkillResource.getServiceResource'
import skillList from '@salesforce/apex/SkillResource.skillList'
import createServiceUserSkill from '@salesforce/apex/SkillResource.createServiceUserSkill'
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import ServiceResource_OBJECT from '@salesforce/schema/ServiceResource';
import ResourceType from '@salesforce/schema/ServiceResource.ResourceType';
import createServiceResource from '@salesforce/apex/SkillResource.createServiceResource'
export default class SkillsResource extends LightningElement {
    @track userList = [];
    @track userDetails = [];
    @track id;
    openDropDownFired = false;
    @ track selectedMetadataLabel = '';
    @ track results = '';
    isSelectUserList = false;
    @track serviceUsers = '';
    isLoaded = true;
    @track selectedUsers = []
    @track ServiceResources = []
    
    @wire(getObjectInfo, { objectApiName: ServiceResource_OBJECT })
    ServiceResource;

    @wire(getPicklistValues,
        {
            recordTypeId: '$ServiceResource.data.defaultRecordTypeId',
            fieldApiName: ResourceType
        })
    ResourceTypeValues;
    
    @wire (getUserList) user({error, data}) {
        // method to get all the users and push key value
        if(data) {  
            
            for(let index = 0; index < data.length; index++) {
                this.userList = [...this.userList, {value :data[index].Id, label: data[index].Name}]
            }
        }
        else {
            console.log(error);
        }
    } 

    showSearchResults(event){ // Method to handle input and filter dropdown 
        this.isSelectUserList = false;
        let searchValue = event.target.value;
        this.selectedMetadataLabel = searchValue;
        if(this.userList.length > 0) {
            this.results = this.userList.filter(item=> {
            let itemLabel = item.label.toLowerCase();
            if(itemLabel.includes(searchValue.toLowerCase())){
                return item;
            }
            });  
            this.openDropDown();
            this.selectedMetadataLabel  = ''
        }  
    }

    openDropDown() {  //method to open drop down
        if(this.results.length < 1) {
            this.closeDropDown();
            this.results = this.userList;
            return;
        }       
         
        if(!this.openDropDownFired) {
            let node = this.template.querySelector('.slds-dropdown-trigger');
            if (node && node.className.indexOf('slds-is-open') === -1) {
                node.classList.add('slds-is-open');
            }    
        }
        this.openDropDownFired = true;
        setTimeout(function(self) {
           self.openDropDownFired = false;
        }, 100, this);
    }

    closeDropDown() { // Mehtod to close drop down
        let node = this.template.querySelector('.slds-dropdown-trigger');
        if (node && node.className.indexOf('slds-is-open') != -1) {
            node.classList.remove('slds-is-open');
        }
    }

    selectItem(event){ // Method to handle selected value from multipicklist
        this.isSelectUserList = true;
        this.selectedMetadataLabel =  event.currentTarget.dataset.label;
        this.closeDropDown();
        console.log('Selected Label = ', this.selectedMetadataLabel);
        this.applyHasSelected(event.currentTarget);
        this.scrollToSelectedNode(event.currentTarget); 
        this.id = event.currentTarget.dataset.value
        console.log('this.id ' + this.id)
        this.isLoaded = false
        for(let index = 0; index < this.userDetails.length; index++) {
            if(this.userDetails[index].RelatedRecordId === this.id){
                this.userDetails.splice(index, 1)
            }
        } 
        getServiceResource({userId : this.id}) // To get ServiceResource Related User
        .then(result => { 

            this.serviceUsers = result;
            if(result.length > 0) {
                for(let index = 0; index <result.length; index++){
                    console.log('lopp--' + this.id)
                    let arr = this.userDetails;
                    arr.push({UserName : this.selectedMetadataLabel, RelatedRecordId :this.id,
                            Name :this.serviceUsers[index].Name, Id : this.serviceUsers[index].Id,
                            ResourceType : this.serviceUsers[index].ResourceType,
                            IsActive: this.serviceUsers[index].IsActive, Description: this.serviceUsers[index].Description })
                            this.userDetails = arr;
                }
         
                this.selectedUsers.push({UserName :this.selectedMetadataLabel, userId :this.id})
                for(let index = 0; index <= this.userList.length; index++) {  
                    if(this.userList[index].value === this.id) {
                        this.userList.splice(index, 1)
                        break;
                    }
                }
                console.log('Result1-- ' + JSON.stringify(result)) 
            }
            else {
                
            }
        });
        setTimeout(() => {
            this.isLoaded = true;
          }, 1000);
    }
    
    scrollToSelectedNode(selectedNode, asyncScroll) {
        let lstBox = this.template.querySelector('.slds-dropdown');
        if(lstBox && selectedNode) {
            lstBox.scrollTop = selectedNode.offsetTop;
            if(asyncScroll)
                setTimeout(function() {
                    lstBox.scrollTop = selectedNode.offsetTop;
                }, 10);            
        }
    }

    removeHasSelected(node){
        node.childNodes.forEach(function(nodeChild) {
            if(nodeChild.className.indexOf('hasSelected') != -1) {
                nodeChild.classList.remove('hasSelected');
            }
        })
    }

    applyHasSelected(node) {
        this.removeHasSelected(node.parentNode);  
        if(node.className.indexOf('hasSelected') == -1) {
            node.classList.add('hasSelected')
        }
    }

    handleFocusLostInputBox(event){ // method to close dropdown
        this.closeDropDown();
    }

    setInputBoxValue(event, value){
        event.currentTarget.value = value;
        this.selectedMetadataLabel = event.currentTarget.label;
    }

    preventFocus(event) {
        event.preventDefault();
    }

    changeUserHandler(event) {
        if(event.target.name === 'serviceResourceName') {
            this.userDetails[event.target.accessKey].Name = event.target.value
        }
        else if(event.target.name === 'isActive') {
            this.userDetails[event.target.accessKey].IsActive = event.target.checked
        }
        else if(event.target.name === 'resourceType') {
            this.userDetails[event.target.accessKey].ResourceType = event.target.value
        }
        else if(event.target.name === 'description') {
            this.userDetails[event.target.accessKey].Description = event.target.value
        }
    }

    handleDelete(event) {
        
        let flag = 0;
        for(let index = 0; index < this.userList.length; index++) {
            if(this.userList[index].value === event.currentTarget.dataset.value) {
                flag = 1;
                break;
            } 
        }
        if(flag === 0){
            this.userList.push({value :event.currentTarget.dataset.value, label: event.currentTarget.dataset.label})
        }
        
        for(let index = 0; index <= this.userDetails.length; index++) {
         
            if(this.userDetails[index].Id === event.currentTarget.dataset.id) {
                this.selectedUsers.splice(index, 1)
                this.userDetails.splice(index, 1)
                break;    
            }  
        }
    }

    ////////////////////////////////////////////////////

    @track listOfSkill = []
    @track skillResult = '';
    @track selectedSkill = ''
    @track listOfServiceUserSKill = []
    openDropDownSkill = false;
    @track skillId;
    @track serviceUserSkill = [];
    @track serviceResourceIds =[]
    
    @wire (skillList) skill({error, data}) { // Method to get all the skills.
        if(data) {       
            for(let index = 0; index < data.length; index++) {
                this.listOfSkill = [...this.listOfSkill, {value :data[index].Id, label: data[index].MasterLabel}]
            }
        }
        else {
            console.log(error);
        }
    }
    
    showUserSkill(event) { // Method to handle input and filter dropdown 
        this.isSelectUserList = false;
        let searchValue = event.target.value;
        this.selectedSkill = searchValue;
        if(this.listOfSkill.length > 0) {
            this.skillResult = this.listOfSkill.filter(item=> {
                let itemLabel = item.label.toLowerCase();
                if(itemLabel.includes(searchValue.toLowerCase())){
                    return item;
                }
            }); 
            this.openDropDownSkills();
            this.selectedSkill  = ''
        }  
    }

    openDropDownSkills() { 
        if(this.skillResult.length < 1){
            this.closeDropDownSkill();
            this.skillResult = this.listOfSkill;
            return;
        }       
         
        if(!this.openDropDownSkill){
            let node = this.template.querySelector('.dropdown1');
            if (node && node.className.indexOf('slds-is-open') === -1) {
                node.classList.add('slds-is-open');
            }    
        }
        this.openDropDownSkill = true;
        setTimeout(function(self) {
           self.openDropDownSkill = false;
        }, 100, this);
    }

    closeDropDownSkill() {  // Method to close drop down
        let node = this.template.querySelector('.dropdown1');
        if (node && node.className.indexOf('slds-is-open') != -1) {
            node.classList.remove('slds-is-open');
        }
    }

    selectItemSkill(event) { // Method to handle selected value from multipicklist
        this.isSelectUserList = true;
        this.selectedSkill =  event.currentTarget.dataset.label;
        this.closeDropDownSkill();
        this.applyHasSelectedSkill(event.currentTarget);
        this.scrollToSelectedNodeSkill(event.currentTarget); 
        this.skillId = event.currentTarget.dataset.value
        console.log('selected '+ this.serviceUserSkill.length)
        this.serviceUserSkill.push({  
            SkillLevel : '',
            EffectiveStartDate : '',
            EffectiveEndDate : '',
            ServiceResourceId : '',
            SkillName : this.selectedSkill,
            SkillId : this.skillId
        }); 
        
        for(let index = 0; index < this.listOfSkill.length; index++) {  
          
            if(this.listOfSkill[index].label === this.selectedSkill) {
                this.listOfSkill.splice(index, 1)
                break;
            }
        }  
    }
    
    scrollToSelectedNodeSkill(selectedNode, asyncScroll) {
        let lstBox = this.template.querySelector('.slds-dropdown');
        if(lstBox && selectedNode) {
            lstBox.scrollTop = selectedNode.offsetTop;
            if(asyncScroll)
                setTimeout(function() {
                    lstBox.scrollTop = selectedNode.offsetTop;
                }, 10);            
        }
    }

    removeHasSelectedSkill(node) {
        node.childNodes.forEach(function(nodeChild){
            if(nodeChild.className.indexOf('hasSelected') != -1){
                nodeChild.classList.remove('hasSelected');
            }
        })
    }

    applyHasSelectedSkill(node) {
        this.removeHasSelectedSkill(node.parentNode);  
        if(node.className.indexOf('hasSelected') == -1){
            node.classList.add('hasSelected')
        }
    }

    handleFocusLostInputBoxSkill(event){ // method to close dropdown
        this.closeDropDownSkill();
    }

    setInputBoxValueSkill(event, value){
        event.currentTarget.value = value;
        this.selectedSkill = event.currentTarget.label;
    }

    preventFocusSkill(event){
        event.preventDefault();
    } 

    changeHandler(event) {  // Method to handle filling the current value in the field
        if(event.target.name === 'skillLevel') {
            this.serviceUserSkill[event.target.accessKey].SkillLevel = event.target.value
        }
        else if(event.target.name === 'startDate') {
            this.serviceUserSkill[event.target.accessKey].EffectiveStartDate = event.target.value
        }
        else if(event.target.name === 'endDate') {
            this.serviceUserSkill[event.target.accessKey].EffectiveEndDate = event.target.value
        }
    }

    handleskillDelete(event) {
        this.listOfSkill.push({value :event.currentTarget.dataset.value, label: event.currentTarget.dataset.label})
        this.serviceUserSkill.splice(event.target.accessKey, 1);
        if(this.serviceUserSkill.length == 0){
            
        }
    }
   
    handleSave() {
        
        if(this.userDetails.length > 0){  
            createServiceResource({serviceResourceList : this.userDetails}).then(result => {
            
                if(result.length > 0 && this.serviceUserSkill.length > 0) {
                    result.forEach(element => {
                        this.serviceUserSkill.forEach(element1 => {
                            let obj = element1;
                            obj.ServiceResourceId = element;
                            if(obj.EffectiveStartDate != '') {
                                this.listOfServiceUserSKill.push(Object.assign({}, obj));
                            }
                        });    
                    });
                    const evt = new ShowToastEvent({
                        title: 'Success',
                        message: "Service Resource has been upserted successfully.",
                        variant: 'success',
                        mode: 'dismissable'
                    });
                    this.dispatchEvent(evt); 
                    this.method(this.listOfServiceUserSKill);
                }
                else {
                    const evt = new ShowToastEvent({
                        title: 'Already Exist',
                        message: 'failed',
                        variant: 'Error',
                        mode: 'dismissable'
                    });
                    this.dispatchEvent(evt);
                }
            }).catch(error =>{
                        console.log(error)
                }) 
            } else{
                const evt = new ShowToastEvent({
                    title: 'Please Select Users..',
                    message: 'Required',
                    variant: 'Error',
                    mode: 'dismissable'
                });
                this.dispatchEvent(evt);
            }
    } 

    method(listOfServiceUserSKill) {
    
        if(listOfServiceUserSKill.length > 0) {
            createServiceUserSkill({srviceUserSkill : listOfServiceUserSKill}).then(result => {
                if(result == 'success') {
                    let accesskey = []
                    this.serviceUserSkill.forEach(element => {
                        accesskey.push(element.accessKey)
                        this.listOfSkill.push({value : element.SkillId, label : element.SkillName})
                    });
                    for(let index = 0; index < accesskey.length; index++){
                        this.serviceUserSkill.splice(accesskey[index], 1)
                    }
                
                    this.userDetails.forEach(element =>{ 
                        if(this.userList.length > 0){
                            let flag =0;
                            this.userList.forEach(element1 =>{
                                if(element1.value === element.RelatedRecordId){
                                    flag = 1;
                                }
                            })
                            if(flag ==0)
                                this.userList.push({value :element.RelatedRecordId, label: element.UserName})
                        }
                        else{
                            this.userList.push({value :element.RelatedRecordId, label: element.UserName})
                        } 
                    });
                    this.userDetails.splice(0,this.userDetails.length)
                }
                else if(result == 'failed') {
                    
                    const evt = new ShowToastEvent({
                        title: 'Already Exist',
                        message: 'Please Select Different Skill',
                        variant: 'Error',
                        mode: 'dismissable'
                    });
                    this.dispatchEvent(evt);
                }
            }) .catch(error =>{
                        console.log(error)
                })  
        } 
    }
}