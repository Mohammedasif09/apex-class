import { LightningElement, track, api, wire } from 'lwc';
import getConfSkillList from '@salesforce/apex/ServiceCloudConfiguration.getSkills';
export default class AddConfigurationSkill extends LightningElement {

    @api passObject;
    @api selectedskillslist;
    @api selectedSkillList = [];
    
    @api passSelectedSkillFields;
    @api passSelectedSkills;

    @track userSkillList = [];
    @track objectFields = [];
    @track allSkillFields = [];
    @track rows = [];
    @track skills = [];
    @track fields = [];
    @track selectSkillsList = [];
    @track selectSkillFieldList = [];

    index = 0;
    existValue = false;
    conditionCheckboxValue = 'OR';
    skillBasedRoutingConfiguration = {};
    loaded = true;

    @api handleSkillBasedRoutingData() {
        console.log('ROWS_ : ', JSON.parse(JSON.stringify(this.rows)));
        return { fieldsList: this.fields, condition: this.conditionCheckboxValue, skillsList:this.skills};
    }

    @wire(getConfSkillList, { objectAPIName: '$passObject' })
    getSkill({ error, data }) {
        if (data) {
            let tempArr = [];
            data.userSkills.forEach(element => {
                tempArr.push({ label: element.Skill_Name__c, value: element.Id, selected: false });
            })
            this.userSkillList = tempArr;
            this.allSkillFields = data.skillFields;
            this.objectFields = data.skillFields;
            if (this.objectFields) {
                this.showRows = true;
                this.index = 0;
                this.handleAddRow();
            }
            // setTimeout(()=>{
                console.log('Data ', JSON.parse(JSON.stringify(data)));
                // // if(this.passSelectedSkillFields){
                // //     this.selectSkillsList = this.passSelectedSkillFields;
                     // console.log('-----------',this.passSelectedSkillFields);
                // // }
                // // if(this.passSelectedSkills){
                // //     this.selectSkillFieldList = this.passSelectedSkills;
                     // console.log('++++++++++++',this.passSelectedSkills);
                // // }
                
                // },1000)

        } else {
            console.log(error);
        }
    }

    handleAddRow() {
        this.rows.push(this.getNewRow());
        this.showRows = true;
        console.log(this.rows.length);
        this.existValue = false;
        this.loaded = false;
    }

    handleRadio(event) {
        this.conditionCheckboxValue = event.target.value;
    }

    handleSkillFieldSelection(event) {
        if(event.detail.componentId !== null){
           this.fields = event.detail.value;
           console.log(event.detail.value);

       }

   }

    handleSelectedUserSkill(event) {
        if(event.detail.componentId !== null){ 
            this.skills = event.detail.value;
            console.log(event.detail.value);

        }
    }
    
    getUniqueId() {
        return Date.now().toString(36) + Math.random().toString(36).substr(2);
    }

    getNewRow() {
        //this.rowFlag = false;
        return {
            Id: this.getUniqueId(),
            skillFieldOption: this.allSkillFields,
            userSkillOption: this.userSkillList,
            field: null,
            skills: null
        }
    }

    get conditionValue() {
        return [
            { label: 'OR', value: 'OR' },
            { label: 'AND', value: 'AND' },
        ];
    }



}