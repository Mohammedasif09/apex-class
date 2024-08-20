import { LightningElement, api, track } from 'lwc';

export default class FilterCriteria extends LightningElement {
    @api displayIndex;

    @api fieldsList = [];
    hasRendered = true;
    @api fieldSelect;
    @api fields = [];
    fieldData = [];
    @api fieldList = [];
    results;
    selectedLabel = '';
    renderedCallback() {
        if (this.hasRendered && this.fieldsList) {
            this.hasRendered = false;
            
            this.template.querySelectorAll('lightning-combobox').forEach(element => {
                element.classList.remove('slds-form-element_horizontal');
            });
        }
    }

    // @api getFields(fields) {
    //     console.log('Child ', fields);
    //     this.fieldData = [];
    //     this.fieldData = JSON.parse(JSON.stringify(fields));
    // }
    handleField(event) {

        console.log('event.target-', this.event.value);
    }

    removeRows(event) {
       
        let rowId = event.currentTarget.dataset.id;
        console.log('rowId-->', rowId);
        const passEvent = new CustomEvent('removerow', {
            detail: { recordId: rowId }
        });
        this.dispatchEvent(passEvent);

    }
    showSearchResults(event){ // Method to handle input and filter dropdown
        let searchValue = event.target.value;
        //this.selectedMetadataLabel = searchValue;
        //console.log('searchValue = ' , searchValue);
        //console.log('this.fieldDTA' , JSON.parse(JSON.stringify(this.fieldList)))
        this.fieldData = JSON.parse(JSON.stringify(this.fieldList));
        this.results = this.fieldData.filter(item=> {
            console.log('Label = ', item.label.includes(searchValue))
            let itemLabel = item.label.toLowerCase();
            if(itemLabel.includes(searchValue.toLowerCase())){
                return item;
            }
        });
        this.openDropDown();
    }

    handleFocusLostInputBox(event){
        this.closeDropDown();
        if(this.template.querySelector('.hasSelected')){
            console.log('this.template.querySelector' , this.template.querySelector('.hasSelected'));
            this.template.querySelector('.hasSelected').classList.remove('hasSelected');
        }
        
    }
    openDropDown() {
       
        if(this.results.length < 1){
            this.closeDropDown();
            this.results = this.listName;
            return;
        }       
        //console.log('openDropDownFired',this.openDropDownFired);     
        if(!this.openDropDownFired){
            let node = this.template.querySelector('.slds-dropdown-trigger');
            if (node && node.className.indexOf('slds-is-open') === -1) {
                node.classList.add('slds-is-open');
            }    
            //console.log('select list item');
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

    // removeHasSelected(node){
    //     node.childNodes.forEach(function(nodeChild){
    //         if(nodeChild.className.indexOf('hasSelected') != -1){
    //             nodeChild.classList.remove('hasSelected');
    //         }
    //     })
    // }

    // applyHasSelected(node){
    //     this.removeHasSelected(node.parentNode);  
    //     if(node.className.indexOf('hasSelected') == -1){
    //         node.classList.add('hasSelected');
    //     }
    // }

    selectItem(event){
        this.selectedLabel = event.currentTarget.dataset.label;
        console.log('selectedlabel' , this.selectedLabel)
        this.closeDropDown();
    }

}