/**
* Test class to unit test HelperRFMAnalysis. --- 
* @author Samir
* @date  10/20/2014(mm/dd/yy)
* @version 1.0
*/

@isTest(SeeAllData=false) 
public class TestHelperRFMAnalysis {
    public static testMethod void testHelperRFMAnalysis() {
        Test.startTest();
        
        Account newAccount = new Account (name='Test Account');
        insert newAccount;
        //create first contact
        List<Contact> listcontact= new List<Contact>();
        Contact myContact = new Contact (FirstName='Test Profile',
        LastName='Test',
        AccountId=newAccount.id);
        listcontact.add(myContact);
        Contact myContact1 = new Contact (FirstName='Test Profile2',
        LastName='Test2',
        AccountId=newAccount.id);
        listcontact.add(myContact1);
        insert listcontact;
        
        Interaction__c inte= new Interaction__C();
         inte.Contact__c=listcontact.get(0).id;
        inte.Action_point__c='test';
       inte.Action_Point_date__c=Date.today();
      insert inte; 
        
       Interaction__c inte1= new Interaction__C();
       inte1.Contact__c=listcontact.get(1).id;
       inte1.Action_point__c='test';
       inte1.Action_Point_date__c=Date.today();
       insert inte1; 
        
        
        Relation__c rel1= new Relation__c();
        rel1.Parent_Contact__c=listcontact.get(0).id;
        rel1.Related_Contact__c=listcontact.get(1).id;
        rel1.Relation_Type__c='son';
        insert rel1;
            

  
   Accompaniment__c accment = new Accompaniment__c();
   //accment.Name='test tracker';
   accment.Role_Of_Accompaniment__c='Silent';
   accment.Interaction__c=inte.Id;
   accment.Relation__C=rel1.id;
   insert accment; 
    
      
      Product2 prod = new Product2(name='ProductTest',Style_no__c='testProd-001',IsActive=TRUE);       
        insert prod;
        PricebookEntry pbe = new PricebookEntry();
      //pbe.pricebook2id=pb2.Id;
      pbe.Pricebook2Id=Test.getStandardPricebookId();
      pbe.Product2Id=prod.Id;
      pbe.IsActive=true;
      pbe.UnitPrice=100000000;
      insert pbe;     
        List<Opportunity> opplist=new LIST<Opportunity>();
       // for(integer i=1;i<6;i++)
               Opportunity opp = new Opportunity();
        opp.Name='Test Opp';
        opp.StageName='Bought';
        opp.Availability_Status__c=true;
        opp.Interaction__C=inte.Id;
        opp.Contact__c=listcontact.get(0).id;
        opp.CloseDate=Date.today().addDays(-300);                                 
        insert opp;    
       // } 
      //  insert opplist;
       // for(integer j=0;j<opplist.size();j++){
        OpportunityLineItem oli = new OpportunityLineItem();
           oli.UnitPrice=pbe.UnitPrice;//Unless you are pricing differently
           oli.Quantity=1;
           oli.PricebookEntryId=pbe.id;
           oli.OpportunityId = opp.Id;
           insert oli;
        //}    
        List<Opportunity> opplist2=new LIST<Opportunity>();
        for(integer i=1;i<=6;i++){
        Opportunity opp1 = new Opportunity();
        opp1.Name='Test Opp1';
        opp1.StageName='Bought';
        opp1.Availability_Status__c=true;
        opp1.Interaction__C=inte1.Id;
        opp1.Contact__c=listcontact.get(1).id;
        opp1.CloseDate=Date.today().addDays(-160*i);                                 
        opplist2.add(opp1);     
        } 
        insert opplist2;
        for(integer j=0;j<opplist2.size();j++){
        OpportunityLineItem oli1 = new OpportunityLineItem();
           oli1.UnitPrice=pbe.UnitPrice;//Unless you are pricing differently
           oli1.Quantity=1;
           oli1.PricebookEntryId=pbe.id;
           oli1.OpportunityId = opplist2.get(j).Id;
           insert oli1;
        }
 Opportunity opp3 = new Opportunity();
        opp3.Name='Test Opp';
        opp3.StageName='Bought';
        opp3.Availability_Status__c=true;
        opp3.Interaction__C=inte.Id;
        opp3.Contact__c=listcontact.get(0).id;
        opp3.CloseDate=Date.today().addDays(-300);                                 
        insert opp3;     
       // } 
      //  insert opplist;
       // for(integer j=0;j<opplist.size();j++){
        OpportunityLineItem oli3 = new OpportunityLineItem();
           oli3.UnitPrice=pbe.UnitPrice;//Unless you are pricing differently
           oli3.Quantity=1;
           oli3.PricebookEntryId=pbe.id;
           oli3.OpportunityId = opp3.Id;
           insert oli3;
        
        
        
        
        
        
        



        
        Set<id> contactIds = (new Map<Id,SObject>(listContact)).keySet();
        try{
            HelperRFMAnalysis.updateRFMAnalysis(contactIds);
            System.assert(TRUE);
        }catch(Exception e){
            System.assert(FALSE);
        }
    }
}