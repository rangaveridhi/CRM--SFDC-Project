public class File2ProductUploaderPOC {
    
    public Blob csvFileBody{get;set;}
    public string csvAsString{get;set;}
    public String[] csvFileLines{get;set;}
    public List<Product2> productList{get;set;}
    private PriceBook2 pbk;
    public File2ProductUploaderPOC(){
        csvFileLines = new String[]{};
            productList = New List<Product2>(); 
        
    }
    
/**
* Import the CSV file, read it line by line and insert Product and its Price in the PriceBookEntry.
*/
    public void importCSVFile(){
        List<String> prodCodes = new List<String>();
        List<Product2> listProducts = new List<Product2>();
        try{
            //CODE FOR READING FROM FILE IN Document Folder ...
            Document d = [select id, body from document where name = 'ProductPriceList'];
            Blob b = d.body;
            //String content = b.tostring();
            csvAsString = b.tostring();     
            System.debug('CONTENT FROM DOCUMETN FILE ______' + csvAsString);
            
            //          csvAsString = csvFileBody.toString();
            csvFileLines = csvAsString.split('\n'); 
            Product2 product;
            for(Integer i=1;i<csvFileLines.size();i++){
                product = new Product2() ;
                string[] csvRecordData = csvFileLines[i].split(',');
                product.Style_No__c = csvRecordData[0]; 
                product.Material__C= csvRecordData[1]; 
                product.Name=csvRecordData[2];
                product.Product_Type__C=csvRecordData[3];
                product.ProductCode=csvRecordData[4];
                product.Collection__c=csvRecordData[5];
                product.Category__C=csvRecordData[6];
                product.Category_Code__c=csvRecordData[7];
                product.Sub_Category_Name__c=csvRecordData[8];
                product.Store_Location__c=csvRecordData[9];
                product.Metal_KT__c=csvRecordData[10];
                product.Metal_Color__c=csvRecordData[11];
                product.Metal_Weight__c=csvRecordData[12];
                product.Diamond_Color__c=csvRecordData[13];
                product.Diamond_Clarity__c=csvRecordData[14];
                product.Diamond_Weight__c=csvRecordData[15];
                product.Designer_Name__c=csvRecordData[16];
                product.Vendor__c=csvRecordData[17];
                product.Concept__c=csvRecordData[18];
                product.Priority__c=csvRecordData[19];
                product.Order__C=csvRecordData[20];
                product.Product_Hierarchy__c=csvRecordData[21];
                product.Matching_Style_Ref_1__c=csvRecordData[22];
                product.Matching_Style_Ref_2__c=csvRecordData[23];
                product.Matching_Style_Ref_3__c= csvRecordData[24];
                product.Image_Extension__c=csvRecordData[25];
                product.productprice__C=decimal.valueOf(csvRecordData[26].trim());
                product.IsActive = TRUE;
                listProducts.add(product);
                productList.add(product);  
                prodCodes.add(csvRecordData[1]);
            }
            // UPSERT all the products
            upsert listProducts style_No__c;
            updateProductPriceList(listProducts);
        }
        catch (Exception e)
        {
            System.debug('Exception ' + e.getMessage() + e.getCause()+ e.getStackTraceString());
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR,'Error while importing CSV data.Please ensure input csv file is correct.');
            ApexPages.addMessage(errorMessage);
        }  
    }
    
    private void updateProductPriceList(List<Product2> productList){
     List<PriceBookEntry> listpbe= new List<PriceBookEntry>();
      List<PriceBookEntry> upsertlistpbe= new List<PriceBookEntry>();
        PriceBookEntry pbe;       
        Map<Id,PricebookEntry> pbeMap = new Map<Id,PricebookEntry>();
        pbk = [Select Id from PriceBook2 where name = 'Standard Price Book'];
        LIST<PricebookEntry> pbeList = [select Id,Product2Id, unitPrice from PricebookEntry where Pricebook2Id=:pbk.Id];
        
        for(PricebookEntry pbeLoop : pbeList){
                pbeMap.put(pbeLoop.Product2Id, pbeLoop);
            }
        for(product2 newProduct : productList){
            
            PriceBookEntry pbeUpsert = pbeMap.get(newProduct.Id);
            if(pbeUpsert!=null){
            pbeUpsert.UnitPrice=newProduct.ProductPrice__c; 
            upsertlistpbe.add(pbeUpsert);  
            
            }
          
            else{
                    pbe = new PriceBookEntry();
                    pbe.Pricebook2Id = pbk.Id;
                    pbe.Product2Id = newProduct.id;
                    pbe.UnitPrice = newProduct.ProductPrice__c;
                    pbe.IsActive = TRUE;        
                    listpbe.add(pbe);
                    
           
                
                }           
                
            
        
        }
        upsert upsertlistpbe;
        insert listpbe;
            
        
        }
    
}