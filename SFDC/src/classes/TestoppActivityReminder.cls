/**
 * Test class to unit test RFMAnalysisScheduler. --- 
 * @author Samir
 * @date  10/15/2014(mm/dd/yy)
 * @version 1.0
 */

@isTest(seeAllData=true)
public class TestoppActivityReminder {
    // CRON expression: midnight on March 15.
    // Because this is a test, job executes
    // immediately after Test.stopTest().
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';
    static testmethod void test() {
        Test.startTest();
        // Schedule the test job
        String jobId = System.schedule('ScheduleApexClassTest1',
                                       CRON_EXP,
                                       new OpportunityActivityReminder());
                                       Account acc= new Account(name='test accc');
        insert acc;
                                       Contact con= new Contact(FirstName='test', LastName='test1',accountid=acc.id);
                                       insert con;
         Interaction__c inte= new Interaction__C();
         inte.Contact__c=con.Id;
        inte.Action_point__c='test';
       inte.Action_Point_date__c=Date.today();
      insert inte;         
      Product2 prod = new Product2(name='ProductTest',Style_no__c='testProd-001',IsActive=TRUE);       
        insert prod;
        PricebookEntry pbe = new PricebookEntry();
      //pbe.pricebook2id=pb2.Id;
      pbe.Pricebook2Id=[Select id from priceBook2 where name='Standard Price Book'].id;
      pbe.Product2Id=prod.Id;
      pbe.IsActive=true;
      pbe.UnitPrice=10000;
      insert pbe;                     
       
        Opportunity opp = new Opportunity();
        opp.Name='Test Opp';
        opp.StageName='Seen';
        opp.Availability_Status__c=true;
        opp.Interaction__C=inte.Id;
        opp.CloseDate=Date.today().addDays(3);                                 
        insert opp;     
          
        OpportunityLineItem oli = new OpportunityLineItem();
           oli.UnitPrice=pbe.UnitPrice;//Unless you are pricing differently
           oli.Quantity=1;
           oli.PricebookEntryId=pbe.id;
           oli.OpportunityId = opp.Id;
           insert oli;  
        
        
        
        
        
        // Get the information from the CronTrigger API object
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered,NextFireTime
                          FROM CronTrigger WHERE id = :jobId];
        // Verify the expressions are the same
        System.assertEquals(CRON_EXP,
                            ct.CronExpression);
        // Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered);
        Test.stopTest();
    }        
}