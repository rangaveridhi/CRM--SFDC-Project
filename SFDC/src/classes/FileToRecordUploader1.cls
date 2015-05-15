// Controller for uploading product and its price .
global class FileToRecordUploader1 {
    
    public Blob csvFileBody{get;set;}
    public string csvAsString{get;set;}
    public String[] csvFileLines{get;set;}
    public List<Product2> productList{get;set;}
    private PriceBook2 pbk;
    public FileToRecordUploader1(){
        csvFileLines = new String[]{};
        productList = New List<Product2>(); 
                pbk = [Select Id from PriceBook2 where name = 'Standard Price Book'];
    }
    
    /**
     * Import the CSV file, read it line by line and insert Product and its Price in the PriceBookEntry.
     */
    public void importCSVFile(){
        List<String> prodCodes = new List<String>();
        try{
            //csvAsString = csvFileBody.toString(); // To read content from File Input from VF
            //Read the File from the Document Folder ...
            Document d = [select id, body from document where name = 'ProductPriceList' limit 1];
            Blob b = d.body;
            csvAsString = b.tostring();     

            csvFileLines = csvAsString.split('\n'); 
            Product2 product;
            List<PriceBookEntry> listpbe;
            PriceBookEntry pbe;
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
               // product.Price__c=csvRecordData[26];            
                product.IsActive = TRUE;
                upsert product style_No__c;
                listpbe = [SELECT Id from PriceBookEntry where Product2Id = :product.id and Pricebook2Id=:pbk.Id];
                if(listpbe != null && listpbe.size() != 0){
                    pbe = listpbe[0];
                    pbe.UnitPrice = decimal.valueOf(csvRecordData[26].trim());
                    upsert pbe;
                }else{
                    pbe = new PriceBookEntry();
                    
                    pbe.Pricebook2Id = pbk.Id;
                    pbe.Product2Id = product.id;
                    pbe.UnitPrice = decimal.valueOf(csvRecordData[26].trim());
                    insert pbe;
                }                
                productList.add(product);  
                prodCodes.add(csvRecordData[1]);
            }
        }
        catch (Exception e)
        {
            System.debug('Exception ' + e.getMessage() + e.getCause()+ e.getStackTraceString());
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR,'Error while importing CSV data.Please ensure input csv file is correct.'+e);
            ApexPages.addMessage(errorMessage);
        }  
    }
}