// Trigger to automatically generate and attach a PDF for each new Quote record
trigger QuoteTrigger on Quote (after insert) {
    // Loop through each Quote in the trigger
    for (Quote quote : Trigger.new) {
        // Call the service class to generate and attach the PDF asynchronously using @future method
        QuotePDFService.generatePDF(quote.Id);
    }
}

