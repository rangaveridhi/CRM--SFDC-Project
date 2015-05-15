/**
* Trigger to dleete all Cild Objecfts from Interacdtion.
**/

trigger triggerDelInteractionChildren on Interaction__c (before delete) {

 List<Opportunity> oppList=  new List<Opportunity>();
 
 List<Accompaniment__c> accmList=  new List<Accompaniment__c>();
 List<OpportunityStageTracker__c> oppSTRList = new List<OpportunityStageTracker__c>();
 
 Set<Id> interactionIds = Trigger.oldMap.keySet();
 oppList = [SELECT ID,NAME FROM OPPORTUNITY WHERE Interaction__c IN : interactionIds ];
  /*
  Set<Id> OppIds= new Set<Id>();
   if(oppList!=null && oppList.size()>0){
          for(Opportunity opp: oppList){
          OppIds.add(opp.Id);
          }
      oppSTRList = [SELECT ID,NAME FROM OPPORTUNITYSTAGETRACKER__c WHERE Opportunity2__c IN : OppIds];   
    }

  if(oppSTRList!=null && oppSTRList.size()>0){
  //delete oppSTRList;
  }
  */
 accmList=[SELECT ID,NAME FROM Accompaniment__c WHERE Interaction__c IN : interactionIds ];
 
 if(oppList!=null && oppList.size()>0){
 delete oppList;
 }
 if(accmList!=null && accmList.size()>0){
 delete accmList;
 }
}