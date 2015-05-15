@isTest (seeAllData=true)
public class TestSyncDataController {

 //@TestVisible public List<cProduct> productList {get; set;}
    public static testMethod void TestSyncDataControllerMethod () {
        test.startTest();
        
        PageReference pageRef1 = Page.syncDataPage;
        Test.setCurrentPage(pageRef1);
        
        PageReference pageRef2 = Page.syncDataPage2;
        Test.setCurrentPage(pageRef2);
        
        //Creat test Account
        Account newAccount = new Account (name='Test Account');
        insert newAccount;
        //create first contact
        List<Contact> listcontact= new List<Contact>();
        Contact myContact = new Contact (FirstName='Test',
                                         LastName='profile',
                                         AccountId=newAccount.id);
        listcontact.add(myContact);
        Contact myContact1 = new Contact (FirstName='Test Profile2',
                                          LastName='Test2',
                                          AccountId=newAccount.id);
        listcontact.add(myContact1);
        insert listcontact;
        
        Profile testProfile = [SELECT Id 
                               FROM profile
                               WHERE Name = 'System Administrator' 
                               LIMIT 1];
        
        
        User testUser = new User(LastName = 'test user 1', 
                             Username = 'test.user.1@example.com', 
                             Email = 'test.1@example.com',
                             Alias = 'testu1', 
                             TimeZoneSidKey = 'GMT', 
                             LocaleSidKey = 'en_GB', 
                             EmailEncodingKey = 'ISO-8859-1', 
                             ProfileId = testProfile.Id, 
                             LanguageLocaleKey = 'en_US');
        insert testUser;
        system.runAs(testUser){
            
        }
        
        
        Product2 prod = new Product2(name='ProductTest',Style_no__c='testProd-001',IsActive=TRUE);       
        insert prod;
        Product2 prod2 = new Product2(name='ProductTest2',Style_no__c='testProd-002',IsActive=TRUE);       
        insert prod2;
        
           // Add the above product into pricebook and make it 
        List<PricebookEntry> listPBE= new list<PricebookEntry>();
        PricebookEntry pbe = new PricebookEntry();
        //pbe.pricebook2id=pb2.Id;
        Pricebook2 prb2=[Select id from Pricebook2 where name='Standard Price Book'];
        pbe.Pricebook2Id=prb2.id;
        pbe.Product2Id=prod.Id;
        pbe.IsActive=true;
        pbe.UnitPrice=10000;
        insert pbe;
        
        
        RemoteSessionData__c rsd1 = new RemoteSessionData__c(SessionID__c='s0001',Product_Style_No__c='testProd-001', Customer_Name__c='Test Customer', Interaction_Name__c='Test Customers  interaction', 
                                                             Opp_Reason_for_acceptance_rejection__c='design', Medium_of_Interaction__c='Email', 
                                                             Opportunity_Stage__c='Shortlisted', Product_Status__c='Liked', Ipad_Username__c='eynmjfs@gmail.com', Sales_User_s_Name__c='eynmj',
                                                             Action_point__c='other', Action_point_Date__c='25/05/2015', Availability__c=true,Start_Date_Time__c='2015-04-23T16:45:00+05:30',End_Date_Time__c='2015-04-23T16:45:00+05:30');
        insert rsd1;
        RemoteSessionData__c rsd2 = new RemoteSessionData__c(SessionID__c='s0001',Product_Style_No__c='testProd-002', Customer_Name__c='Test Customer', Interaction_Name__c='Test Customers  interaction', 
                                                             Opp_Reason_for_acceptance_rejection__c='design', Medium_of_Interaction__c='Email', 
                                                             Opportunity_Stage__c='Shortlisted', Product_Status__c='Disliked', Ipad_Username__c='eynmjfs@gmail.com', Sales_User_s_Name__c='eynmj',
                                                             Action_point__c='other', Action_point_Date__c='25/05/2015', Availability__c=false,Start_Date_Time__c='2015-04-23T16:45:00+05:30',End_Date_Time__c='2015-04-23T16:45:00+05:30');
        
        insert rsd2;      
        
              
        ApexPages.currentPage().getParameters().put('val2', 'Test Customer');
        ApexPages.currentPage().getParameters().put('val1', 's0001');
        
        // Change Set 20 issue code on 8thMay 2015 starts here   @Ranga----------------
         
        
        syncDataController sdc = new syncDataController();
        sdc.contact.Profile_Name__c= myContact.id;
       /*
        cProduct cpTest = new cProduct(prod,'Seen','Liked','Design',true);
        cpTest.selected= true;
        sdc.productList.add(cpTest);
       
       // sdc.productList.get(0).selected=true; 
        */
         cProduct cpTest = new cProduct(prod);
        cpTest.selected= true;
        cpTest.open=true;
        cpTest.selectedOpp='Seen';
        cpTest.selectedProd='Liked';
        cpTest.selectedReason='Design';
        cpTest.selectedQuantity=1;
       
         List<cProduct> selectedProducts = new List<cProduct>(); 
         selectedProducts.add(cpTest);
      //sdc.productList.add(cpTest);
        
        //Change Set 20 issue code ends here----------------------------
       
        
        sdc.contact.Profile_Name__c= myContact.id;
        sdc.aInteract.Action_Point__c='Others';
        sdc.aInteract.Action_Point_date__c= Date.parse('30/4/2015');
        sdc.isDeleted=true;       
         sdc.syncDataPage2();
        sdc.addProduct();
      
        PageReference pr1 = sdc.enableCreateOpp();
        PageReference pr2 = sdc.cancel();
        PageReference pr3 = sdc.deleteSession();
        PageReference pr4 = sdc.closePopup();
        PageReference pr5 = sdc.okay();
       
        sdc.showPopup();
       
        
       
       
       test.stopTest();
    }
    
    
    
    // Commented Code-----------------------------------------------
    
     /* cProduct cpTest = new cProduct(prod);
        cpTest.selected= true;
        cpTest.open=true;
        cpTest.selectedOpp='Bought';
        sdc.productList.add(cpTest);*/
        
        //sdc.productList.add(cpTest);
       
       
       /* Pricebook2 pb2 = new Pricebook2();
        pb2.Name='Test Data PriceBook';
        pb2.IsActive=true;
        //pb2.IsStandard=true;
        pb2.Description='Test Data PriceBook';
        insert pb2; */
    
         /* sdc.addProduct();
        
        cProduct cpTest = new cProduct(prod,'Seen','Liked','Design',true);
        cpTest.selected= true;
        
       
       sdc.productList.add(cpTest);
        sdc.productList.add(cpTest);  */
         //   sdc.productList.get(0).selected=true;
       // sdc.productList.get(1).selected=true; 
        
    
}