/**
* Test class to unit test HelperRFMAnalysis. --- 
* @author Samir
* @date  10/20/2014(mm/dd/yy)
* @version 1.0
*/

@isTest //(SeeAllData=true) 
public class TestHelperOSTTrigger {
    public static testMethod void testHelperOSTTrigger() {
        Test.startTest();
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
       Product2 prod = new Product2(name='ProductTest',Style_no__c='testProd-001',IsActive=TRUE);       
        insert prod;
         PricebookEntry pbe = new PricebookEntry();
       // Pricebook2 prb2=
        pbe.Pricebook2Id=Test.getStandardPriceBookId();
        pbe.Product2Id=prod.Id;
        pbe.IsActive=true;
        pbe.UnitPrice=10000;
        insert pbe;
        
    List<Opportunity> oppList= new List<Opportunity>();         
   //for(integer i=0;i<26;i++){
   Opportunity opp= new Opportunity();
   opp.Name= 'test opp';
   opp.StageName= 'Bought';
   opp.CloseDate = System.today().addDays(7);
   opp.Interaction__c = inte.id;
   opp.contact__c= c.id;
   opp.Availability_Status__c=true;
   insert opp;
   OpportunityLineItem oli = new OpportunityLineItem();
           oli.UnitPrice=pbe.UnitPrice;//Unless you are pricing differently
           oli.Quantity=1;
           oli.PricebookEntryId=pbe.id;
           oli.OpportunityId = opp.Id;
           insert oli;
  
  Opportunity opp1= new Opportunity();
   opp1.Name= 'test opp';
   opp1.StageName= 'Shortlisted';
   opp1.CloseDate = System.today().addDays(7);
   opp1.Interaction__c = inte.id;
   opp1.contact__c= c.id;
   opp1.Availability_Status__c=true;
   insert opp1;
   OpportunityLineItem oli1 = new OpportunityLineItem();
           oli1.UnitPrice=pbe.UnitPrice;//Unless you are pricing differently
           oli1.Quantity=1;
           oli1.PricebookEntryId=pbe.id;
           oli1.OpportunityId = opp1.Id;
           insert oli1;
  
  Opportunity opp2= new Opportunity();
   opp2.Name= 'test opp';
   opp2.StageName= 'Tried';
   opp2.CloseDate = System.today().addDays(7);
   opp2.Interaction__c = inte.id;
   opp2.contact__c= c.id;
   opp2.Availability_Status__c=true;
   insert opp2;
   OpportunityLineItem oli2 = new OpportunityLineItem();
           oli2.UnitPrice=pbe.UnitPrice;//Unless you are pricing differently
           oli2.Quantity=1;
           oli2.PricebookEntryId=pbe.id;
           oli2.OpportunityId = opp2.Id;
           insert oli2;
  
  Opportunity opp3= new Opportunity();
   opp3.Name= 'test opp';
   opp3.StageName= 'Seen';
   opp3.CloseDate = System.today().addDays(7);
   opp3.Interaction__c = inte.id;
   opp3.contact__c= c.id;
   opp3.Availability_Status__c=true;
   insert opp3;
   OpportunityLineItem oli3 = new OpportunityLineItem();
           oli3.UnitPrice=pbe.UnitPrice;//Unless you are pricing differently
           oli3.Quantity=1;
           oli3.PricebookEntryId=pbe.id;
           oli3.OpportunityId = opp3.Id;
           insert oli3;
  
  
  
        List<Opportunity> listOpps = [SELECT Id from Opportunity LIMIT 25];
         Set<id> oppIds = (new Map<Id,SObject>(listOpps)).keySet();
        try{
            HelperOSTTrigger.updateOST(oppIds);
            System.assert(TRUE);
        }catch(Exception e){
            System.assert(FALSE);
        }
    }
}