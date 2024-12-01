import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import createService from '@salesforce/apex/ServiceController.createService';

export default class ServiceModalButton extends LightningElement {
    @api recordId;
    @track isModalOpen = false;
    @track serviceType = '';
    
    serviceOptions = [
        { label: 'Immediate Assistance', value: 'Immediate Assistance' },
        { label: 'Extended Assistance', value: 'Extended Assistance' },
        { label: 'Recovery Assistance', value: 'Recovery Assistance' }
    ];

    handleOpenModal() {
        this.isModalOpen = true;
    }

    handleCloseModal() {
        this.isModalOpen = false;
    }

    handleServiceChange(event) {
        this.serviceType = event.detail.value;
    }

    handleSave() {
        createService({ caseId: this.recordId, serviceType: this.serviceType })
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Service record created successfully',
                        variant: 'success',
                    })
                );
                this.isModalOpen = false;
                // Optionally refresh the view
                eval("$A.get('e.force:refreshView').fire();");
            })
            .catch(error => {
                let errorMessage = 'Unknown error';
                if (error && error.body && error.body.message) {
                    errorMessage = error.body.message;
                } else if (error && error.message) {
                    errorMessage = error.message;
                }
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error creating record',
                        message: errorMessage,
                        variant: 'error',
                    })
                );
            });
    }
}