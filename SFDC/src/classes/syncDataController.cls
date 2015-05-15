public class syncDataController {

   // public String interact { get; set; }
    
    private final RemoteSessionData__c syncdata;
    public List<AggregateResult> listSessionProfiles{get;set;}  
    public List<AggregateResult> finallist{get;set;}
    public list<Product2> listOpportunityProducts  {get;set;} 
    public list<remoteSessionData__c> listOppProdsOutOfSync = new List<remoteSessionData__C>();
    public List<cProduct> selectedProducts {get;set;} 
    public Integer listsize {get;set;}
    public Integer productListsiZe {get;set;}
    public String val1{get;set;}  
    public String val2{get;set;}
    
    public  List<cProduct> productList{get;set;}
    
    public Contact contact {get;set;}   
    public List<contact> listCon ;  
    public List<remoteSessionData__c> listRSDSetFlag ;
    public  List<remoteSessionData__c> updatelistRSDSetFlag = new List<remoteSessionData__C>();
    
    public List<remoteSessionData__c> listRSDSetFlag1 ;
    public  List<remoteSessionData__c> updatelistRSDSetFlag1 = new List<remoteSessionData__C>();
    public String contactId;
    public String accountId;
    public String interactionId;    
    public list<string> duplicateProductsName= new list<string>();   
    public boolean isDeleted {get; set;}
    public boolean displayPopup {get; set;} 
    public boolean showMessage{get; set;}  
    public boolean outOfSyncNotice {get; set;}  
    public string actionPointText {get; set;} 
    public interaction__c aInteract {get; set;} 
   
    
    
    
    // Change Set 20 Ipad Sync Issue on 8th May 2015 starts here- @Ranga----------------------------
    /*
    private final Product2 prod;
     public SyncDataController(ApexPages.StandardController stdController) {
        this.prod = (Product2)stdController.getRecord();
        
      }
    */
    
    // Change Set 20 Ipad Sync Issue on 8th May 2015 Ends here- @Ranga----------------------------
    
    
    
    public syncDataController() {
    
        //String loggedInUsername = user.name;
        aInteract = new Interaction__C();
        contact = new Contact();
        selectedproducts= new List<cproduct>();
        if(ApexPages.CurrentPage().getParameters().get('profileId')!=null){
        contact.Profile_name__C=ApexPages.CurrentPage().getParameters().get('profileId');
        }
        String userName = UserInfo.getUserName();
        
        User activeUser = [Select Email From User where Username = : userName limit 1];
        String userEmail = activeUser.Email;
        system.debug('Active userEmail:' +userEmail);
        //listSessionProfiles = [Select SessionID__c,Customer_Name__c,Ipad_UserName__c from RemoteSessionData__c group by SessionID__c,Customer_Name__c,Ipad_Username__c ];
        listSessionProfiles = [Select SessionID__c,Customer_Name__c,Sales_User_s_Name__c,Interaction_Name__c,day_only(createdDate) createdonDate,count(createdDate) numCreated from RemoteSessionData__c where Ipad_UserName__c=:useremail and isDeleted__c != true group by day_only(createdDate),Interaction_Name__c,SessionID__c, Customer_Name__c,Sales_User_s_Name__c order by day_only(createdDate) desc];
                
        listsize = 0;
        productListSize=0;
        listOppProdsOutOfSync.clear();
        OutOfSyncNotice=false;
        
    } 
    
    
    
    
    public PageReference syncDataPage2() 
    {  
        // Your code here
        val1 = ApexPages.CurrentPage().getParameters().get('val1');
        val2 = ApexPages.CurrentPage().getParameters().get('val2');
        
        system.debug('val1: '+val1 +' val2: '+val2 );
        PageReference redirect = new PageReference('/apex/syncDataPage2'); 
        
        
        try{
            listOpportunityProducts =[select ProductCode, Style_No__c, Name,Material__c, (Select SessionID__c, product__c, product__r.name, product__r.Style_No__c, Customer_Name__c, Interaction_Name__c,                                   Interaction_Reason_for_Acceptance_or_Rej__c, Opp_Reason_for_acceptance_rejection__c, Medium_of_Interaction__c, 
                                                                                          Opportunity_Stage__c, Outcome__c, Product_Status__c, Product_Style_No__c, Ipad_Username__c, Sales_User_s_Name__c, Start_Date__c,
                                                                                          Action_point__c, Action_point_Date__c, Availability__c,If_Time_Spent_on_Level_1__c,If_Time_Spent_on_Level_2__c,
                                                                                          Time_Spent_On_Level_1_in_Minutes__c,Time_Spent_On_Level_2_in_Minutes__c,start_date_time__c,End_Date_Time__c from RemoteSessionData__r where SessionID__c=:val1 and Customer_Name__c=:val2  ) 
                                      from product2 where id in (Select product__c from RemoteSessionData__c where SessionID__c=:val1 and Customer_Name__c=:val2 ) ];
            listsize = listOpportunityProducts.size();
            system.debug('listsize:'+listsize);
            /*if(listSize == 0) 
            {
                throw new syncException();
            }    */                 
            
            
            listOppProdsOutOfSync =[Select Product_Style_No__c from RemoteSessionData__c where SessionID__c=:val1 and Customer_Name__c=:val2 and Product__c=null ];
            system.debug( 'listOppProdsOutOfSync' +listOppProdsOutOfSync);
            
            
             if(listOppProdsOutOfSync.size() > 0){ 
                    OutOfSyncNotice = true;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'The products with the below Style number are not available in Salesforce'));   
                   
                 for(RemoteSessionData__c outOfSync :listOppProdsOutOfSync ) {
                     // System.debug('list opp products-----------------'+outOfSync.Product_Style_No__c);  
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,+outOfSync.Product_Style_No__c));
                    }   
                    
            }   
            
            
        }
       
        catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'YOUR MESSAGE HERE'));
            return null;
        }
        
        
        
      //  system.debug('listOpportunityProducts: '+listOpportunityProducts);
        
        
        
        
        productList= new List<cProduct>();
        
        
        for(Product2 c:listOpportunityProducts  ) {
            system.debug('productList in iteration: '+c );
            productList.add(new cProduct(c,c.RemoteSessionData__r.get(0).Opportunity_Stage__c,c.RemoteSessionData__r.get(0).Product_Status__c,c.RemoteSessionData__r.get(0).Opp_Reason_for_acceptance_rejection__c,c.remoteSessionData__r.get(0).Availability__c));
            
        }
        
        
        system.debug('productList size: '+productList.size());
        productListSize = productList.size();
        
        redirect.setRedirect(false); 
        return redirect;
        
    }
    
    public dateTime dateFormatConversion(String dateString){
     
   dateString = '"' +dateString +'"';
   
   DateTime  dt = (Datetime)json.deserialize(dateString, datetime.class);
     
   system.debug('DateTime StartTime and EndTime:' +dt  +dateString);  
     
     return dt;  
     
      /* String[] stringdatesplit=dateString.split('T');
              string datetimetest=dateString.substring(0,10);
              String datetimeonly=dateString.substring(11,16);
        
        String stringDate = datetimetest + ' ' +datetimeonly;
                
        return stringDate;  */
        
        
        
        
        
    }
    
    public PageReference addProduct(){  
        
        
        
         System.debug('action point date-----------------------------------------' +aInteract.Action_Point_date__c);
      //List<cProduct> selectedProducts = new LIST<cProduct>();
        
        for(cProduct cprod:productList ) {
            
            if(cprod.selected == true) {
                selectedProducts.add(cprod);
                // system.debug('selected Products:' +selectedProducts);
                
            }
        } 
        
        If(contact.Profile_Name__c == null){
         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Please choose a profile name'));
                return null;
        
        }
        
        system.debug('selectedproductList size: '+selectedProducts.size());
        if(selectedProducts.size()==0){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'No opportunity is selected.Please select a product to create an opportunity'));
                return null;
           }
        
        
        listCon  = [select id,accountID from contact where Id =: contact.Profile_Name__c Limit 1  ];
        if(listCon!=null && listCon.size()>0){
            Interaction__c interact = new interaction__c();
            interact.Contact__c=listCon.get(0).id;
            interact.Account__c=listCon.get(0).accountId;
            String dateActionPoint = ApexPages.CurrentPage().getParameters().get('actionpointdate');
                     
             
            interact.Action_point_date__c =aInteract.Action_Point_date__c;
             interact.Associated_Store__C =aInteract.Associated_Store__C;
             interact.Staff_1__c =aInteract.Staff_1__c;
            interact.Action_Point__c= aInteract.Action_Point__C;
                   
            interact.Medium_of_Interaction__c= listOpportunityProducts.get(0).RemoteSessionData__r.get(0).Medium_of_Interaction__c;
            
            /*
               Any new Fields can be added here.....
               Ex: interact.Staff_1__c =aInteract.Staff_1__c;
            */
            
            
            /*
               Changes ends here
            */
            
            
           // interact.Reason_for_Rejection_Acceptance__c=listOpportunityProducts.get(0).RemoteSessionData__r.get(0).Interaction_Reason_for_Acceptance_or_Rej__c;
            interact.Outcome__c=listOpportunityProducts.get(0).RemoteSessionData__r.get(0).Outcome__c;
            interact.Start_Time__c=listOpportunityProducts.get(0).RemoteSessionData__r.get(0).Start_Date__c;
            
            
            
             interact.If_Time_Spent_on_Level_1__c=listOpportunityProducts.get(0).RemoteSessionData__r.get(0).If_Time_Spent_on_Level_1__c;
            interact.If_Time_Spent_on_Level_2__c=listOpportunityProducts.get(0).RemoteSessionData__r.get(0).If_Time_Spent_on_Level_2__c;
            interact.Time_Spent_On_Level_1_in_Minutes__c=listOpportunityProducts.get(0).RemoteSessionData__r.get(0).Time_Spent_On_Level_1_in_Minutes__c;
            interact.Time_Spent_On_Level_2_in_Minutes__c=listOpportunityProducts.get(0).RemoteSessionData__r.get(0).Time_Spent_On_Level_2_in_Minutes__c;
           // if(listOpportunityProducts.get(0).RemoteSessionData__r.get(0).Start_Date_Time__c!= null) interact.Start_Time__c= dateFormatConversion(listOpportunityProducts.get(0).RemoteSessionData__r.get(0).Start_Date_Time__c);
            if(listOpportunityProducts.get(0).RemoteSessionData__r.get(0).End_Date_Time__c!= null) interact.End_Time__c=  dateFormatConversion(listOpportunityProducts.get(0).RemoteSessionData__r.get(0).End_Date_Time__c);
            // system.debug('listOpportunityProducts-medium of interaction:' + listOpportunityProducts.get(0).RemoteSessionData__r.get(0).Medium_of_Interaction__c);
            insert interact;
            
            interactionId=interact.id;
            contactID= listCon.get(0).id;
            accountId=listCon.get(0).accountId;
        }
        
        
       
        duplicateProductsName  = HelperAddProducts.addProductsToInteraction(selectedProducts, contactId, accountID, interactionID); 
        
        
        if(duplicateProductsName.size()>0)   
        {  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Opportunities have been created for the products selected however opportunities for below products already exists as part of same or previous interactions:')); 
         for(string prodName : duplicateProductsName  ){
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,+prodName));
         }
         duplicateProductsName.clear();
         return null;
        } 
        
        system.debug('isDeleted:' +isdeleted);  
        
        if(isDeleted == true){
            
            listRsdSetFlag = [Select sessionId__c,isDeleted__c from RemoteSessionData__c where SessionID__c=:val1 ];
            system.debug('listRsdSetFlag:' +listRsdSetFlag );
            for(RemoteSessionData__c rd : listRsdSetFlag ){
                
                rd.isDeleted__c = true;
                updatelistRSDSetFlag.add(rd);
            }
            if(updatelistRSDSetFlag!= null){
                update(updatelistRSDSetFlag);
            }
        } 
        
        
        PageReference pr = new PageReference('/' +interactionID );
        pr.setRedirect(true);
        
        displayPopup = true;
        
        
        return null;
    }
    
    public PageReference enableCreateOpp(){
        
        for(cProduct prod: productList) {
            // cProduct cProd;
            System.debug('Selected Opp Stagee-----------------------'+prod.selectedOpp);
            if(prod.selectedOpp=='Shortlisted'){
                prod.open=true;
            }
            else{
                prod.open=false;
            }
            
        }
        return null;
    }
     
    
    
    
    
   
    public void showPopup()
    { 
        
        displayPopup = true; 
        
    } 
    
    public PageReference closePopup()
    { 
        displayPopup = false; 
        //PageReference pr = new PageReference(); 
        //pr.setRedirect(true); 
        return null;
        
    }      
    
    
    
    public PageReference okay(){
        
        PageReference pr = new PageReference('/' +interactionID );
        pr.setRedirect(true);
        return pr;       
    }    
    public PageReference cancel(){
        
          String tabId= ApexPages.currentPage().getParameters().get('sfdc.tabName');
        string onCancel = 'apex/syncDataPage?sfdc.tabName=';
                        PageReference pr = new PageReference('/' +onCancel+tabId);
                        pr.setRedirect(true);
                 return pr;
                    }
  
    
    public PageReference deleteSession(){
        
        
        listRsdSetFlag1 = [Select sessionId__c,isDeleted__c from RemoteSessionData__c where SessionID__c=:val1 ];
        system.debug('listRsdSetFlag:' +listRsdSetFlag1 );
        for(RemoteSessionData__c rd : listRsdSetFlag1 ){
            
            rd.isDeleted__c = true;
            updatelistRSDSetFlag1.add(rd);
        }
        if(updatelistRSDSetFlag1!= null){
            update(updatelistRSDSetFlag1);
        }
        
        
         String tabId= ApexPages.currentPage().getParameters().get('sfdc.tabName');
        string onDelete = 'apex/syncDataPage?sfdc.tabName=';
        PageReference pr = new PageReference('/' +onDelete+tabId);
        pr.setRedirect(true);
        return pr;
        
    }  
}