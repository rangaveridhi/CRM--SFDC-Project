@isTest

private class cProductWRClassTest{

  private static testMethod void testcProduct(){
  
  Product2 prod = new Product2(Name = 'Laptop X200', Family = 'Hardware',Style_No__c='10');
        insert prod;
 //ApexPages.StandardController sc = new ApexPages.standardController(prod);

  cProduct cp=new cProduct(prod);
      cProduct cp1=new cProduct(prod,'lost','liked','disliked',true);
  }
}