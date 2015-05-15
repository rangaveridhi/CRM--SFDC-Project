global class HelperAddProducts {
    
    
    private static Integer openOpportunitiesCounter=0;
    private static Integer productsAddedCounter=0;
    public static list<contact> con = new list<contact>();
    // public static  Id con;
    public static list<string> duplicateProductsName= new list<string>();
    public static Opportunity_CS__c settings = Opportunity_CS__c.getInstance();
    public static String pName {get; set;} 
    
    
    HelperAddProducts(){
        duplicateProductsName.clear();
        
    }
    // Creation of Multiple Opportunities based on Product Selection    
    
    public static list<string>  addProductsToInteraction(List<cProduct> productList,string contactId,string accountID,string interactionID){
        
        
        
         ID stdPBid =  [SELECT Id FROM Pricebook2 WHERE IsStandard = true limit 1].Id;
          if(contactId!=null){
                
                con= [select AccountId from Contact where Id=:contactId limit 1];
                //ApexPages.currentPage().getParameters().put('accId', accountId);
            }
        for(cProduct prod: productList) {
            system.debug('Selected Products ----'+prod.prod2.name);
            
            
            //productList=null; // we need this line if we performed a write operation  because getContacts gets a fresh list now
            
            
           
            
            // List<PricebookEntry> PBEList = new List<PricebookEntry>();
            PriceBookEntry pbe = new PriceBookEntry();
            
            pbe= [SELECT Id,UnitPrice FROM PricebookEntry WHERE Pricebook2Id = :stdPBid AND Product2.Style_No__c=: prod.prod2.Style_No__c];
            system.debug('pbe:'+pbe);
            /*LIST<PriceBookEntry> pbeList = new LIST<PriceBookEntry>();
            pbeList= [SELECT Id FROM PricebookEntry WHERE Pricebook2Id = :stdPBid AND Product2.Material__c=: prod.prod2.Material__c]; */
            
            
            
            
           
            
            //String interactionId = System.currentPagereference().getParameters().get('InteractionId');
            
            //Check if the chosen product exits in ALL Interactions(current/previous), having Oppurtunity Status as Open and Stage is not bought or lost
            List<Opportunity> oppListCheck1=  [select id,name,opportunity.contact__r.name,stagename from opportunity
                                               where id in (select opportunityid from OpportunityLineItem where pricebookentryid=: pbe.id )
                                               and (stagename!='Bought' and stagename != 'Lost') and contact__r.id=: con.get(0).id and Availability_Status__c=true ]; 
            
            // Check if the chosen product exists in the CURRENT interaction and having Opportunity Status as Close.
            List<Opportunity> oppListCheck2=  [select id,name,opportunity.contact__r.name,stagename from opportunity
                                               where id in (select opportunityid from OpportunityLineItem where pricebookentryid=: pbe.id )
                                               and interaction__r.id=: interactionId and Availability_Status__c=false ];
            
            //Check if the chosen product exits in ALL Interactions(current/previous), having Oppurtunity Status as Open and Stage is not bought or lost
            List<Opportunity> oppListCheck3=  [select id,name,opportunity.contact__r.name,stagename from opportunity
                                               where id in (select opportunityid from OpportunityLineItem where pricebookentryid=:pbe.id )
                                               and (stagename!='Bought' and stagename != 'Lost') and contact__r.id=: con.get(0).id and Availability_Status__c=true ]; 
            
            
            Boolean productExistsWithStatusOtherThanBoughtOrLost= false;
            Boolean productExistWithinTheSameInteraction=false;
            Boolean productExist_Contact_Open_StyleNo= false;
            
            if (oppListCheck1.size() > 0){
                
                productExistsWithStatusOtherThanBoughtOrLost= true;
                
            }  
            
            
            if (oppListCheck2.size() > 0){
                
                productExistWithinTheSameInteraction= true;
                
            }  
            if (oppListCheck3.size() > 0){
                
                productExist_Contact_Open_StyleNo= true;
                
            }   
            
            
            system.debug('Status ');
            if(productExistsWithStatusOtherThanBoughtOrLost==true){
                if(prod.open==false && productExistWithinTheSameInteraction==false ){
                    createOpportunity(pbe,prod,interactionID,accountID);    
                    
                } 
                
                if(productExist_Contact_Open_StyleNo== true){
                    
                    updateOpportunity(pbe,prod,interactionID,accountID);                       continue;
                    
                }
                else{ 
                    duplicateProductsName.add(oppListCheck1.get(0).name); 
                    
                }
            }   
            else if (productExistWithinTheSameInteraction==true){
                
                
                
                if(prod.open==true){
                    createOpportunity(pbe,prod,interactionID,accountID);    
                    
                    
                }
                else{ 
                    duplicateProductsName.add(oppListCheck2.get(0).name); 
                    
                    
                    
                    continue;
                }
            }                  
            
            
            
            
            
            else {         try{
                createOpportunity(pbe,prod,interactionID,accountID);
                
            }catch (Exception e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops! two'));
            }
                  
                 } 
            
            
        } 
        
        
        productsAddedCounter=productsAddedCounter-openOpportunitiesCounter;
        system.debug('Before productsAddedCounter: '+productsAddedCounter + 'openOpportunitiesCounter: '+openOpportunitiesCounter);
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,+productsAddedCounter+' Products shown  '+'<br></br>'+openOpportunitiesCounter+' Open opportunities')); 
        
        productsAddedCounter=0;
        openOpportunitiesCounter=0;
        system.debug('After productsAddedCounter: '+productsAddedCounter + 'openOpportunitiesCounter: '+openOpportunitiesCounter);  
        
        system.debug('duplicateProductsName size in helper class:  '+duplicateProductsName.size());
        return duplicateProductsName;
        
    }  
    
    // creates opportunities for the respective products selected
    public static void createOpportunity(PriceBookEntry pbe, cProduct prod,String interactionId, String accountId){
        
        try{
            System.debug('Selected products in the opp creation method------'+prod);
            Opportunity opp= new Opportunity();
            opp.Name= prod.prod2.Style_No__c+ ' - ' +prod.prod2.name;
            opp.StageName= prod.selectedOpp;
            integer noOfDays=settings.Set_no_of_days_to_close__c.intValue();
            opp.CloseDate = System.today().addDays(noOfDays);
            opp.AccountId = accountId;
            opp.Interaction__c = interactionId;
            
            if(System.currentPagereference().getParameters().get('campaignID')!=null && System.currentPagereference().getParameters().get('campaignID')!=''){
                opp.CampaignId=System.currentPagereference().getParameters().get('campaignID');
            }
            
            opp.AccountId= con.get(0).AccountId;
            opp.Product_Status__c=prod.selectedProd;
            
            opp.Reason_for_Rejection__c=prod.selectedReason;
            opp.contact__c= con.get(0).id;
            opp.Availability_Status__c = prod.open;
            
            insert opp;
            System.debug('Opp Id and Pbe id in Helper Add Product'+opp.id+'--------------'+pbe.id);
            OpportunityLineItem oli = new OpportunityLineItem();
            oli.UnitPrice=pbe.UnitPrice;//Unless you are pricing differently
            oli.Quantity=1;
            oli.PricebookEntryId=pbe.id;
            oli.OpportunityId = opp.Id;
            System.debug('Opp Id and Pbe id in after Helper Add Product'+opp.id+'--------------'+pbe.id);
            insert oli;
            
        }
        catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops! three'+e));
            // return null;
        }
        
        if(prod.open==true){
            openOpportunitiesCounter++;
        }
        
        productsAddedCounter++;
        
    }
    
    
    public static void updateOpportunity(PriceBookEntry pbe, cProduct prod,String interactionId, String accountId){
        
        Opportunity oppUpdate =  [select id,name,opportunity.contact__r.name,stagename,interaction__c from opportunity
                                  where id in (select opportunityid from OpportunityLineItem where pricebookentryid=:pbe.id )
                                  and (stagename!='Bought' and stagename != 'Lost') and contact__r.id=: con.get(0).id and Availability_Status__c=true limit 1 ];
        
        
        
        oppUpdate.StageName=prod.selectedOpp;
        update oppUpdate;
        
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'These opportunities have been updated:'+oppUpdate.Name));      
        
    }
    
    
    
    
    
    
}