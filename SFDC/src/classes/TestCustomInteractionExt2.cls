@isTest
public class TestCustomInteractionExt2 {
    
    private static testmethod void TestCustomInteractionExt2(){
        Test.startTest();
        PageReference pg= Page.customInteractionPage;
        
        Test.setCurrentPage(pg);
        
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
        // interaction Creation
        
        List<interaction__c> interactList = new List<interaction__c>();
        //for(integer i=0;i<3;i++){
        Interaction__c interact =new Interaction__c();
        interact.Action_point__c='Test Action';
        interact.Action_Point_date__c=Date.today();
        interact.contact__c= listContact.get(0).id;
        interact.account__c=newAccount.id;
        interact.Medium_of_Interaction__c='sms';
         interactList.add(interact);   
        
        Interaction__c interact1 =new Interaction__c();
        interact1.Action_point__c='Test Action';
        interact1.Action_Point_date__c=Date.today();
        interact1.contact__c= listContact.get(0).id;
        interact1.account__c=newAccount.id;
        interact1.Medium_of_Interaction__c='Bumped Into';
         interactList.add(interact1);  
        
        Interaction__c interact2 =new Interaction__c();
        interact2.Action_point__c='Test Action';
        interact2.Action_Point_date__c=Date.today();
        interact2.contact__c= listContact.get(0).id;
        interact2.account__c=newAccount.id;
        interact2.Medium_of_Interaction__c='email';
         interactList.add(interact2);  
        
        Interaction__c interact3 =new Interaction__c();
        interact3.Action_point__c='Test Action';
        interact3.Action_Point_date__c=Date.today();
        interact3.contact__c= listContact.get(0).id;
        interact3.account__c=newAccount.id;
        interact3.Medium_of_Interaction__c='Phone call';
         interactList.add(interact3); 
        
        Interaction__c interact4 =new Interaction__c();
        interact4.Action_point__c='Test Action';
        interact4.Action_Point_date__c=Date.today();
        interact4.contact__c= listContact.get(0).id;
        interact4.account__c=newAccount.id;
        interact4.Medium_of_Interaction__c='';
         interactList.add(interact4);  
        
        Interaction__c interact5 =new Interaction__c();
        interact5.Action_point__c='Test Action';
        interact5.Action_Point_date__c=Date.today();
        interact5.contact__c= listContact.get(0).id;
        interact5.account__c=newAccount.id;
        interact5.Medium_of_Interaction__c='Out of Store appointment';
         interactList.add(interact5);  
       // }
       insert interactList;
        
        //interact.Medium_of_Interaction__c='email';
        
        
        
        
        test.stopTest();
        for(Interaction__c interacting : interactList) {
        ApexPages.StandardController sc = new ApexPages.standardController(interacting);
        customInteractionExtension2 cust = new customInteractionExtension2(sc);
      
            
        
            cust.medium=interacting.Medium_of_Interaction__c;
        
       PageReference pr1 = cust.cancel();  
        cust.doToggle();
       cust.getAccountName();
        cust.getMediumOfInteraction();
        cust.saveInteraction();
        cust.cancel();
        } 
    }
}