/**
 * Scheduler to schedule the Product and Price Information Upload 
 * @author Ranga
 * @date  5/12/14
 */

global class FiletoUploaderScheduler implements Schedulable{
    
    global void execute(SchedulableContext sc)
               {
              
               FileToRecordUploader fileuploader= new FileToRecordUploader();
               fileuploader.importCSVFile();
               }
}