import { LightningElement, wire, track, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getObjects from '@salesforce/apex/ServiceCloudConfiguration.getAllObjList';
import getFields from '@salesforce/apex/ServiceCloudConfiguration.getFields';
import saveConfigu from '@salesforce/apex/ServiceCloudConfiguration.saveConfigu';
import getConfSkillList from '@salesforce/apex/ServiceCloudConfiguration.getSkills';
import getPicklistValues from '@salesforce/apex/ServiceCloudConfiguration.getPickListvalue';
import getQueues from '@salesforce/apex/ServiceCloudConfiguration.getQueues';
import configurationDataForUpdate from '@salesforce/apex/ServiceCloudConfiguration.getRecordForUpdate';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class AddConfiguration extends NavigationMixin(LightningElement) {

    @track queuseList = [];
    @track selectedQueueList = [];
    @track stringType = true;
    @track picklistType = false;
    @track fieldPicklistValue = [];
    @track objectLists = [];
    @track fields = [];
    @track configInsertList = [];
    @track arrSkills = [];
    @track arrFields = [];
    @track userSkillList = [];

    @api recordId;

    closeDopdown = true;
    cancelHide = false;
    showEditForm = false;
    updateRecordFlag = false;
    fieldComponentOff = true;
    isSkillBasedRouting = true;
    checkboxValue = false;
    loaded = true;
    conditionCheckboxValue = 'OR';
    buttonLebel = 'Save';
    successStatus = 'inserted';
    Object;
    selectedObjField;
    model = '';
    agentCapacity = '';
    operator = '';
    value = '';
    fieldSelect = '';
    conName = '';

    @wire(getConfSkillList, { objectAPIName: '$Object' })
    getSkill({ error, data }) {
        this.loaded = true;
        if (data) {
            let tempArr = [];
            data.userSkills.forEach(element => {
                tempArr.push({ label: element.Skill_Name__c, value: element.Id, selected: false });
            })
            this.userSkillList = tempArr;
            this.loaded = false;
        } else {
            console.log(error);
            this.loaded = false;
        }
    }

    @wire(getQueues) getQueue({ error, data }) {
        this.loaded = true;
        if (data) {
            let tempArr = [];
            data.forEach(element => {
                tempArr.push({ label: element.Name, value: element.Id });
            })
            this.queuseList = tempArr;
            this.loaded = false;
        }
        else {
            console.log(error);
            this.loaded = false;
        }
    }

    @wire(getObjects) getObj({ error, data }) {
        this.loaded = true;
        if (data) {
            for (var key in data)
                this.objectLists = [...this.objectLists, { value: key, label: data[key] }];
            this.loaded = false;
        }
        else {
            console.log(error);
            this.loaded = false;
        }
    }

    connectedCallback() {
        this.loaded = true;
        console.log('this.recordId');
        console.log('this.recordId',this.recordId);
        if (this.recordId) {
            this.cancelHide = true;
            configurationDataForUpdate({ recordId: this.recordId })
                .then(result => {
                    this.configurationRecords = result;
                    if (this.configurationRecords) { }
                    this.configurationRecordsForUpdate();
                    this.loaded = false;
                })
                .catch(error => {
                    this.error = error;
                });
        } else {
            this.loaded = false;
        }
    }

    handleDropdown(){
        console.log('@@@@@@@@@');
        this.template.querySelector("c-select").handleDropdownFromParent();
    }

    configurationRecordsForUpdate() {
        this.isSkillBasedRouting = false;
        this.updateRecordFlag = true;
        this.buttonLebel = 'Update';
        this.successStatus = 'updated';
        this.Object = this.configurationRecords.Object__c;
        this.getObjectFields();
        this.selectedObjField = this.configurationRecords.Status_Close_Field__c;
        this.conName = this.configurationRecords.Name;
        this.fieldSelect = this.configurationRecords.Status__c;
        this.model = this.configurationRecords.Model__c;
        this.conditionCheckboxValue = this.configurationRecords.Operator__c;
        this.agentCapacity = this.configurationRecords.Agent_Capacity__c;
        this.checkboxValue = this.configurationRecords.Skill_Based_Routing__c;
        this.selectedObjFieldValue = this.configurationRecords.Status_Close_Value__c;
        this.selectedQueuesList = this.configurationRecords.Configuration_Queues__r;
        console.log('this.selectedQueuesList',this.selectedQueuesList);
        let checkboxes = this.template.querySelector('[data-id="checkboxId"]');
        checkboxes.checked = this.configurationRecords.Skill_Based_Routing__c;
        if (this.checkboxValue) {
            this.fieldComponentOff = false;
            this.selectedSkillsList = this.configurationRecords.Configuration_Skills__r;
            this.selectedSkillFieldList = this.configurationRecords.Configuration_Skill_Fields__r;
            let tempFieldsArr = this.selectedSkillFieldList.map(currentItem => {
                return currentItem.Field_Name__c;
            });
            this.arrFields = tempFieldsArr;
            console.log('this.arrFields',this.arrFields);
            let tempSkillArr = this.selectedSkillsList.map(currentItem => {
                return currentItem.Skill_Name__c;
            });
            this.arrSkills = tempSkillArr;
        }
        let arrQueues = this.selectedQueuesList.map(currentItem => {
            console.log(currentItem);
            return currentItem.Queue_Id__c;
        });
        this.selectedQueueList = arrQueues;
        this.showEditForm = true;
    }

    handleObject(event) {
        this.loaded = true;
        this.fieldPicklistValue = [];
        this.picklistType = false;
        this.stringType = true;
        this.selectedObjFieldValue = '';
        this.statusCloseValue = '';
        this.Object = event.target.value;
        console.log('if this Object', this.Object);
        this.getObjectFields();
        if(this.updateRecordFlag){
        this.showEditForm = false;
        this.arrFields = [];
        }
        this.isSkillBasedRouting = false;
    }

    getObjectFields() {
        getFields({ obj: this.Object }) // To get ServiceResource Related User
            .then(result => {
                this.fields = result;
                if (this.updateRecordFlag) {
                    this.handleFieldType(this.selectedObjField);
                }
                this.loaded = false;
            });
    }

    handleChange(event) {
        if (event.target.name == "status") {
            this.fieldSelect = event.target.value;
        } else {
            this.Object = event.target.value;
        }
    }

    handlesSaveRecord() {
        this.loaded = true;
        const inputData = this.template.querySelectorAll(".frmInput");
        if (this.updateRecordFlag) {
            if (this.checkboxValue == false) {
                this.conditionCheckboxValue = 'OR';
                this.arrFields = [];
                this.arrSkills = [];
            }
        }
        if (inputData[0].value && this.Object && this.selectedQueueList.length > 0) {

            if (this.checkboxValue === false || (this.checkboxValue === true && this.arrFields.length > 0 && this.arrSkills.length > 0)) {
                console.log("5");
                if (inputData[3].value) {
                    this.statusCloseValue = inputData[3].value;
                }
                let configuration = {
                    Id: this.recordId,
                    Name: inputData[0].value,
                    Status__c: inputData[4].value,
                    Object__c: inputData[1].value,
                    Status_Close_Field__c: inputData[2].value,
                    Status_Close_Value__c: this.statusCloseValue,
                    Skill_Based_Routing__c: this.checkboxValue,
                    Model__c: inputData[5].value,
                    Agent_Capacity__c: inputData[6].value,
                    Operator__c: this.conditionCheckboxValue,
                }
                console.log('configuration',configuration);
                console.log('this.selectedQueueList',this.selectedQueueList);
                console.log('this.arrSkills',this.arrSkills);
                console.log('this.arrFields',this.arrFields);

                saveConfigu({ Configuration: configuration, selectQueuesList: this.selectedQueueList, skills: this.arrSkills, fields: this.arrFields }).then(result => {
                    console.log('result1', result[1]);
                    if (result[0] === 'success') {
                        console.log("inserted");
                        this.showNotificaion('Success', 'Configuration successfully ' + this.successStatus, 'Configuration inserted');
                        window.location.href = window.location.origin + '/lightning/r/Configuration__c/' + result[1] + '/view';
                        this.loaded = false;
                        // this[NavigationMixin.Navigate]({
                        //     type: 'standard__recordPage',
                        //     attributes: {
                        //         recordId: result[1],
                        //         objectApiName: 'Configuration__c',
                        //         actionName: 'view'
                        //     },
                        // });                        
                        // window.location.reload();
                    }
                    else {
                        this.showNotificaion('Error', 'We are not select same object' + result[1], 'Error');
                        this.loaded = false;
                    }

                }).catch(error => {
                    this.showNotificaion('error', error, 'Configuration Failed');
                    console.log(error);
                    this.loaded = false;
                })
            }
            else {
                this.showNotificaion('Warning', 'For skill based routing minimum one field and skill required', 'Error');
                this.loaded = false;
            }
        }
        else {           
            this.showNotificaion('Error', 'Required Field Missing', 'Required Error');
            this.loaded = false;
        }
    }

    showNotificaion(variant, message, title) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(evt);

    }
    handleCheck(event) {
        this.loaded = true;
        console.log(event.target.checked);
        if (this.Object && this.Object !== undefined && event.target.checked) {
            this.conditionCheckboxValue = 'OR';
            this.fieldComponentOff = false;
            this.checkboxValue = event.target.checked;
            this.loaded = false;
        }
        else {
            this.fieldComponentOff = true;
            this.checkboxValue = false;
            this.loaded = false;
        }
    }

    handleField(event) {
        this.fieldPicklistValue = [];
        if (event.target.value) {
            this.selectedObjField = event.target.value;
            this.handleFieldType(this.selectedObjField);
        }
        this.loaded = false;
    }

    handleSelectedPicklist(event) {
        if (event.detail.value !== null) {
            let arr = event.detail.value.map(currentItem => {
                return currentItem.value
            });
            arr.forEach(element => {
                console.log(element);
            })
            this.statusCloseValue = arr.toString();
        }
        this.loaded = false;
    }

    handleSelectedPicklistSkill(event) {
        if (event.detail.value !== null) {
            console.log('event.detail.value',event.detail.value);
            let arr = event.detail.value.map(currentItem => {
                return currentItem.value
            });
            this.selectedQueueList = arr;
        } else {
            this.selectedQueueList = [];
        }
        this.loaded = false;
    }

    handleCheckbox(event) {
        this.operator = event.detail;
    }

    handleFieldType(event) {
        this.loaded = true;
        let arr = this.fields.filter(o => o.value == event);
        let fieldType = arr.length ? arr[0].types : null;
        if (fieldType === 'STRING') {
            this.stringType = true;
            this.picklistType = false;

        } else if (fieldType === 'PICKLIST') {
            this.stringType = false;
            this.picklistType = true;

            getPicklistValues({ selectedObject: this.Object, field: this.selectedObjField }) // To get ServiceResource Related User
                .then(result => {
                    result.forEach(element => {
                        this.fieldPicklistValue = [...this.fieldPicklistValue, { value: element, label: element }]
                    });
                    if (this.updateRecordFlag) {
                        if (this.selectedObjFieldValue) {
                            this.selectedObjFieldValue = this.selectedObjFieldValue.split(',');
                        }
                    }
                    this.loaded = false;
                });
        }
    }

    handlesCancel(event) {
        console.log('cancel', event.target.label);
        if (event.target.label == 'Cancel') {
            console.log('inside cancel');
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: this.recordId,
                    objectApiName: 'Configuration__c',
                    actionName: 'view'
                },
            });
        } else {
            console.log('event.target.label');
        }
    }

    handleRadio(event) {
        this.conditionCheckboxValue = event.target.value;
    }

    handleSkillFieldSelection(event) {
        this.arrFields = [];
        if (event.detail.value !== null) {
            let arr = event.detail.value.map(currentItem => {
                return currentItem.value
            });
            this.arrFields = arr;
        }
    }

    handleSelectedUserSkill(event) {
        this.arrSkills = [];
        if (event.detail.value !== null) {
            let arr = event.detail.value.map(currentItem => {
                return currentItem.label
            });
            this.arrSkills = arr;
        }
    }

    get conditionValue() {
        return [
            { label: ' ANY', value: 'OR' },
            { label: ' ALL', value: 'AND' },
        ];
    }

    get options() {
        return [
            { label: 'Active', value: 'Active' },
            { label: 'Close', value: 'Close' },
        ];
    }
}