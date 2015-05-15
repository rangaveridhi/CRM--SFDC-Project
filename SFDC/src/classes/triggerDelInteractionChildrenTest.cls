@istest
public class triggerDelInteractionChildrenTest{
    static testmethod void unittest(){
   test.starttest();
   Interaction__C inte = new Interaction__C();
   //Interaction__C inte1 = new Interaction__C();
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
        
        
   Opportunity opp= new Opportunity();
   opp.Name= 'test opp';
   opp.StageName= 'shortlisted';
   opp.CloseDate = System.today().addDays(7);
  // opp.AccountId = accountId;
   opp.Interaction__c = inte.Id;
  
  
   opp.contact__c= con.id;
   //opp.Availability_Status__c = prod.open;
  
   
   
   insert opp;
   Accompaniment__c accment = new Accompaniment__c();
  // accment.Name='test tracker';
   accment.Role_Of_Accompaniment__c='Silent';
   accment.Interaction__c=inte.Id;
   insert accment;
   
   delete inte;
             Test.stopTest();
           
        }
    
}