import { LightningElement, wire, track } from 'lwc';
import getServiceResource from '@salesforce/apex/SkillAddRemoveController.getServiceResource'
import getSkills from '@salesforce/apex/SkillAddRemoveController.getSkills'
import deleteServiceResourceSkill from '@salesforce/apex/SkillAddRemoveController.deleteServiceResourceSkill'
import { ShowToastEvent } from 'lightning/platformShowToastEvent'
export default class SkillAddRemoveAssignment extends LightningElement {
    @track serviceResourceList = [];
    openDropDownFired = false;
    selectedMetadataLabel = '';
    results = '';
    //isSelectAgentQueue = false;
    isSelectServiceResource = false
    @track serviceResourceSkills = [];
    @track serviceresourceIds =[];
    @track tempArr = [];

    @wire (getServiceResource) serviceResource({error, data}){
        if(data){
            data.forEach(element => {
                let labelDisplay;
               labelDisplay = element.Name +'-'+ element.ResourceType;
               this.serviceResourceList = [...this.serviceResourceList, {value : element.Id, label: labelDisplay}]
            });
        }
        else{
            console.log(error);
        }
    }
    
    showSearchResults(event){ // Method to handle input and filter dropdown
        this.isSelectServiceResource = false;
        let searchValue = event.target.value;
        this.selectedMetadataLabel = searchValue;
        if(this.serviceResourceList.length > 0){
            this.results = this.serviceResourceList.filter(item=> {
                let itemLabel = item.label.toLowerCase();
                if(itemLabel.includes(searchValue.toLowerCase())){
                    return item;
                }
            });
            this.openDropDown();
        }
    }

    openDropDown() {
       
        if(this.results.length < 1){
            this.closeDropDown();
            this.results = this.serviceResourceList;
            return;
        }           
        if(!this.openDropDownFired){
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

    closeDropDown(){
        let node = this.template.querySelector('.slds-dropdown-trigger');
        if (node && node.className.indexOf('slds-is-open') != -1) {
            node.classList.remove('slds-is-open');
        }
    }

    selectItem(event){ // Method to handle selected value from multipicklist
        this.selectedMetadataLabel = '';
        this.isSelectServiceResource = true;
        this.selectedMetadataLabel =  event.currentTarget.dataset.label;
        console.log('In select Item function id '+ event.currentTarget.dataset.value)
        this.closeDropDown();
        console.log('Selected Agent Queue = ', this.selectedMetadataLabel);
        this.applyHasSelected(event.currentTarget);
        this.scrollToSelectedNode(event.currentTarget);
        getSkills({serviceResourceId : event.currentTarget.dataset.value })
        .then( results =>{ 
            if(results.length > 0){
                results.forEach(element =>{
                    this.serviceResourceSkills.push({
                        ServiceResourceName :this.selectedMetadataLabel,
                        Id : element.Id,
                        MasterLabel : element.Skill.MasterLabel,
                        SkillLevel : element.SkillLevel,
                        EffectiveStartDate : element.EffectiveStartDate,
                        EffectiveEndDate :element.EffectiveEndDate
                    });
                })    
            }
            

            console.log('skills--> '+ JSON.stringify(this.serviceResourceSkills));
            }); 
            for(let index = 0; index <= this.serviceResourceList.length; index++) {
         
                if(this.serviceResourceList[index].value === event.currentTarget.dataset.value) {
                   
                    this.serviceResourceList.splice(index, 1)
                    break;    
                }   
               
            }
    
    }

    scrollToSelectedNode(selectedNode, asyncScroll){
        let lstBox = this.template.querySelector('.slds-dropdown');
        if(lstBox && selectedNode){
            lstBox.scrollTop = selectedNode.offsetTop;
            if(asyncScroll)
                setTimeout(function() {
                    lstBox.scrollTop = selectedNode.offsetTop;
                }, 10);            
        }
    }

    removeHasSelected(node){
        node.childNodes.forEach(function(nodeChild){
            if(nodeChild.className.indexOf('hasSelected') != -1){
                nodeChild.classList.remove('hasSelected');
            }
        })
    }

    applyHasSelected(node){
        this.removeHasSelected(node.parentNode);  
        if(node.className.indexOf('hasSelected') == -1){
            node.classList.add('hasSelected');
        }
    }

    handleFocusLostInputBox(event){ // method to close dropdown
        this.closeDropDown();
    }

    setInputBoxValue(event, value){
        event.currentTarget.value = value;
        this.selectedMetadataLabel = event.currentTarget.label;
    }

    preventFocus(event){
        event.preventDefault();
    }

    handleServiceResourceSkillDelete(event){
        this.serviceResourceSkills.splice(event.target.accessKey, 1);
        console.log('value' + event.currentTarget.dataset.value)
        this.serviceresourceIds.push(event.currentTarget.dataset.value);
    }

    handleSave(){
      
        for(let i=0; i<this.serviceResourceSkills.length; i++){
            console.log('Validate Date',this.serviceResourceSkills[i]);
        }
        if(this.serviceresourceIds.length > 0){
            
            deleteServiceResourceSkill({ServiceResourceskillIds : this.serviceresourceIds}).then(result => {
            
                if(result === 'success') {   
                    const evt = new ShowToastEvent({
                        title: 'Success',
                        message: "Record Deleted successfully.",
                        variant: 'success',
                        mode: 'dismissable'
                    });
                this.dispatchEvent(evt);  
                this.serviceresourceIds.splice(0, this.serviceresourceIds.length);
                }
              
                }).catch(error =>{
                    console.log(error)
                }) 
        }
    }
    handleCancel(){

    }

}