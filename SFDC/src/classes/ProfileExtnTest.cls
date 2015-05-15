@isTest

public class ProfileExtnTest{

   private static testmethod void profileextntest11(){
   Test.startTest();
   PageReference pg= Page.New_Influence;
   Test.setCurrentPage(pg);
   
   //System.currentPageReference().getParameters().put('accountName','test Acccount Name');
   Account acc= new Account(Name='testacc');
   insert acc;
   List<Contact> conList= new List<Contact>();
   Contact con = new Contact(FirstName='test',LastName='test1',AccountId=acc.Id);
   Contact con1 = new Contact(FirstName='tes1t',LastName='test11',AccountId=acc.Id);
   
   conList.add(con);
   conList.add(con1);
   
   insert conList;
    List<Relation__c> relList= new List<Relation__c>();
    Relation__c rel= new Relation__c();
        rel.Parent_Contact__c=con.Id;
        rel.Related_Contact__c=con.Id;
        rel.Relation_Type__c='son';
        insert rel;
       // relList.add(rel);
     Relation__c rel1= new Relation__c();
        rel1.Parent_Contact__c=con.Id;
        rel1.Related_Contact__c=con.Id;
        rel1.Relation_Type__c='son';
        relList.add(rel1);
       
        insert relList;
   for(integer i=0;i<relList.size();i++){
      Interaction__C inte = new Interaction__C();
      // inte.name='Interaction -01';
      inte.Contact__c=con.Id;
      inte.Action_point__c='test';
      inte.Action_Point_date__c=Date.today();
      insert inte;
        
      
  
   Accompaniment__c accment = new Accompaniment__c();
  // accment.Name='test tracker';
   accment.Role_Of_Accompaniment__c='Silent';
   accment.Interaction__c=inte.Id;
   accment.Relation__C=rel1.id;
   insert accment;
   
   ApexPages.StandardController sc = new ApexPages.standardController(rel);
  
   
   ProfileExtn pfEx=new ProfileExtn(sc);
   pfEx.relation.Related_Contact__C=con1.id;
   pfEx.SelectedRelative=rel.Id;
   pfEx.SelectedRole='Silent';
   
   System.currentPageReference().getParameters().put('contactid',con.Id);
   Interaction__C interactionvalue=[SELECT name FROM Interaction__c WHERE id = :inte.id LIMIT 1];
   System.debug('Interaction name in test class----------------------'+interactionvalue);
   System.currentPageReference().getParameters().put('interactionid',interactionvalue.name);
   List<selectOption> selectlist=pfEx.getrelativesList();
   List<selectOption> roles=pfEx.getRoles();
   pfEx.closePopup();
   pfEx.showPopup();
   PageReference  p=pfEx.save();
   PageReference p1=pfEx.saveRelative();
   pfEx.Cancel();
   
   Test.stopTest();
   }
}
   
   
   
   }