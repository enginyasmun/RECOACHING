import { LightningElement, track } from 'lwc';

export default class LwcFlexibleFields extends LightningElement {
    @track groups = [
        {
            index: 1,
            name: 'Prescrubbing Fields',
            fields: [
                { index: 1, id: 'prescrubbing_1', name: 'Field 1', value: '' },
                { index: 2, id: 'prescrubbing_2', name: 'Field 2', value: '' },
                { index: 3, id: 'prescrubbing_3', name: 'Field 3', value: '' },
                { index: 4, id: 'prescrubbing_4', name: 'Field 4', value: '' },
                { index: 5, id: 'prescrubbing_5', name: 'Field 5', value: '' },
                { index: 6, id: 'prescrubbing_6', name: 'Field 6', value: '' },
                { index: 7, id: 'prescrubbing_7', name: 'Field 7', value: '' },
                { index: 8, id: 'prescrubbing_8', name: 'Field 8', value: '' },
                { index: 9, id: 'prescrubbing_9', name: 'Field 9', value: '' },
                { index: 10, id: 'prescrubbing_10', name: 'Field 10', value: '' }
            ]
        },
        {
            index: 2,
            name: 'Underwriting Fields',
            fields: [
                { index: 1, id: 'underwriting_1', name: 'Field 1', value: '' },
                { index: 2, id: 'underwriting_2', name: 'Field 2', value: '' },
                { index: 3, id: 'underwriting_3', name: 'Field 3', value: '' },
                { index: 4, id: 'underwriting_4', name: 'Field 4', value: '' },
                { index: 5, id: 'underwriting_5', name: 'Field 5', value: '' },
                { index: 6, id: 'underwriting_6', name: 'Field 6', value: '' },
                { index: 7, id: 'underwriting_7', name: 'Field 7', value: '' },
                { index: 8, id: 'underwriting_8', name: 'Field 8', value: '' },
                { index: 9, id: 'underwriting_9', name: 'Field 9', value: '' },
                { index: 10, id: 'underwriting_10', name: 'Field 10', value: '' }
            ]
        },
        {
            index: 3,
            name: 'Underwriting Fields',
            fields: [
                { index: 1, id: 'underwriting_1', name: 'Field 1', value: '' },
                { index: 2, id: 'underwriting_2', name: 'Field 2', value: '' },
                { index: 3, id: 'underwriting_3', name: 'Field 3', value: '' },
                { index: 4, id: 'underwriting_4', name: 'Field 4', value: '' },
                { index: 5, id: 'underwriting_5', name: 'Field 5', value: '' },
                { index: 6, id: 'underwriting_6', name: 'Field 6', value: '' },
                { index: 7, id: 'underwriting_7', name: 'Field 7', value: '' },
                { index: 8, id: 'underwriting_8', name: 'Field 8', value: '' },
                { index: 9, id: 'underwriting_9', name: 'Field 9', value: '' },
                { index: 10, id: 'underwriting_10', name: 'Field 10', value: '' }
            ]
        },
        {
            index: 4,
            name: 'Accounting Fields',
            fields: [
                { index: 1, id: 'accounting_1', name: 'Field 1', value: '' },
                { index: 2, id: 'accounting_2', name: 'Field 2', value: '' },
                { index: 3, id: 'accounting_3', name: 'Field 3', value: '' },
                { index: 4, id: 'accounting_4', name: 'Field 4', value: '' },
                { index: 5, id: 'accounting_5', name: 'Field 5', value: '' },
                { index: 6, id: 'accounting_6', name: 'Field 6', value: '' },
                { index: 7, id: 'accounting_7', name: 'Field 7', value: '' },
                { index: 8, id: 'accounting_8', name: 'Field 8', value: '' },
                { index: 9, id: 'accounting_9', name: 'Field 9', value: '' },
                { index: 10, id: 'accounting_10', name: 'Field 10', value: '' }
            ]
        }
    ];

    handleInput(event) {
        const fieldId = event.target.dataset.id; // Use dataset for unique field identification
        const value = event.target.value;

        // Adjust the height of the textarea dynamically
        event.target.style.height = 'auto'; // Reset height to auto
        event.target.style.height = `${event.target.scrollHeight}px`; // Adjust height based on content

        // Update the value dynamically in the data structure
        this.groups = this.groups.map((group) => ({
            ...group,
            fields: group.fields.map((field) =>
                field.id === fieldId ? { ...field, value } : field
            )
        }));
    }
}
