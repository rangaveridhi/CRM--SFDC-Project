@isTest()
public class TestHelperOppCampaignUpdate {
    public static testMethod void testHelperOppCampaignUpdateMethod(){
        Test.startTest();
        
        //Creat test Account
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
        
        
        
        
        //Campaign data  creation
        Campaign camp = new Campaign();
        camp.Name='Test Campaign';
        insert camp;
        
        
        
        //Interaction data
        Interaction__c interact = new Interaction__c();
        interact.Action_point__c='Test Data';
        interact.Action_Point_date__c=Date.today();
        interact.Contact__c=listContact.get(0).id;
        interact.Campaign__c=camp.id;
        insert interact;
        Interaction__c interact1 = new Interaction__c();
        interact1.Action_point__c='Test Data';
        interact1.Action_Point_date__c=Date.today();
        interact1.Contact__c=listContact.get(0).id;
        //interact1.Campaign__c=camp.id;
        insert interact1;
        //Opportunity data
        Opportunity opp = new Opportunity();
        opp.Name='test opp';
        opp.StageName='Seen';
        opp.CloseDate=date.today();
        opp.Interaction__c=interact.id;
        insert opp;
        Opportunity opp1 = new Opportunity();
        opp1.Name='test opp1';
        opp1.StageName='Seen';
        opp1.CloseDate=date.today();
        opp1.Interaction__c=interact1.id;
        insert opp1;
        Test.stopTest();
        
        
        HelperOppCampaignUpdate.updateCampaign(opp);
         HelperOppCampaignUpdate.updateCampaign(opp1);
        
    }
}