@isTest

public class InteractionExtensionTest{

  static testMethod void testinteraction(){
  Interaction__C inte = new Interaction__C();
   Interaction__C inte1 = new Interaction__C();
   Account acc= new Account();
        acc.Name='Test Account';
        insert acc;
  Contact con = new Contact(FirstName='TestClass',LastName='Test',AccountId=acc.Id);
  insert con;
  ApexPages.StandardController stdController;
  inte.Contact__c=con.Id;
  inte.Action_point__c='test';
  inte.Action_Point_date__c=Date.today();
  insert inte;
  
  
  ApexPages.StandardController sc = new ApexPages.standardController(inte);
 // stdcontroller =acc;
  InteractionExtension accEx=new InteractionExtension(sc);
 /* 
  inte1.Contact__c=con.Id;
  inte1.Action_point__c='test';
  inte1.Action_Point_date__c=Date.today();
  inte1.Availability_Status__c= false;
  insert inte1;
  
  
  ApexPages.StandardController sc1 = new ApexPages.standardController(inte1);
 // stdcontroller =acc;
  InteractionExtension accEx1=new InteractionExtension(sc1);*/
  }
}