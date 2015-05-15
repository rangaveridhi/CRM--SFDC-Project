global class BatchRFMProcessor implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        return Database.getQueryLocator('SELECT Id from Contact');
        
    }

    global void execute(Database.BatchableContext BC, list<sObject> items){
        Set<id> contactIds = (new Map<Id,SObject>(items)).keySet();
        HelperRFMAnalysis.updateRFMAnalysis(contactIds);
    }
     
    
    global void finish(Database.BatchableContext BC){
        
        
    }
}