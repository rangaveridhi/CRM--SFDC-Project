public class TempTriggerController {
    
    public TempTriggerController() {    }

    public void doRFMAnalysis() {
        System.debug('In Temp C');
        Set<Id> ids = (new Map<Id, Contact>([SELECT Id FROM Contact])).keySet();
        HelperRFMAnalysis.updateRFMAnalysis(ids);
    	System.debug('Called Helper');
        
    }

}