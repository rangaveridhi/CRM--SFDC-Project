/**
 * Scheduler to schedule calculating the RFM score of all customers. --- 
 * @author Samir
 * @date  10/15/2014(mm/dd/yy)
 * @version 1.0
 */

global class RFMAnalysisScheduler implements Schedulable{
    global void execute(SchedulableContext ctx) {
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
                          FROM CronTrigger WHERE Id = :ctx.getTriggerId()];
        System.debug(ct.CronExpression);
        System.debug(ct.TimesTriggered);
//        List<Contact> listContacts = [SELECT Id from Contact];
//        Set<id> contactIds = (new Map<Id,SObject>(listContacts)).keySet();
//        HelperRFMAnalysis.updateRFMAnalysis(contactIds);

        // Call the scheduled batch process for RFM processing.        
		BatchRFMProcessor rfmBatch = new BatchRFMProcessor();        
        Database.executeBatch(rfmBatch, 25);  
    }
}