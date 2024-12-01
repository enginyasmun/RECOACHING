// QuotePDFService class handles the generation and attachment of PDF files for Quote records
public with sharing class QuotePDFService {

    /**
     * Purpose: Generate a PDF for the given Quote and attach it to the Quote record.
     * 
     * Parameters: VARIABLE|TYPE|LIMITATION|DEFINITION
     * quoteId|Id|non-null|Id of the Quote record for which the PDF needs to be generated
     * 
     * Outputs: None. PDF is attached as an Attachment to the Quote record.
     * 
     * Example:
     * Id quoteId = 'a0B1a00000Xyz123';
     * QuotePDFService.generatePDF(quoteId);
     */
    @future(callout=true)
    public static void generatePDF(Id quoteId) {

        // Query the Quote along with its related Account information
        Quote q = [SELECT Id, Name, AccountId, Account.Name FROM Quote WHERE Id = :quoteId];

        // Generate the PDF by referring to the Visualforce page designed for this purpose
        PageReference pdfPage = Page.PdfMaker; // PdfMaker is the Visualforce page
        pdfPage.getParameters().put('id', quoteId); // Set the Quote Id as a parameter to be used in the page

        // Create a new Attachment record to hold the generated PDF
        Attachment attach = new Attachment();
        attach.ParentId = q.Id; // Associate the attachment with the Quote
        attach.Name = q.Name + '.pdf'; // Set the attachment name as Quote name followed by .pdf
        attach.Body = pdfPage.getContentAsPDF(); // Generate the PDF content and store it in the attachment body
        attach.ContentType = 'application/pdf'; // Set the content type to PDF

        // Insert the attachment to Salesforce so that it is saved and linked to the Quote
        insert attach;
    }
}