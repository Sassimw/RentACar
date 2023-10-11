public class saveVfPdfCtrl {
 
    public String MstrId{GET;SET;}
    public Account accObj{GET;SET;}
 
    public String PDFNo{GET;SET;}
    public String EFNo{GET;SET;}
    public BOOLEAN SHOW{GET;SET;}
    public BOOLEAN showpdf{GET;SET;}
    public ApexPages.PageReference page2{GET;SET;}
    public String baseURL{GET;SET;}
 
    public PageReference Cancel()
    {
        PageReference Pdf = NEW PageReference('/'+MstrID);
        pdf.setredirect(TRUE);
        RETURN Pdf;
    }
 
    public saveVfPdfCtrl(ApexPages.StandardController Controller){
        baseURL = URL.getSalesforceBaseUrl().toExternalForm();
        MstrId = ApexPages.currentPage().getParameters().get('id');
        accObj = [SELECT Id, Name, Phone, Industry, Rating, Description, Website, TYPE, (SELECT Id, Name, FirstName, LastName, Email, AccountId, Phone, Title FROM Contacts) 
                  FROM Account WHERE Id =: MstrId ];
 
    }
 
 
 
    public PageReference pdfAction()
    {
        PageReference savepage ;
        savepage = Page.savePdfVp;
        savepage.getParameters().put('id',MstrID);
        system.debug('id:- '+MstrID);
        BLOB pdfBlob;
        IF (!Test.isRunningTest()) {
            pdfBlob = savepage.getContent(); //generate the pdf BLOB
        } ELSE { 
            pdfBlob = BLOB.valueOf('Test');
        }
        List<ContentDocumentLink> notesattch = [SELECT id, ContentDocument.Title,LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId =: MstrID ORDER BY ContentDocument.Title ASC];    
        system.debug('notesattch## ' + notesattch);
        IF(notesattch.size() > 0)
        {
            string title =  notesattch[0].ContentDocument.Title;
            system.debug('title111 ' + title);
            List<String> titleSplit = title.split('R');
            //String FinalTitle = titleSplit[0]+'R0'+notesattch.size();
            String FinalTitle = 'PO'+notesattch.size();
            system.debug('FinalTitle22 ' + FinalTitle);
            PDFNo=FinalTitle;
 
            ContentVersion conVer = NEW ContentVersion();
            conVer.ContentLocation = 'S'; // TO USE S specify this document IS IN Salesforce, TO USE E FOR external files
            conVer.PathOnClient = FinalTitle+'.pdf'; 
            conVer.Title = FinalTitle; 
            conVer.VersionData = pdfBlob;
            system.debug('conVer@@ ' + conVer);
            INSERT conVer;  
 
            Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
 
            ContentDocumentLink conDocLink = NEW ContentDocumentLink();
            conDocLink.LinkedEntityId = MstrID;
            conDocLink.ContentDocumentId = conDoc; 
            conDocLink.shareType = 'V';
            INSERT conDocLink;
            UPDATE accObj;
 
             PageReference pageRef = NEW PageReference( baseURL+'/lightning/r/Account/' + System.currentPageReference().getParameters().get('id')+'/view');
            pageRef.setRedirect(TRUE);
            //system.debug('pageRef@@@ ' + pageRef);
            RETURN pageRef;
 
        }
 
 
         ELSE{RETURN NULL;}
 
 
 
    }
 
}