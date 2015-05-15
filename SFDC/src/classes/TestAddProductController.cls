@isTest (seeAllData=true)

public class TestAddProductController {
    
    public static testMethod void TestAddProductControllerMethod () {
        Test.startTest();
        PageReference pageRef = Page.Add_Product;
        Test.setCurrentPage(pageRef);
        // create Test Product
        Product2 prod = new Product2(name='ProductTest',Style_no__c='testProd-001',IsActive=TRUE);       
        insert prod;
        Product2 prod2 = new Product2(name='ProductTest2',Style_no__c='testProd-002',IsActive=TRUE);       
        insert prod2;
        
        //D stdPBid =  [SELECT Id FROM Pricebook2 WHERE IsStandard = true limit 1].Id;
        //List<PriceBook2> ListPB = new LIST<Pricebook2>();'01s30000000JNAWAA4';
        
        Pricebook2 pb2 = new Pricebook2();
        pb2.Name='Test Data PriceBook';
        pb2.IsActive=true;
        //pb2.IsStandard=true;
        pb2.Description='Test Data PriceBook';
        insert pb2;
        
        
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
        //listPBE.add(pbe);
        
        /*PricebookEntry pbe2 = new PricebookEntry();
pbe.pricebook2id='01s30000000JNAWAA4';
pbe.Product2Id=prod2.Id;
pbe.IsActive=true;
pbe.UnitPrice=10000;
listPBE.add(pbe2);
insert(listPBE); */
        
        
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
        // interaction Creation
        interaction__c interact = new interaction__c();
        interact.Action_point__c='Test Action';
        interact.Action_Point_date__c=Date.today();
        interact.contact__c= listContact.get(0).id;
        interact.account__c=newAccount.id;
        insert interact;
        
        System.currentPageReference().getParameters().put('interactionid', interact.id);
        System.currentPageReference().getParameters().put('contactid', listcontact.get(0).id);
        
        // System.currentPageReference().getParameters().put('styleNo','hello 123');
        
        
        
        
        Test.StopTest();
        
        // Controller instance one
        ApexPages.StandardController stdController = new ApexPages.StandardController(prod);
        AddProductController apc = new AddProductController(stdController);
        apc.getProductStatus();   
        apc.getOppStage();
        apc.getReasons();
        apc.runQuery();
        apc.styleNo='hello1';
        apc.productName='hello1';
        
        apc.runSearch();
        cProduct cpTest = new cProduct(prod);
        cpTest.selected= true;
        cpTest.open=true;
        cpTest.selectedOpp='Bought';
        apc.productList.add(cpTest);
        apc.productList.add(cpTest);
        
        //  apc.productList.get(0).selected=true;
        //  apc.productList.get(0).open=true;
        
        //  cProduct cptest=    apc.productList.get(0);
        //apc.duplicateProductsName.add('hello');
        // apc.productList.add(cptest);
        
        //apc.getAllProducts();
        
        /* //cprod instantiation
cProduct cp = new cProduct(prod);
cp.prod2= prod;
cp.selected = true;
cp.selectedOpp = '';
cp.selectedProd='';
cp.selectedReason='';
cp.selectedQuantity=1;
cp.open = true; */
        
        
        // List<cProduct> selectedProducts = new List<cProduct>(); 
        // selectedProducts.add(cp);
        
        
        
        PageReference pr = apc.addProduct();
        
        PageReference pr1 = apc.addProductandClose();
        
        
        PageReference pr3 = apc.enableCreateOpp();
        //PageReference pr4 = apc.okay();
       // PageReference pr5 = apc.closepopup();
     //   apc.showPopup();
        PageReference pr2 = apc.cancel();
        
        //Controller second instance
        ApexPages.StandardController stdController1 = new ApexPages.StandardController(prod);
        AddProductController apc1 = new AddProductController(stdController1);
        PageReference pr6 = apc1.addProduct();
        
        PageReference pr7 = apc1.addProductandClose();
        
        
        PageReference pr8 = apc1.enableCreateOpp();
        
 /*
apc2.productList.get(0).selected=true;
apc2.productList.get(0).open=true;

apc2.addProduct();
apc2.addProductandClose(); */
        
        
        
        
        
    }
    
}