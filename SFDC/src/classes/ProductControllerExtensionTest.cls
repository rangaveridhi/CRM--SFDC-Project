@isTest

public class ProductControllerExtensionTest{

  static testMethod void testproductcontroller(){
  //Product2 prod = new Product2();
  Product2 prod = new Product2(Name = 'Laptop X200', Family = 'Hardware',Style_No__c='10');
  insert prod;
  
  ApexPages.StandardController sc = new ApexPages.standardController(prod);
 // stdcontroller =acc;
  ProductControllerExtension accEx=new ProductControllerExtension(sc);
  accEx.getImgUrl();
  }
}