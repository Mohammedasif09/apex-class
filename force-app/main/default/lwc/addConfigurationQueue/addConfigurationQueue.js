import { LightningElement, wire} from 'lwc';
import getqueuss from '@salesforce/apex/ServiceCloudConfiguration.getQueuss';
import getConfiguration from '@salesforce/apex/ServiceCloudConfiguration.getconfiguration';   
import getConfigurationQueuesave from '@salesforce/apex/ServiceCloudConfiguration.saveConfigurationQueue';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class AddConfigurationQueue extends LightningElement {
   
     QueusList = [];
     queusId = '';
     queusName = '';
     configurationList = [];
     configurationName = '';

    @wire(getqueuss) getque({ error, data }) {
        if (data) {
            let tempArr = [];
            console.log('Data ' , data);
            data.forEach(element => {
               tempArr.push({label : element.Name, value : element.Id});
               //this.QueusList.push({label : element.Name, value : element.Id});
            })
            //console.log('QueusList :::' , this.QueusList);
            this.QueusList = tempArr;
        }
        else {
            console.log(error);
        }
      
    }

    @wire(getConfiguration)  getConfiguration({ error , data }) {
        if(data) {
            let tempArrData = [] ;
            console.log('data ::' , data)
            data.forEach(element => {
                tempArrData.push({label : element.Name, value : element.Id});
                //this.QueusList.push({label : element.Name, value : element.Id});
             })

           this.configurationList =   tempArrData; 
           this.configurationList =   tempArrData; 
           console.log('configurationList ::' , this.configurationList);

        }

    } 
    
    handleQueus(event){
        this.queusId   =  event.detail.value;
        this.queusName =  event.target.options.find(opt => opt.value === event.detail.value).label;
        console.log('queusName ' , this.queusName);
        console.log( 'queusId' , this.queusId);
         
    }

    handleconfiguration(event){
        this.configurationName =  event.target.value
        console.log('configurationName' , this.configurationName);
    }

    handlesSaveRecord(){
        getConfigurationQueuesave({ configurationId: this.configurationName , queueName: this.queusName , queueTd: this.queusId }) // To get ServiceResource Related User
            .then(result => {
                console.log("@@@")
                console.log('####### :::' ,result);
                // result.forEach(element => {
                //     this.fields = [...this.fields, { value: element.value + '-' + element.type, label: element.label }]
                // });
                this.showNotificaion('success', 'Configuration successfully inserted', 'Configuration inserted');
            }).catch(error => {
                this.showNotificaion('error', ' Failed insertion of Configuration', 'Configuration Failed');
                console.log(error)

            });

    }

}