public class ProfileExtension{
    
    public boolean displayPopup {get; set;} 
    public Account account{get;set;}
    
    public String accountName{get;set;}
    ApexPages.StandardController stdController;
    public Contact acct;
    public ProfileExtension(ApexPages.StandardController stdController) {
        this.acct = (Contact)stdController.getRecord();
        acct.MobilePhone = '+91';
        //this.account= (Account)stdController.getRecord();
        // relation.Parent_Contact__c = System.currentPagereference().getParameters().get('contactid');
        //relpanel=false;
        this.stdController = stdController;
        // String aName = account.Name;
        //System.debug('account Name in consturctor--------------');
    }
    
    public PageReference closePopup()
    { 
        displayPopup = false; 
        //PageReference pr = new PageReference(); 
        //pr.setRedirect(true); 
        return null;
        
    } 
    public void showPopup()
    { 
        
        displayPopup = true; 
        
    } 
    
    
    public PageReference save(){
        
        try{
            If(ApexPages.currentPage().getParameters().get('retURL') != null){
                if(acct.AccountId!=null){
                    stdController.save();
                    //   if(acct.Campaign__c!=null){       
                    //System.debug('Campaign and Profile Id---------------'+acct.Campaign__c+'----'+stdController.getId());      
                    //CampaignMember c = new CampaignMember(CampaignID = acct.Campaign__c,ContactId=stdController.getId(),Status='Opt-In');
                    // campaignMember.Campaign.Id = acct.Campaign__c;
                    //campaignMember.Contact.Id=stdController.getId();
                    // insert c; 
                    //  System.debug('campaignmember is  saved---------');             
                    //}             
                }
                else{
                    ApexPages.Message myMsg = new  ApexPages.Message(ApexPages.Severity.ERROR,'Account Name should be mandatory.');
                    ApexPages.addMessage(myMsg);
                }
                if(stdController.getId()!=null){
                    
                    if(ApexPages.currentPage().getParameters().get('retURL').contains('contactid')){
                        
                        PageReference pr = new PageReference(ApexPages.currentPage().getParameters().get('retURL'));
                        return pr;
                    }
                    else if(ApexPages.currentPage().getParameters().get('retURL').contains('CustomRelation')){
                        PageReference pr = new PageReference(ApexPages.currentPage().getParameters().get('retURL'));
                        // Relation__c rel = new Relation__c();
                        // List<Contact> contactName=[SELECT NAME FROM Contact where id=:stdController.getId() limit 1];
                        //rel.Related_Contact__c=contactName.get(0).NAME;
                        pr.setRedirect(false); 
        
                        return pr;
                        
                    }
                    
                    else if(ApexPages.currentPage().getParameters().get('retURL').contains('syncDataPage')){
                        PageReference pr = new PageReference(ApexPages.currentPage().getParameters().get('retURL'));
                        pr.getParameters().put('profileId',stdController.getId());
                        return pr;
                        
                    }
                    else{
                        PageReference pr1 = new PageReference('/'+stdController.getId());
                        return pr1;
                    }
                }
                else{
                    
                    return null;
                } 
            }
            else{
                return null;
            }
        }
        
        catch(Exception e){
            ApexPages.Message myMsg = new  ApexPages.Message(ApexPages.Severity.ERROR,'Unable to create the Profile.');
            ApexPages.addMessage(myMsg);
            displayPopup = false;
            return null;
        }
        
        finally{
            
        
            
        }
    }
    
    public PageReference saveAccount(){
        
        try{
            if(accountName!=null && accountName!=''){
                Account acc= new Account();
                acc.Name=accountName;
                insert acc;
                
                displayPopup = false;
                acct.AccountId=acc.Id;
                return null;
            }
            else{
                System.debug('empty account name');
                ApexPages.Message myMsg = new  ApexPages.Message(ApexPages.Severity.ERROR,'Please Enter Account Name' );
                ApexPages.addMessage(myMsg);
                displayPopup = true;
                return null;
            }
            
            //  PageReference newpage = new PageReference(System.currentPageReference().getURL());
            // newpage.setRedirect(true);
            
            
            
            
        } 
        /*catch(Exception e){
            ApexPages.Message myMsg = new  ApexPages.Message(ApexPages.Severity.ERROR,'Unable to create the Account.' );
            ApexPages.addMessage(myMsg);
            displayPopup = false;
            return null;
        }
        */
        finally{}
        
    }
    
    
    public PageReference populateCountryCode(){
        //Your logic to check if the appropriate pick list values have been set for the input field
        for (IContact__c iso : IContact__c.getAll().values()){
            
            System.debug('India Code---------------------: '+acct.MobilePhone);
            
            if(iso.Name==acct.Country__c){
                acct.MobilePhone = iso.Country_Code__c;
            }
            else{
                acct.MobilePhone='';
            }
        }
        return null;
    }
}