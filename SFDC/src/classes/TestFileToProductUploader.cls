@isTest(seeAllData=true)
public class TestFileToProductUploader {

    static testmethod void test() {
        //       Test.startTest();
       FileToProductUploader c = new FileToProductUploader();
       c.importCSVFile();
      // Test.stopTest();

    }
}