import { LightningElement, api, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import sendPayment from '@salesforce/apex/PaymentController.sendPayment';
import hasApprovedDistributions from '@salesforce/apex/PaymentController.hasApprovedDistributions';

export default class SendPaymentButton extends LightningElement {
    @api recordId;
    hasApprovedDistributions = false;

    @wire(hasApprovedDistributions, { caseId: '$recordId' })
    wiredHasApprovedDistributions({ error, data }) {
        if (data !== undefined) {
            this.hasApprovedDistributions = data;
        } else if (error) {
            this.showToast('Error', error.body.message, 'error');
        }
    }

    handleSendPayment() {
        sendPayment({ caseId: this.recordId })
            .then(result => {
                if (result === 'Success') {
                    this.showToast('Success', 'Payment sent successfully', 'success');
             
                } else {
                    this.showToast('Error', result, 'error');
                }
            })
            .catch(error => {
                this.showToast('Error', error.body.message, 'error');
            });
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title,
            message,
            variant,
        });
        this.dispatchEvent(event);
    }
}