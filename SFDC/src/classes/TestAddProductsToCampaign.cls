@isTest(seeAllData=true)
public class TestAddProductsToCampaign {
    public static testMethod void TestAddProductToCampaignUnitTest () {
        Test.startTest();
        PageReference pageRef = Page.Add_Products_To_Campaign;
        Test.setCurrentPage(pageRef);
        Product2 prod = new Product2(name='ProductTest',Style_no__c='testProd-001',IsActive=TRUE);       
        insert prod;
        Product2 prod2 = new Product2(name='ProductTest2',Style_no__c='testProd-002',IsActive=TRUE);       
        insert prod2;
        
        List<PricebookEntry> listPBE= new list<PricebookEntry>();
        PricebookEntry pbe = new PricebookEntry();
        pbe.Pricebook2Id=[Select id from priceBook2 where isStandard=true].id;
        //pbe.Pricebook2Id=pricebook2;
    	pbe.Product2Id=prod.Id;
        pbe.IsActive=true;
        pbe.UnitPrice=10000;
        insert pbe;
        
        Campaign camp = new Campaign();
        camp.Name='Test Campaign';
        insert camp;
        
        System.currentPageReference().getParameters().put('campaignName',camp.Name);
        test.stopTest();
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(prod);
        AddProductToCompaignController apc = new AddProductToCompaignController(stdController);
        apc.styleNo='abc';
        apc.productName='test prod';
        AddProductToCompaignController.cProduct cpTest = new AddProductToCompaignController.cProduct(prod);
        cpTest.selected= true;
       // cpTest.open=true;
     //   cpTest.selectedOpp='Bought';
        
        apc.runSearch();
      List<AddProductToCompaignController.cProduct> cprod =  apc.getAllProducts();
        apc.productList.add(cpTest);
       // cprod.get(0).selected=true;
        
        
        apc.addProduct();
        
        
        
    }

}