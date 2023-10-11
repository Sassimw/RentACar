public class SendPDFController {
    public String recipientEmail { get; set; }
	public String MstrId{GET;SET;}
    public PageReference sendPDFByEmail() {
        // Generate and attach the PDF file
        PageReference pdfPage = Page.ServiceClientPDFVP; // Replace with your actual PDF page name
        pdfPage.getParameters().put('id', MstrId); // Replace with the record ID for which you want to generate the PDF
        Blob pdfBlob;
        
        try {
            pdfBlob = pdfPage.getContentAsPDF();
        } catch(Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error generating PDF'));
            return null;
        }
        
        Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
        attachment.setFileName('YourPDFAttachment.pdf');
        attachment.setBody(pdfBlob);
        
        // Create and send the email
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setSubject('PDF Attachment Email');
        email.setPlainTextBody('Please find the PDF attachment.');
        email.setToAddresses(new String[] {recipientEmail});
        email.setFileAttachments(new Messaging.EmailFileAttachment[] {attachment});
        
        try {
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Email sent with PDF attachment.'));
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error sending email'));
        }
        
        return null;
    }
    
       public SendPDFController(ApexPages.StandardController Controller){
        
        MstrId = ApexPages.currentPage().getParameters().get('id');
 
    }
    
    public PageReference Cancel()
    {
        PageReference Pdf = NEW PageReference('/'+MstrID);
        pdf.setredirect(TRUE);
        RETURN Pdf;
    }
}