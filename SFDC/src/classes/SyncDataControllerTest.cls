@isTest(seeAllData=true)

/*

Author: Ranga  
Date : 8th May 2015


*/
public class SyncDataControllerTest{
    static testmethod void syncdatatest(){
        //PricebookEntry pbe = new PricebookEntry();
        Pricebook2 prb2=[Select id from Pricebook2 where name='Standard Price Book' limit 1];
        System.debug('PB Id---'+prb2.Id);
     
    test.startTest();
      
        PricebookEntry pbe = new PricebookEntry();
        PageReference pageRef1 = Page.syncDataPage;
        Test.setCurrentPage(pageRef1);
        
        PageReference pageRef2 = Page.syncDataPage2;
        Test.setCurrentPage(pageRef2);
        
        //Creat test Account
        Account newAccount = new Account (name='Test Account');
        insert newAccount;
        //create first contact
        List<Contact> listcontact= new List<Contact>();
        
        // Creating a test Contact
        Contact myContact = new Contact (FirstName='Test', LastName='profile',AccountId=newAccount.id);
        listcontact.add(myContact);
        insert listcontact;
        
        // Create Test Products
        Product2 prod = new Product2(name='ProductTest',Style_no__c='testProd-001',IsActive=TRUE);       
        insert prod;
        Product2 prod2 = new Product2(name='ProductTest2',Style_no__c='testProd-002',IsActive=TRUE);       
        insert prod2;
   
        List<PricebookEntry> listPBE= new list<PricebookEntry>();
        
        pbe.pricebook2id=prb2.Id;
        //pbe.Pricebook2Id=testpbId;
        pbe.Product2Id=prod.Id;
        pbe.IsActive=true;
        pbe.UnitPrice=10000;
        insert pbe;
       
       
        RemoteSessionData__c rsd1 = new RemoteSessionData__c(SessionID__c='s0001',Product_Style_No__c='testProd-001', Customer_Name__c='Test Customer', Interaction_Name__c='Test Customers  interaction', 
                                                             Opp_Reason_for_acceptance_rejection__c='design', Medium_of_Interaction__c='Email', 
                                                             Opportunity_Stage__c='Shortlisted', Product_Status__c='Liked', Ipad_Username__c='eynmjfs@gmail.com', Sales_User_s_Name__c='eynmj',
                                                             Action_point__c='other', Action_point_Date__c='25/05/2015', Availability__c=true,Start_Date_Time__c='2015-04-23T16:45:00+05:30',End_Date_Time__c='2015-04-23T16:45:00+05:30');
        insert rsd1;
         RemoteSessionData__c rsd2 = new RemoteSessionData__c(SessionID__c='s0001',Product_Style_No__c='testProd-001', Customer_Name__c='Test Customer', Interaction_Name__c='Test Customers  interaction', 
                                                             Opp_Reason_for_acceptance_rejection__c='design', Medium_of_Interaction__c='Email', 
                                                             Opportunity_Stage__c='Shortlisted', Product_Status__c='Liked', Ipad_Username__c='eynmjfs@gmail.com', Sales_User_s_Name__c='eynmj',
                                                             Action_point__c='other', Action_point_Date__c='25/05/2015', Availability__c=false,Start_Date_Time__c='2015-04-23T16:45:00+05:30',End_Date_Time__c='2015-04-23T16:45:00+05:30');
        insert rsd2;
           RemoteSessionData__c rsd3 = new RemoteSessionData__c(SessionID__c='s0001',Product_Style_No__c='testProd-001', Customer_Name__c='Test Customer', Interaction_Name__c='Test Customers  interaction', 
                                                             Opp_Reason_for_acceptance_rejection__c='design', Medium_of_Interaction__c='Email', 
                                                             Opportunity_Stage__c='Shortlisted', Product_Status__c='Liked', Ipad_Username__c='eynmjfs@gmail.com', Sales_User_s_Name__c='eynmj',
                                                             Action_point__c='other', Action_point_Date__c='25/05/2015', Availability__c=false,Start_Date_Time__c='2015-04-23T16:45:00+05:30',End_Date_Time__c='2015-04-23T16:45:00+05:30');
        insert rsd3; 
        ApexPages.currentPage().getParameters().put('val2', 'Test Customer');
        ApexPages.currentPage().getParameters().put('val1', 's0001');    
      
        SyncDataController syncData = new SyncDataController();
        syncdata.contact.Profile_Name__c=mycontact.Id;
         syncdata.aInteract.Action_Point__c='Others';
        syncdata.aInteract.Action_Point_date__c= Date.parse('30/4/2015');
        syncdata.aInteract.Associated_Store__c='Others';
        User userdata= [select id from user limit 1];
        syncdata.aInteract.Staff_1__c=userdata.Id;
        syncdata.isDeleted=true;  
        syncData.syncDataPage2();  
        
       // System.assertEquals(syncdata.productList.size(),1);
        System.debug('product list in the cproduct-----------'+syncdata.productList);
        
        System.debug('SyncDataController Data-------------------------------------'+syncdata.aInteract.Action_Point__c);
         System.debug('product list in the cproduct before-----------'+syncdata.selectedproducts);
        syncdata.productList.get(0).selected=true;
        System.debug('product list in the cproduct after-----------'+syncdata.selectedproducts);
       // syncdata.selectedproducts.add(syncdata.productlist.get(0));
       //  System.debug('product list in the cproduct after-----------'+selectedproducts);
        syncData.addProduct();
        PageReference pr1 = syncData.enableCreateOpp();
        PageReference pr2 = syncData.cancel();
        PageReference pr3 = syncData.deleteSession();
        PageReference pr4 = syncData.closePopup();
        PageReference pr5 = syncData.okay();
       
        syncData.showPopup();
        
        test.stoptest();
        
   
   

    }


}