import { LightningElement, api } from 'lwc';

export default class ContactRecord extends LightningElement {
    @api contactId;
    @api firstName;
    @api lastName;
    @api phone;
    @api email;
    @api display;
    @api rowId;

    deleteContact(event){
        let contactId = event.currentTarget.dataset.id;
        let index = event.currentTarget.dataset.display;
        console.log('contactId' , contactId);
        if(contactId){
            this.dispatchEvent(new CustomEvent('delete' , {detail : contactId}));
        }else{
            this.dispatchEvent(new CustomEvent('remove' , {detail : {display : this.rowId}}));
        }
        
    }

    handleChange(event){
        console.log(event.target)
        switch(event.target.name){
            case 'firstName' : this.firstName = event.target.value;
            break;
            case 'lastName' : this.lastName = event.target.value;
            break;
            case 'email' : this.email = event.target.value;
            break;
            case 'phone' : this.phone = event.target.value
        }
        this.sendToParent();
    }

    sendToParent(){
        let tempObj = {};
        tempObj.Id = '';
        tempObj.rowId = this.rowId;
        tempObj.firstName = this.firstName;
        tempObj.lastName = this.lastName;
        tempObj.email = this.email;
        tempObj.phone = this.phone;
        console.log(tempObj)
        this.dispatchEvent(new CustomEvent('data' , { detail : tempObj}));
    }
}