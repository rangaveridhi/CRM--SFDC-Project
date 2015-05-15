@istest
public class TesttriggerCampaignMemberCreation {

    public static testMethod void unitest(){
    
    Account newAccount = new Account (name='Test Account');
        insert newAccount;
    Campaign c=new Campaign();
    c.Name='Test Campaign';
    insert c;
        //create first contact
        List<Contact> listcontact= new List<Contact>();
        Contact myContact = new Contact (FirstName='Test Profile',
        LastName='Test',
        AccountId=newAccount.id,Campaign__c=c.Id);
        listcontact.add(myContact);
        Contact myContact1 = new Contact (FirstName='Test Profile2',
        LastName='Test2',
        AccountId=newAccount.id,Campaign__c=c.Id);
        listcontact.add(myContact1);
        insert listcontact;
        
    }
    
}