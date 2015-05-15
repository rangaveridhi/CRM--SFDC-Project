@isTest
public class RelationExtensionTest{

static testMethod void relationInsertTest(){

//PageReference pageRef = Page.CustomRelation;
//Test.setCurrentPageReference(pageRef);
Test.startTest();
Account newAccount = new Account (name='Test Account');
insert newAccount;
//create first contact
List<Contact> listcontact= new List<Contact>();
Contact myContact = new Contact (FirstName='Test Profile',LastName='Test',AccountId=newAccount.id);
insert mycontact;
Contact myContact1 = new Contact (FirstName='Test Profile2',LastName='Test2',AccountId=newAccount.id);
insert myContact1;
Contact myContact2 = new Contact (FirstName='Test Profile4',LastName='Test4',AccountId=newAccount.id);
insert myContact2;
//insert listcontact;
List<Relation__C> relList = new List<Relation__c>();
Relation__c rel = new Relation__c();
rel.Related_Contact__c=mycontact.Id;
rel.Parent_Contact__c=mycontact.Id;
rel.Relation_Type__c='Son';
relList.add(rel);
Relation__c rel1 = new Relation__c();
rel1.Related_Contact__c=mycontact1.Id;
rel1.Parent_Contact__c=myContact1.Id;
rel1.Relation_Type__c='';
relList.add(rel1);
Relation__c rel2 = new Relation__c();
//relList.add(rel2);
insert relList;
for(integer i=0;i<relList.size();i++){
ApexPages.StandardController stdController = new ApexPages.StandardController(relList.get(i));
        RelationExtension relationExtension = new RelationExtension(stdController);
        
      //  PageReference p = new PageReference('/apex/CustomRelation'); 
        //Test.setCurrentPage(p);
        //RelationExtension relExt = new RelationExtension();
       relationExtension.save(); 
       relationExtension.Cancel();
     //   System.assertEquals('/null',nextPage);
/*

System.assertEquals('Son', rel.Relation_Type__c);

ApexPages.StandardController stdController1 = new ApexPages.StandardController(rel1);
        RelationExtension relationExtension1 = new RelationExtension(stdController1);
        
        //PageReference p1 = new PageReference('/apex/CustomRelation'); 
        //Test.setCurrentPage(p1);
        //RelationExtension relExt = new RelationExtension();
       relationExtension1.save(); 
        //System.assertEquals('/null',nextPage1);
     
        
  */       


}
Relation__C rel5= new Relation__c();
//ApexPages.StandardController stdController = new ApexPages.StandardController(rel5);
  //      RelationExtension relationExtension5 = new RelationExtension(stdController);
    //    relationExtension5.save();
Test.stopTest();
}


}