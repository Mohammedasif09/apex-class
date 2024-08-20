import { LightningElement ,wire,api} from 'lwc';
import { getRecord, getFieldValue } from "lightning/uiRecordApi";
import NAME_FIELD from "@salesforce/schema/Account.Name";

const fields = [NAME_FIELD];
export default class AccountCreate extends LightningElement {

    recordId;

    //3. Wire the output of the out of the box method getRecord to the property account
    @wire(getRecord, {
      recordId: "$recordId",
      fields
    })
    account;
  
    renderedCallback() {
      console.log(this.account.data);
    }
    
    //4. Fetch the field values from the record
    get name() {
      return getFieldValue(this.account.data, NAME_FIELD);
    }
  
    
}