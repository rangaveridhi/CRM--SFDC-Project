@istest
public class triggerDeletecontactchildTest{
    static testmethod void unittest(){
        Account acc= new Account();
        acc.Name='Test Account';
        insert acc;
        contact c=new contact();
        c.lastname='greg';
        c.AccountId=acc.Id;
        insert c;
        Interaction__c inte=new Interaction__C();
        
        inte.Contact__c=c.Id;
  inte.Action_point__c='test';
  inte.Action_Point_date__c=Date.today();
  insert inte;
        Relation__c rel= new Relation__c();
        rel.Parent_Contact__c=c.Id;
        rel.Related_Contact__c=c.Id;
        rel.Relation_Type__c='son';
        
        
      Opportunity opp= new Opportunity();
   opp.Name= 'test opp';
   opp.StageName= 'shortlisted';
   opp.CloseDate = System.today().addDays(7);
  // opp.AccountId = accountId;
   opp.Interaction__c = inte.id;
  
  
   opp.contact__c= c.id;
   //opp.Availability_Status__c = prod.open;
   Test.startTest();
   
   insert rel;
   insert opp;
             delete c;
             Test.stopTest();
           
        }
    
}