public class AddProductToCompaignController {

 List<Product2> products {get; set;}
       //PUBLIC  List<cProduct> productsForTable {get; set;}
         private final Product2 prod;
         public String soql{get;set;}
         public List<cProduct> productList {get; set;}
         public String productCode {get; set;}
         public String styleNo{get; set;}
         public String productName {get; set;}
         public String campaignName {get; set;}  
          string pricebookIDSoql='01s30000000JNAWAA4';
    product2 prodId = new Product2();
    
    

    public AddProductToCompaignController(ApexPages.StandardController controller) {
        this.prod = (Product2)Controller.getRecord();
        soql = 'select Id,ProductCode,Style_No__c, Name from product2 where id in (select Product2Id from PricebookEntry where pricebook2id=:pricebookIDSoql ) and isActive=true limit 20';
        campaignName = System.currentPagereference().getParameters().get('campaignName');
        runQuery();
    }          
     public PageReference runSearch() {

    System.debug('entered into runSearch method=================');

    //String productCode= Apexpages.currentPage().getParameters().get('productCode');
    //String productName = Apexpages.currentPage().getParameters().get('productName');
    

    soql = 'select Id,ProductCode,Name,Style_No__c from product2 where name != null ';
    if (!styleNo.equals(''))
    soql += ' and Style_No__c LIKE \''+'%'+styleNo+'%'+'\'';
    // soql += ' and productCode LIKE '+ '''+ String.escapeSingleQuotes(productCode)+'%'+''';
    // soql += ' and productCode LIKE ' ';
     
     
      
    if (!productName.equals(''))
      soql += ' and name LIKE \''+'%'+productName+'%'+'\'';
   
    // run the query again
    runQuery();

    return null;
  }

 
    
    
    public void runQuery() {

    try {
    System.debug('runquery method-----------------');
    System.debug(soql);
    System.debug('runquery method ends------------------');
    
    productList= new List<cProduct>();
            for(Product2 c: Database.query(soql)) {
                productList.add(new cProduct(c));
            }
     
    
  // productsForTable    = Database.query(soql);
    } catch (Exception e) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops!'));
    }

  }

    
    public List<cProduct> getAllProducts() {
        if(productList== null) {
            productList= new List<cProduct>();
            for(Product2 c: [select Id,ProductCode,Style_No__c, Name from product2 where id in (select Product2Id from PricebookEntry where pricebook2id=:pricebookIDSoql ) and isActive=true  limit 20]) {
                productList.add(new cProduct(c));
            }
        }
        return productList;
    }  
        
         public Boolean checkboxval {get;set;}
    
    
    // This is a Wrapper class , to implement Selected Product list
   
   public class cProduct{
   
     public Product2 prod2 {get; set;}
     public Boolean selected {get; set;}
     
     
   
   public cProduct(Product2 c) {
            prod2 = c;
            selected = false;
           
        }
      }
   
      public PageReference addProduct(){  
      List<cProduct> selectedProducts = new List<cProduct>();
    
    for(cProduct cprod: getAllProducts()) {
            if(cprod.selected == true) {
                selectedProducts.add(cprod);
                //System.debug('Selected Product ------------------SELECTED '+ cprod.prod2.name);
                
            }
    }
       for(cProduct prod: selectedProducts) {
                     
           system.debug('Selected Products ----'+ prod.prod2.name + 'Selected products Checkbox status---' + prod.selected); 
           
            CampaignProduct__c  cp = new CampaignProduct__c();
            cp.Campaign__c = System.currentPagereference().getParameters().get('campaignID');                     
            cp.Product__c = prod.prod2.id;
            insert cp;
        } 
        
      
      PageReference pr = new PageReference('/' +System.currentPagereference().getParameters().get('campaignId') );
        pr.setRedirect(true);
   return pr;
      }
    
}