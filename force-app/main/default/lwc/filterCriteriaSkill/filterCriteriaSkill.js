import { LightningElement, api, track , wire } from 'lwc';
import getUserSkill from '@salesforce/apex/ServiceCloudConfiguration.getUserSkill'
export default class FilterCriteria extends LightningElement {
    @track userSkillList = [];
    @api selectedUserSkillList; 
    @api displayIndex;
    @api fieldsList ;
    @api selectedField = '';
    @api selectedValue = ''
    hasRendered = true;
    @api fieldSelect;
    @api fields = [];
    fieldData = [];
    @api fieldList = [];
    results;
    selectedLabel = '';
    @track selectedValue = [];
    onSelectDisable = false;
    @track tempObj = [];
    @track userSkillListTemp = [];

    @wire(getUserSkill) getSkill({error , data}){
        if (data) {
            let tempArr = [];
            console.log('Data ' , data);
            data.forEach(element => {
               tempArr.push({label : element.Skill_Name__c, value : element.Id});
            })
            this.userSkillListTemp = tempArr;
        }
        else {
            console.log(error);
        }      
    }
    renderedCallback() {
        if (this.hasRendered && this.fieldsList) {
            this.hasRendered = false;

            this.template.querySelectorAll('lightning-combobox').forEach(element => {
                element.classList.remove('slds-form-element_horizontal');
            });
            console.log('fieldList', JSON.parse(JSON.stringify(this.fieldList)))
        }
    }

    removeRows(event) {
        let removeSelectedLabel = event.currentTarget.dataset.label;
        let removeSelectedValue = event.currentTarget.dataset.value;
        this.displayIndex = event.currentTarget.dataset.id;
        console.log('Id-->', this.displayIndex);
        let tempObj = {
            removeSelectedLabel: removeSelectedLabel,
            removeSelectedValue: removeSelectedValue,
        };
        console.log('tempObj', tempObj);
        const passEvent = new CustomEvent('removerow', {
            detail: { recordId: this.displayIndex, removeRow: tempObj}
        });
        this.dispatchEvent(passEvent);

    }
    showSearchResults(event) { // Method to handle input and filter dropdown
        let searchValue = event.target.value;
        this.fieldData = JSON.parse(JSON.stringify(this.fieldList));
        this.results = this.fieldData.filter(item => {
            let itemLabel = item.label.toLowerCase();
            if (itemLabel.includes(searchValue.toLowerCase())) {
                return item;
            }
        });
        this.openDropDown();
    }

    handleFocusLostInputBox() {
        this.closeDropDown();

    }
    openDropDown() {

        if (this.results.length < 1) {
            this.closeDropDown();
            this.results = this.listName;
            return;
        }

        if (!this.openDropDownFired) {
            let node = this.template.querySelector('.slds-dropdown-trigger');
            if (node && node.className.indexOf('slds-is-open') === -1) {
                node.classList.add('slds-is-open');
            }

        }
        this.openDropDownFired = true;
    }

    closeDropDown() {
        let node = this.template.querySelector('.slds-dropdown-trigger');
        if (node && node.className.indexOf('slds-is-open') != -1) {
            node.classList.remove('slds-is-open');
        }
    }
    scrollToSelectedNode(selectedNode, asyncScroll) {
        let lstBox = this.template.querySelector('.slds-dropdown');
        if (lstBox && selectedNode) {
            lstBox.scrollTop = selectedNode.offsetTop;
            if (asyncScroll)
                setTimeout(function () {
                    lstBox.scrollTop = selectedNode.offsetTop;
                }, 10);
        }
    }

    removeHasSelected(node) {
        node.childNodes.forEach(function (nodeChild) {
            if (nodeChild.className.indexOf('hasSelected') != -1) {
                nodeChild.classList.remove('hasSelected');
            }
        })
    }

    applyHasSelected(node) {
        this.removeHasSelected(node.parentNode);
        if (node.className.indexOf('hasSelected') == -1) {
            node.classList.add('hasSelected');
        }
    }

    selectedItem(event) {
        this.selectedLabel = event.currentTarget.dataset.label;
        this.selectedValue = event.currentTarget.dataset.value;
        this.selectedField = this.selectedLabel;
        this.closeDropDown();
        console.log('this.selectedValue', this.selectedValue)
        this.tempObj = {
            Id: this.displayIndex,
            selectedField: this.selectedField,
            selectedValue: this.selectedValue,
            selectedUserSkillList:'',
        };
        console.log('Child Component', this.tempObj);
        this.userSkillList = this.userSkillListTemp;
        //this.dispatchEvent(new CustomEvent('selectedvalue', { detail:tempObj }));
        this.onSelectDisable = true;
    }

    setInputBoxValue(event, value) {
        event.currentTarget.value = value;
        this.selectedLabel = event.currentTarget.label;
    }
    preventFocus(event) {
        event.preventDefault();
    }

    handleSelectedUserSkill(event){

        this.tempObj.selectedUserSkillList = event.detail;
        this.dispatchEvent(new CustomEvent('selectedvalue', { detail:this.tempObj }));
        //this.tempObj = [];

    }
}