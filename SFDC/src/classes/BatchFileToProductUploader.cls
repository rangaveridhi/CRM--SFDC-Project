global class BatchFileToProductUploader implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
     System.debug('execute batch process--------------------start method');
       FileToProductUploader filetoproduct=new FileToProductUploader();
       filetoproduct.importCSVFile();
       Date d= System.today();
       return Database.getQueryLocator('SELECT Id,ProductPrice__c from Product2 where createdDate=TODAY');
        
    }

    global void execute(Database.BatchableContext BC, list<sObject> items){
      System.debug('excute batch process------------execute method.............');
        //List<Product2> productList = (List<Product2>)items;
         
         PriceBook2 pbk = [Select Id from PriceBook2 where name = 'Standard Price Book'];
          for(sObject product1 : items){
            Product2 product=(Product2)product1;
            updatePrice(product,pbk.Id);
        }
    }
    
    public void updatePrice(Product2 product,Id pbkId){
        List<PriceBookEntry> listpbe;
        System.debug('Entered into updateprice method-----------------------');
        PriceBookEntry pbe;
        listpbe = [SELECT Id from PriceBookEntry where Product2Id = :product.id and Pricebook2Id=:pbkId];
        if(listpbe != null && listpbe.size() != 0){
            pbe = listpbe[0];
            pbe.UnitPrice = product.ProductPrice__c;
            try{
                upsert pbe;
            }catch(Exception e){
                System.debug('ERROR INSERTING PRICE BOOK ENTRY FROM FILETORECORDUPLOADER');
            }
        }else{
            pbe = new PriceBookEntry();
            
            pbe.Pricebook2Id = pbkId;
            pbe.Product2Id = product.id;
            pbe.UnitPrice = product.ProductPrice__c;
                                pbe.IsActive = TRUE;        
            try{
                insert pbe;
           }catch(Exception e){
                System.debug('ERROR INSERTING PRICE BOOK ENTRY FROM FILETORECORDUPLOADER');
            }
                 
        }   
    }
         
    
     
    
    global void finish(Database.BatchableContext BC){
       // if(!Test.isRunningTest()){
       //  Database.executeBatch(new BatchFileToProductUploader(),200);
        //}
    }
}