import { LightningElement, track, wire, api } from 'lwc';
import getServiceUser from '@salesforce/apex/ServiceUserSkillsController.getServiceUser';
import getServiceUserSkills from '@salesforce/apex/ServiceUserSkillsController.getServiceUserSkills';
import saveServiceUserSkills from '@salesforce/apex/ServiceUserSkillsController.saveServiceUserSkills';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
export default class ServiceUserSkills extends LightningElement {

    loaded = true;
    @track serviceUser = '';
    serviceUserSkill = '';
    saveAndNewFlag = false;
    clearButtonVisable = false;
    @api userRecordId;
    @track serviceUserNewSkill = [];
    @track serviceUserSkillList = [];
    @track filterServiceUserSkillList = [];
    
    @wire(getServiceUser) getUser({ error, data }) {
        this.loaded = true;
        if (data) {
            let tempArr = [];
            if (this.userRecordId) {
                data.forEach(element => {
                    if (element.Id == this.userRecordId) {
                        tempArr.push({ label: element.Name, value: element.Id });
                    }
                })
                this.serviceUser = this.userRecordId;
                this.handleServiceUserSkill();
                let serviceArr = {
                    uniqueId: this.getUniqueId(),
                    Skill__c: '',
                    Service_User__c: this.userRecordId,
                    Skill_Level__c: '',
                    Start_Date__c: '',
                    End_Date__c: ''
                }
                this.serviceUserNewSkill.push(serviceArr);
                setTimeout(() => {
                    this.addRowDisable = this.serviceUserSkillListLength <= this.serviceUserNewSkill.length;
                }, 1000);                
                this.loaded = false;
            }
            else {
                data.forEach(element => {
                    tempArr.push({ label: element.Name, value: element.Id });
                })
                this.loaded = false;
            }
            this.serviceUserList = tempArr;

        }
        else {
            console.log(error);
            this.loaded = false;
        }
    }

    handleServiceUsers(event) {
        this.loaded = true;
        if (event.detail.value) {
            console.log('inside event',event.detail.value.value);
            this.serviceUser = event.detail.value.value;
        }
        console.log(this.serviceUser);
        if (this.serviceUser) {
            this.handleServiceUserSkill();
        }
        else {
            this.loaded = false;
        }
    }

    handleSkills(event) {
        if(this.userRecordId){
        let index = event.currentTarget.dataset.id;
        console.log(event.currentTarget.dataset.id);
        if (event.detail.value) {
            this.serviceUserNewSkill[index].Skill__c = event.detail.value.value;
        }
        this.filterSkillListHandle();
    }
        else {
            if(event.detail.value){
            this.serviceUserSkill = event.detail.value.value;
        }
        }
    }

    handleStartDate(event) {
        let index = event.currentTarget.dataset.id;
        console.log(event.currentTarget.dataset.id);
        if (event.target.value) {
            this.serviceUserNewSkill[index].Start_Date__c = event.target.value;
        }
    }

    handleEndtDate(event) {

        let index = event.currentTarget.dataset.id;
        console.log(event.currentTarget.dataset.id);
        if (event.target.value) {
            this.serviceUserNewSkill[index].End_Date__c = event.target.value;
        }
    }

    handleSkillLevel(event) {
        if (this.userRecordId) {
            let index = event.currentTarget.dataset.id;
            console.log(event.currentTarget.dataset.id);
            if (event.target.value) {
                this.serviceUserNewSkill[index].Skill_Level__c = event.target.value;
            }
            console.log('!@!', this.serviceUserNewSkill);
        }
    }

