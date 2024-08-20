import { LightningElement ,wire,track} from 'lwc';
import getList from '@salesforce/apex/skillResourceController.getList';
export default class SkillResource extends LightningElement {
dataList;
@wire(getList) ServiceUser ({ error, data }) {
    if (data) {
        this.dataList = data;
        console.log(data); 
    } else if (error) { 
        this.error = error;  
    }   
}
@track status = [
    {label : 'Offline', value : 'offline'},
    {label : 'Online', value : 'online'},
   
]

selectedStatus = "offline";

handleStatus(event){
    this.selectedStatus =  event.target.value;
}

}