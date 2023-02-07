import { LightningElement , wire,track } from 'lwc';
import getRecords from '@salesforce/apex/CrossOrgController.getRecords';
import NAME_FIELD from '@salesforce/schema/Lead.Name';
import COMPANY_FIELD from '@salesforce/schema/Lead.Company';
import EMAIL_FIELD from '@salesforce/schema/Lead.Email';
import LEADSOURCE_FIELD from '@salesforce/schema/Lead.LeadSource';

export default class LatestRecords extends LightningElement {
    @track leads=[];
    fecthError;
    fields= [
        { label: 'Name', fieldName: NAME_FIELD.fieldApiName, type: 'text',editable: false },
        { label: 'Company', fieldName: COMPANY_FIELD.fieldApiName, type: 'text',editable: false },
        { label: 'Email', fieldName: EMAIL_FIELD.fieldApiName, type: 'text',editable: false },
        { label: 'LeadSource', fieldName: LEADSOURCE_FIELD.fieldApiName, type: 'text',editable: false },
    ];
    @wire(getRecords)
    getLatestRecords({ error, data }) {
        if (data) {
            this.leads = data;     
            console.log(JSON.stringify(data));       
            this.fecthError = undefined;
        } else if (error) {
            this.fecthError = error;
             this.leads = undefined;
        }
    }
}