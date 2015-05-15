@isTest

public class accountOppsExtensionTest{

  static testMethod void testoppCreation(){
  Account acc = new Account();
  ApexPages.StandardController stdController;
  acc.Name='Test Account1';
  insert acc;
   ApexPages.StandardController sc = new ApexPages.standardController(acc);
 // stdcontroller =acc;
  accountOppsExtension accEx=new accountOppsExtension(sc);
  }
}