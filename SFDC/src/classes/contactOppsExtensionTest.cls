@isTest

public class contactOppsExtensionTest{

  static testMethod void testoppCreation(){
  Account acc= new Account();
        acc.Name='Test Account';
        insert acc;
  Contact con = new Contact(FirstName='TestClass',LastName='Test',AccountId=acc.Id);
  ApexPages.StandardController stdController;
 // con.Name='Test ContactIn';
  
  insert con;
   ApexPages.StandardController sc = new ApexPages.standardController(con);
 // stdcontroller =acc;
  contactOppsExtension conEx=new contactOppsExtension(sc);
  }
}