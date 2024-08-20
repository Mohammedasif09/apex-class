import { LightningElement } from 'lwc';

export default class ServiceUserSkills extends LightningElement {
    
    loaded = false;


    handleServiceUsers(event){
        console.log(event.detail.value);
    }
    handleSkills(event){
        console.log(event.detail.value);
    }
    handlesSaveServiceUserSkills(){
        console.log('event.detail.value');
    }
}