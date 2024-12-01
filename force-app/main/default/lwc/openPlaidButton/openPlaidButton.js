import { LightningElement, api, wire } from 'lwc';
import getPlaidLinks from '@salesforce/apex/PlaidMCAService.getPlaidLinks';

export default class PlaidMcaLinks extends LightningElement {
    @api recordId;

    openLinks() {
        getPlaidLinks({ opportunityId: this.recordId })
            .then(links => {
                links.forEach(link => {
                    window.open(link, '_blank');
                });
            })
            .catch(error => {
                console.error('Error fetching links:', error);
            });
    }
}