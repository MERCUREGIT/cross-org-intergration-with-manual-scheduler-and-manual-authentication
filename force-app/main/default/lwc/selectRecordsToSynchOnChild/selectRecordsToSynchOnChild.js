/**
 * @autho ngum buka fon nyuydze
 * @since 10/02/2023
 */

import { LightningElement,track,wire } from 'lwc';
import getRecords from '@salesforce/apex/CrossOrgController.getRecords';
import manuallySyncRecords from '@salesforce/apex/CrossOrgController.manuallySyncRecords';
import NAME_FIELD from '@salesforce/schema/Lead.Name';
import COMPANY_FIELD from '@salesforce/schema/Lead.Company';
import EMAIL_FIELD from '@salesforce/schema/Lead.Email';
import LEADSOURCE_FIELD from '@salesforce/schema/Lead.LeadSource';
import LEADNAME_FIELD from '@salesforce/schema/Lead.LastName';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class SelectRecordsToSynchOnChild extends LightningElement  {
    @track leads=[];
    fecthError;

    @track selectedLeads = [];

    fields= [
        { label: 'Name', fieldName: NAME_FIELD.fieldApiName, type: 'text',editable: false },
        { label: 'Company', fieldName: COMPANY_FIELD.fieldApiName, type: 'text',editable: false },
        { label: 'Email', fieldName: EMAIL_FIELD.fieldApiName, type: 'text',editable: false },
        { label: 'LeadSource', fieldName: LEADSOURCE_FIELD.fieldApiName, type: 'text',editable: false },
        { label: 'LastName', fieldName: LEADNAME_FIELD.fieldApiName, type: 'text',editable: false },
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
    get isSelectedLEads(){
        return this.selectedLeads.length>0;
    }

    syncRecords(){
        manuallySyncRecords({jsonStrings:JSON.stringify(this.selectedLeads)})
        .then(res=>{
            console.log('Response ===>',JSON.stringify(res));
            this.showNotification('Records Synched','Records where sycnhed on child org with sucess','success');
        })
        .catch(error=>{
            console.log('Error ===>',JSON.stringify(error.message));
            this.showNotification('Failed to Synch Records','Records where unable to be sycnhed on child org','Error');
        })
    }

    getSelectedLeads(event){
        this.selectedLeads = [...event.detail.selectedRows];
        this.getSelectedRec();
    }

    showNotification(title,message,variant) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(evt);
    }

    getSelectedRec() {
        var selectedRecords =  this.template.querySelector("lightning-datatable").getSelectedRows();
        if(selectedRecords.length > 0){
            console.log('selectedRecords are ', selectedRecords);
   
            let ids = '';
            selectedRecords.forEach(currentItem => {
                ids = ids + ',' + currentItem.Id;
            });
            this.selectedIds = ids.replace(/^,/, '');
            this.lstSelectedRecords = selectedRecords;
            alert(this.selectedIds);
        }   
      }
}