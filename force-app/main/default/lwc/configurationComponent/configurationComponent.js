import { LightningElement,wire,track} from 'lwc';
import getConfiguration from '@salesforce/apex/configurationController.getConfiguration'
export default class ConfigurationComponent extends LightningElement {
    @track fetche;
 @wire (getConfiguration) user({error,data}){
     
        if (data) {
            this.fetche = data;
            console.log(JSON.stringify(data));
        } else if (error) {
            console.log(error);
        }
    }
    

    

}