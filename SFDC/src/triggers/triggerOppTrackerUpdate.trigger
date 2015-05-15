/**
 * OpportunityStageTracker --- Trigger to upate all possible previous Stages in an Opportunity for keeping
 * the required logical flow of stages consistent to generate a Stage Funnel for Products assocaited to opportunities.
 * @author Samir
 * @date  09/06/2014(mm/dd/yy)
 * @version 1.0
 */

trigger triggerOppTrackerUpdate on Opportunity (after insert,before insert,before update,before delete){
    
    if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)){ //Update the CloseDate of Opportunity to Tdoay's Date if it is either Bought/Lost.
        for(Opportunity opportunity : Trigger.new){
            if(opportunity.StageName == 'Bought' ||opportunity.StageName == 'Lost')
               opportunity.CloseDate = Date.today(); 
        }  
    }
    
    if((Trigger.isAfter && Trigger.isInsert) || (Trigger.isBefore && Trigger.isUpdate)){
    Set<Id> oppIdSet= Trigger.newMap.keySet();
      //  for(Opportunity opportunity : Trigger.new){
            HelperOSTTrigger.updateOST(oppIdSet);//(opportunity.Id);
       // }    
    }
        
    if(Trigger.isBefore && Trigger.isDelete){
        Set<Id> oppIds = Trigger.oldMap.keySet();
        List<OpportunityStageTracker__c> listOpp = [SELECT Id FROM OpportunityStageTracker__c where Opportunity2__c IN :oppIds];
        delete listOpp;
    }   
       
}