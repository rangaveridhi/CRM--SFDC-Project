@isTest(seeAllData=true)

public class TestTaskReminder {
    // CRON expression: midnight on March 15.
    // Because this is a test, job executes
    // immediately after Test.stopTest().
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';
    static testmethod void test() {
        Test.startTest();
        // Schedule the test job
        String jobId = System.schedule('ScheduleApexClassTest1',
                                       CRON_EXP,
                                       new ScheduleTaskReminderAndManagerEscalation());
        Account acc = new Account();
        acc.Name= 'Test family';
        insert acc;
        Contact con= new Contact(FirstName='test', LastName='test1');
        con.AccountId=acc.Id;                             
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
      pbe.Pricebook2Id=[select id from Pricebook2 where name='Standard Price Book' limit 1].id;
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
      
        
        
        Task newTask = new Task();
       newTask.Subject='Activity Reminder - No Action Taken';      
       newTask.Status='Not Started';  
       newTask.Priority='Normal';
       newTask.IsReminderSet =true;
       newTask.ReminderDateTime=System.Now();
       newTask.Description='Activity Reminder - No Action Taken'; 
        newTask.ActivityDate=Date.today().addDays(3);
       //newTask.whatId=opid;
       //newTask.whoId=UserInfo.getUserId();
       newTask.OwnerId = [select id,name from user where name='Abdul Khan' limit 1].id;
       insert newTask;        
        
        
        Task newTask2 = new Task();
       newTask2.Subject='Activity Reminder - No Action Taken';      
       newTask2.Status='Not Started';  
       newTask2.Priority='Normal';
       newTask2.IsReminderSet =true;
       newTask2.ReminderDateTime=System.Now();
       newTask2.Description='Activity Reminder - No Action Taken'; 
        newTask2.ActivityDate=Date.today().addDays(-3);
       //newTask.whatId=opid;
       //newTask.whoId=UserInfo.getUserId();
       newTask2.OwnerId = [select id,name from user where name='Abdul Khan' limit 1].id;
       insert newTask2;   
        
        
        
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