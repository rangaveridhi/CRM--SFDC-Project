/**
 * Scheduler to . --- 
 * @author Ranga
 * @date 1/8/2015(mm/dd/yy)
 * @version 1.0
 */

global class FileUploadBatchScheduler implements Schedulable{
    global void execute(SchedulableContext ctx) {
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
                          FROM CronTrigger WHERE Id = :ctx.getTriggerId()];
        System.debug(ct.CronExpression);
        System.debug(ct.TimesTriggered);
  
    BatchFileToProductUploader fileuploadbatch = new BatchFileToProductUploader();        
        Database.executeBatch(fileuploadbatch, 75);  
    }
}