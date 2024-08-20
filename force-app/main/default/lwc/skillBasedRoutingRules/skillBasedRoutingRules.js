import { LightningElement, wire, track } from 'lwc';
import getObjects from '@salesforce/apex/SkillBasedRoutingRules.getObjects';
import getFields from '@salesforce/apex/SkillBasedRoutingRules.getFields'
import getPicklistValue from '@salesforce/apex/SkillBasedRoutingRules.getPicklistValue'
import skills from '@salesforce/apex/SkillBasedRoutingRules.skills'
export default class SkillBasedRoutingRules extends LightningElement {
    isshowSpinner = true;
    @track objectLists = [];
    @track index = 1;
    @track fields = [];
    @track isStatus = false;
    Object;
    objectFields = [];
    showFilter = false;
    rows = [];
    showRows = true;
    @wire(getObjects) getObj({ error, data }) {
        if (data) {
            for (var key in data)
                this.objectLists = [...this.objectLists, { value: key, label: data[key] }]
        }
        else {
            console.log(error);
        }
        this.isshowSpinner = false;
    }
    handleObject(event) {
        console.log('handleObject')
        this.rows = [];
        this.isshowSpinner = true;
        this.isStatus = false;
        this.fields.splice(0, this.fields.length);
        this.fieldValues.splice(0, this.fieldValues.length);
        this.Object = event.target.value
        getFields({ Obj: this.Object }) // To get ServiceResource Related User
            .then(result => {

                this.objectFields = result;
                console.log('this.objectFields', this.objectFields);
                result.forEach(element => {
                    this.fields = [...this.fields, { value: element.value + '-' + element.type, label: element.label }]
                });
            });
        setTimeout(() => {
            this.isshowSpinner = false;
        }, 1000)
        if (this.objectFields) {
            this.showFilter = true;
            this.emptyRows();
        }

        // setTimeout(() => {
        //     this.template.querySelector('c-filter-criteria').getFields(this.objectFields);
        // }, 2000)

    }
    @track isPicList = false;
    @track isInputfield = false;
    @track fieldValues = [];
    @track skillList = [];

    @wire(skills) skill({ error, data }) { // Method to get all the skills.
        if (data) {
            for (let index = 0; index < data.length; index++) {
                this.skillList = [...this.skillList, { value: data[index].Id, label: data[index].Skill_Name__c }]
            }
        }
        else {
            console.log(error);
        }
    }

    emptyRows() {
        let tempObj = {};
        tempObj.Id = 1;
        tempObj.displayIndex=1;
        tempObj.selectedField = '';
        tempObj.selectedOperator = '';
        tempObj.selectedValue = '';
        tempObj.selectedDataType = '';
        this.rows.push(tempObj);
    }
    addRow() {
        console.log('execute-->');
        this.showRows = false;
        ++this.index;
        //var i = JSON.parse(JSON.stringify(this.index));
        let i = this.index;
        let tempObj = {};
        tempObj.Id = i;
        tempObj.displayIndex=i;
        tempObj.selectedField = '';
        tempObj.selectedOperator = '';
        tempObj.selectedValue = '';
        tempObj.selectedDataType = '';
        this.rows.push(tempObj);
        // this.acc.key = i;
        // this.rows.push(JSON.parse(JSON.stringify(this.acc)));
        console.log('Enter ', this.rows);
        this.showRows = true;
        // setTimeout(() => {
        //     this.template.querySelector('c-filter-criteria').getFields(this.objectFields);
        // }, 2000)
    }

    handleField(event) {
        console.log('execute');
        this.isStatus = true;
        if (event.target.value.split("-", 2)[1] === 'PICKLIST') {
            getPicklistValue({ obj: this.Object, picVal: event.target.value.split("-", 2)[0] })
                .then(results => {
                    this.isPicList = true;
                    results.forEach(element => {
                        this.fieldValues = [...this.fieldValues, { value: element, label: element }]
                    });
                });
        } else {
            this.isInputfield = true;
        }
    }

    handleFieldValues(event) {
        console.log('VAlues-- ' + event.target.value);

    }

    handleSkill(event) {
        console.log('skills-- ' + event.target.value);
    }
    handleRemoveRow(event) {
        console.log('rowslength', this.rows.length);


        let rowId = event.detail.recordId;
        this.showRows = false;
        let count = 1;
        console.log('recordId-->', rowId);
        let temRows = this.rows.filter(row => {
            if (row.displayIndex != rowId) {
                row.displayIndex = count;
                ++count;
                return row;

            }
        });
        this.showRows = true;

        this.rows = temRows;
        this.index = this.index-1;
        console.log(temRows)
        if (!this.rows.length) {
            this.emptyRows();

        }

    }
}