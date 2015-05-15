@isTest

public class TestRelationExtension {
    
    public static testMethod void testMyController() {
        
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
        Relation__c rel = new Relation__c();
        rel.Related_Contact__c=listcontact.get(0).Id;
        rel.Parent_Contact__c=mycontact.Id;
        rel.Relation_Type__c='Son';
        insert rel;
        
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(rel);
        RelationExtension relationExtension = new RelationExtension(stdController);
        relationExtension.Cancel();
        //PageReference p = new PageReference('/apex/CustomRelation'); 
        //Test.setCurrentPage(p);
        //RelationExtension relExt = new RelationExtension();
        PageReference p = relationExtension.save();
        // String nextPage=relationExtension.save().getUrl(); 
        //System.assertEquals('/null',nextPage);
        
        
        /*
        Relation__c rel1 = new Relation__c();
        rel1.Related_Contact__c=listcontact.get(0).Id;
        rel1.Parent_Contact__c=mycontact.Id;
        rel1.Relation_Type__c='Son';
        insert rel1;
        
        
        ApexPages.StandardController stdController1 = new ApexPages.StandardController(rel1);
        RelationExtension relationExtension1 = new RelationExtension(stdController1);
        
        //PageReference p = new PageReference('/apex/CustomRelation'); 
        //Test.setCurrentPage(p);
        //RelationExtension relExt = new RelationExtension();
        PageReference p1 = relationExtension1.save();
        //   String nextPage1=relationExtension1.save().getUrl(); 
        
        */
        
    }
}