    handlesSaveServiceUserSkills() {
        this.fieldEmptyFlag = false;
        const inputData = this.template.querySelectorAll(".frmInput");
        console.log('inputData',inputData);
        if (this.userRecordId) {
            if (this.serviceUserNewSkill) {
                this.serviceUserNewSkill.forEach(element => {
                    if (element.uniqueId) {
                        delete element.uniqueId;
                    }
                });
            }
        }
        else {
            this.serviceUserNewSkill =[];
            this.loaded = true;
            let serviceUserSkills = {
                Skill__c: this.serviceUserSkill,
                Service_User__c: this.serviceUser,
                Skill_Level__c: inputData[2].value,
                Start_Date__c: inputData[0].value,
                End_Date__c: inputData[1].value,
            }
            console.log(serviceUserSkills);
            this.serviceUserNewSkill.push(serviceUserSkills);
            console.log(this.serviceUserNewSkill);
            console.log();
            this.loaded = false;
        }
        this.serviceUserNewSkill.forEach(element => {
            if(!element.Skill__c || !element.Service_User__c || !element.Start_Date__c){
                this.fieldEmptyFlag = true;
            }            
        });
        // if (this.serviceUserSkill && inputData[0].value && this.serviceUser) {
            if (!this.fieldEmptyFlag) {
            saveServiceUserSkills({ serviceUserSkill: this.serviceUserNewSkill }).then(result => {
                if (result[1] == 'Success') {
                    this.showNotificaion('Success', 'Service User Skill Inserted', 'Record Inserted Successfully');
                    if (this.userRecordId) {
                        window.location.href = window.location.origin + '/lightning/r/Service_User__c/' + this.userRecordId + '/view';
                    }
                    else if (this.saveAndNewFlag) {
                        window.location.href = window.location.origin + '/lightning/o/Service_User_Skill__c/new';
                    }
                    else {
                        window.location.href = window.location.origin + '/lightning/o/Service_User_Skill__c/';
                    }
                }
                else {
                    this.showNotificaion('error', 'Service User Skill Insertion Faield', 'error' + error);
                    this.saveAndNewFlag = false;
                }
                this.loaded = false;
            }).catch(error => {
                this.showNotificaion('error', 'error' + error[0], 'We can not select same skill');
                console.log(error);
                this.saveAndNewFlag = false;
                this.loaded = false;
            })
        }
        else {
            this.showNotificaion('error', 'Make Sure Service User, Skills and Start Date filled', 'Required Field Missing');
            this.saveAndNewFlag = false;
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

    handlesCancelServiceUserSkills() {

        if (this.userRecordId) {
            window.location.href = window.location.origin + '/lightning/r/Service_User__c/' + this.userRecordId + '/view';
        } else {
            window.location.href = window.location.origin + '/lightning/o/Service_User_Skill__c/list';
        }
    }

    handleAddNewRow() {
        let tempList = {
            uniqueId: this.getUniqueId(),
            Skill__c: '',
            Service_User__c: this.userRecordId,
            Skill_Level__c: '',
            Start_Date__c: '',
            End_Date__c: ''
        };
        this.serviceUserNewSkill.push(tempList);
        this.clearButtonVisable = this.serviceUserNewSkill.length > 1;
        this.addRowDisable = this.serviceUserSkillListLength <= this.serviceUserNewSkill.length;
        this.filterSkillListHandle();
    }

    handleRemoveRow(event) {
        let idx = event.currentTarget.dataset.id;
        console.log(this.serviceUserNewSkill[idx]);
        this.serviceUserNewSkill.splice(idx, 1);
        this.clearButtonVisable = this.serviceUserNewSkill.length > 1;
        this.addRowDisable = this.serviceUserSkillListLength <= this.serviceUserNewSkill.length;
        this.filterSkillListHandle();
    }

    handleServiceUserSkill() {
        if (this.userRecordId) {
            this.serviceUser = this.userRecordId;
        }
        getServiceUserSkills({ serviceUser: this.serviceUser })
            .then(result => {
                let tempArr = [];
                result.forEach(element => {
                    tempArr.push({ label: element.Skill_Name__c, value: element.Id });
                })
                this.serviceUserSkillListLength = tempArr.length;
                this.serviceUserSkillList = tempArr;
                this.filterServiceUserSkillList = tempArr;
                this.addRowDisable = this.serviceUserSkillListLength == 1;
                this.loaded = false;
            });
    }

    getUniqueId() {
        return Date.now().toString(36) + Math.random().toString(36);
    }

    filterSkillListHandle() {
        const skillId = [];
        this.serviceUserNewSkill.forEach(element => {
            if (element.Skill__c) {
                skillId.push(element.Skill__c);
                console.log('QWERT', skillId);
            }
        });
        this.filterServiceUserSkillList = this.serviceUserSkillList.filter(({ value }) => !skillId.includes(value));
    }

    handleSaveAndNew() {
        this.saveAndNewFlag = true;
        this.handlesSaveServiceUserSkills();
    }
}