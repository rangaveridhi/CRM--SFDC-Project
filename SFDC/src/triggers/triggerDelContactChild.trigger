/**
* Trigger to Delete All the Related Relations, Accompaniments and Opportunities.

**/

trigger triggerDelContactChild on Contact (before delete) {

 List<Opportunity> oppList=  new List<Opportunity>();
 List<RFMAnalysis__C> rfmList=  new List<RFMAnalysis__C>();
 List<Accompaniment__c> accmList=  new List<Accompaniment__c>();
 List<Relation__c> relList=  new List<Relation__c>();
 List<Interaction__C> inteList=  new List<Interaction__C>();
 Set<Id> contactIds = Trigger.oldMap.keySet();
 rfmList=[SELECT ID,NAME FROM RFMANALYSIS__c WHERE Contact__c IN : contactIds];
 oppList = [SELECT ID,NAME FROM OPPORTUNITY WHERE Contact__c IN : contactIds];
 relList=[SELECT ID,NAME FROM Relation__c WHERE Parent_Contact__c IN : contactIds OR Related_Contact__C IN : contactIds];
 inteList = [SELECT ID,NAME FROM Interaction__C WHERE Contact__c IN : contactIds];
 Set<Id> relIds= new Set<Id>();
   if(relList!=null && relList.size()>0){
          for(Relation__C rel: relList){
          relIds.add(rel.Id);
          }
   }
 accmList=[SELECT ID,NAME FROM Accompaniment__c WHERE Relation__C IN : relIds];
 if(accmList!=null && accmList.size()>0){
 delete accmList;
 }
 /*if(inteList!=null && inteList.size()>0){
 delete inteList;
 }*/
 if(relList!=null && relList.size()>0){
 delete relList;
 }
 if(oppList!=null && oppList.size()>0){
 delete oppList;
 }
 
 if(rfmList!=null && rfmList.size()>0){
 delete rfmList;
 }
}