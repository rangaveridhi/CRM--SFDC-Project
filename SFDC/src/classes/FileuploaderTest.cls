@isTest(seeAlldata=true)
                                
private class FileuploaderTest {

    static testmethod void test() {
        //       Test.startTest();
       BatchFileToProductUploader c = new BatchFileToProductUploader();
        Product2 prod = new Product2(name='ProductTest',Style_no__c='testProd-001',IsActive=TRUE);       
        insert prod;
        PriceBook2 pbk = [Select Id from PriceBook2 where name = 'Standard Price Book'];
      
        c.updatePrice(prod, pbk.Id);
         Database.executeBatch(c);
      // Test.stopTest();

    }
}