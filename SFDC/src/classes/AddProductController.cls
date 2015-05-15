public class AddProductController {
    
    List<Product2> products {get; set;}
    
    private final Product2 prod;
    public boolean displayPopup {get; set;} 
    public boolean showMessage{get; set;} 
    public String soql{get;set;}
    public List<cProduct> productList {get; set;}
    public String productCode {get; set;}
    public String SelectedOpp {get; set;}
    public String SelectedReason {get; set;}
    public String SelectedProd {get; set;}
    public integer SelectedQuantity {get; set;}
    public String productName {get; set;}
    public String styleNo{get; set;}
    public Boolean checkboxval {get;set;}
    boolean errorOut =false;
    public Boolean selectedOppStage{get;set;}
    public list<string> duplicateProductsName= new list<string>();
    public integer productsAddedCounter=0;
    public integer openOpportunitiesCounter=0;
    public interaction__c interactionName{get;set;}
    
    
    
    String interactionId = System.currentPagereference().getParameters().get('InteractionId');
    Id pricebookIDSoql;
    String contactId = System.currentPagereference().getParameters().get('contactId'); 
    Contact  con = new Contact(); 
    String accountId = System.currentPagereference().getParameters().get('accountId');
    Opportunity_CS__c settings = Opportunity_CS__c.getInstance();
    
    
    // format the soql for display on the visualforce page
    public String debugSoql {
        get { return soql + ' limit 10'; }
        set;
    }
    
    // init the controller and display some sample data when the page loads
    public AddProductController(ApexPages.StandardController stdController) {
        this.prod = (Product2)stdController.getRecord();
        
        soql = 'select Id,ProductCode,Style_No__c, Name,Material__c from product2 where id in (select Product2Id from PricebookEntry where pricebook2id=:pricebookIDSoql ) and isActive=true limit 20';
        interactionName = [select Interaction_Name__c from interaction__c where id=:interactionId Limit 1];
        pricebookIDSoql=[Select id from priceBook2 where name='Standard Price Book'].id;
        runQuery();
        duplicateProductsName.clear();
        showMessage=true;
    }
    
    
    
    // runs the actual query
    public void runQuery() {
        
        try {
            
            productList= new List<cProduct>();
            for(Product2 c: Database.query(soql)) {
                productList.add(new cProduct(c));
            }
            
            
            // productsForTable    = Database.query(soql);
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.info, 'No records available'));
        }
        
    }
    
    // runs the search with parameters passed via Javascript
    public void runSearch() {
        
        
        string interactionId = Apexpages.currentPage().getParameters().get('InteractionId');
        
        
        
        soql = 'select Id,ProductCode,Style_No__c, Name,Material__c from product2 where id in (select Product2Id from PricebookEntry where pricebook2id=:pricebookIDSoql)';
        if (!styleNo.equals(''))
            soql += ' and Style_No__c LIKE \''+'%'+styleNo+'%'+'\' ';
        
        
        
        
        if (!productName.equals(''))
            soql += ' and name LIKE \''+'%'+productName+'%'+'\'  ';
        
        soql += 'and isActive=true limit 20';
        
        runQuery();
        
        
    }
    
    
    
    
    public List<cProduct> getAllProducts() {
        try{
            if(productList== null) {
                productList= new List<cProduct>();
                for(Product2 c: [select Id,ProductCode,Style_No__c, Name,Material__c from product2 where id in (select Product2Id from PricebookEntry where pricebook2id=:pricebookIDSoql ) and isActive=true  limit 20]) {
                    productList.add(new cProduct(c));
                }
            }
            return productList;
        }
        
        catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops! five'));
            return null;
        }
    }
    
    public List<SelectOption> getProductStatus(){
        
        try{
            List<SelectOption> prodList= new List<SelectOption>();
            //Schema.sObjectType objType = obj.getSObjectType(); 
            Schema.DescribeFieldResult fieldResult =Opportunity.Product_Status__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            
            prodList.add(new selectOption('', 'None'));
            for( Schema.PicklistEntry f : ple)
            {
                
                prodList.add(new SelectOption(f.getLabel(), f.getValue()));
            }       
            return prodList;   
        }
        
        catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops! six'));
            return null;
        }   
    }
    
    public List<SelectOption> getOppStage(){
        try{
            List<SelectOption> oppList= new List<SelectOption>();
            
            Schema.DescribeFieldResult fieldResult =Opportunity.StageName.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            
            //oppList.add(new selectOption('', 'None'));
            for( Schema.PicklistEntry f : ple)
            {
                
                oppList.add(new SelectOption(f.getLabel(), f.getValue()));
            }       
            return oppList;   
        }  
        
        catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops! seven'));
            return null;
        }
    }
    
    
    public List<SelectOption> getReasons(){
        try{
            List<SelectOption> reasonList= new List<SelectOption>();
            Schema.DescribeFieldResult fieldResult =Opportunity.Reason_for_Rejection__c.getDescribe();
            List<Schema.PicklistEntry> rle = fieldResult.getPicklistValues();
            
            reasonList.add(new selectOption('', 'None'));
            for( Schema.PicklistEntry f : rle)
            {
                
                reasonList.add(new SelectOption(f.getLabel(), f.getValue()));
            }       
            return reasonList;   
        }   
        catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops! eight'));
            return null;
        }
    }    
    
    
    
    //Creates opportunity for selected products and remains on the same page
    public PageReference addProduct(){   
        
        try{
            List<cProduct> selectedProducts = new List<cProduct>();
            system.debug('ProductList in add Product:' +getAllProducts());
            
            for(cProduct cprod: getAllProducts()) {
                if(cprod.selected == true) {
                    selectedProducts.add(cprod);
                    
                }
            }
            
            if(selectedProducts.size()==0){  
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'No opportunity is selected.Please select a product to create an opportunity'));
                
            }  
            
            
            duplicateProductsName  = HelperAddProducts.addProductsToInteraction(selectedProducts, contactId, accountID, interactionID);
            system.debug('duplicateProductsName size: '+duplicateProductsName.size());
            system.debug('Before helper errorOut' +errorOut);
            if(duplicateProductsName.size()>0){errorOut=true;}
            system.debug('After helper errorOut' +errorOut);
            
            if(duplicateProductsName.size()>0)   
            {  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Opportunities have been created for the products selected however opportunities for below products already exists as part of same or previous interactions:')); 
             for(string prodName : duplicateProductsName  ){
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,+prodName));
             }
             duplicateProductsName.clear();
             runQuery();
             return null;
            }  
            
            
            
            
            //PageReference pr = new PageReference('/' +System.currentPagereference().getParameters().get('InteractionId') );
            // pr.setRedirect(true);
            return null;
        }
        
        catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops!  nine '+e));
            return null;
        }
    }
    
    //Creates opportunity for selected products and returns to interaction page 
    public PageReference addProductandClose(){   
        
        try{
            List<cProduct> selectedProducts = new List<cProduct>();
            
            for(cProduct cprod: getAllProducts()) {
                if(cprod.selected == true) {
                    selectedProducts.add(cprod);
                    
                }
            }
            
            if(selectedProducts.size()==0){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'No opportunity is selected.Please select a product to create an opportunity'));
                return null;
            }
            duplicateProductsName = HelperAddProducts.addProductsToInteraction(selectedProducts, contactId, accountID, interactionID);
            system.debug('duplicateProductsName in add prod and close: '+duplicateProductsName);
            
            //  if(duplicateProductsName.size()>0 ){errorOut =true;}
            if(duplicateProductsName.size()>0 )   
            {  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Opportunities have been created for the products selected however opportunities for below products already exists as part of same or previous interactions:')); 
             for(string prodName : duplicateProductsName  ){
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,+prodName));
             }
             runQuery();
             duplicateProductsName.clear();
             return null;
            }  
            else{
                PageReference pr = new PageReference('/' +System.currentPagereference().getParameters().get('InteractionId') );
                pr.setRedirect(true);
                //return pr;
                displayPopup = true;
                showMessage =false;
                return null;
                
            } 
            
        }
        catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops! ten ' +e));
            return null;
        }
        
    }  
    
    
    // returns to interaction page without creating opportunities
    public PageReference cancel(){
        
        
        PageReference pr = new PageReference('/' +System.currentPagereference().getParameters().get('InteractionId') );
        pr.setRedirect(true);
        return pr;
        
    }  
    
    
    
    
    public PageReference enableCreateOpp(){
        
        for(cProduct prod: getAllProducts()) {
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
        
        PageReference pr = new PageReference('/' +System.currentPagereference().getParameters().get('InteractionId') );
        pr.setRedirect(true);
        return pr;       
    }      
    
    
}