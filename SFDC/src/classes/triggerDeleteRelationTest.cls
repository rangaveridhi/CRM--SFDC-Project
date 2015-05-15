@istest
public class triggerDeleteRelationTest{
    static testmethod void unittest(){
Test.startTest();
Account acc= new Account();
        acc.Name='Test Account';
        insert acc;
        contact c=new contact();
        c.lastname='greg';
        c.AccountId=acc.Id;
        insert c;
        Relation__c rel= new Relation__c();
        rel.Parent_Contact__c=c.Id;
        rel.Related_Contact__c=c.Id;
        rel.Relation_Type__c='son';
     
        insert rel;
   
      Interaction__C inte = new Interaction__C();
  
      inte.Contact__c=c.Id;
      inte.Action_point__c='Other';
      inte.Action_Point_date__c=Date.today();
      insert inte;
        
      
  
   Accompaniment__c accment = new Accompaniment__c();
  // accment.Name='test tracker';
   accment.Role_Of_Accompaniment__c='Silent';
   accment.Interaction__c=inte.Id;
   accment.Relation__C=rel.Id;
   insert accment;
   delete rel;
   
   Test.stopTest();
           
        }
    
}