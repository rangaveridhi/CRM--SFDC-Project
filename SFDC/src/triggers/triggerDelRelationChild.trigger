trigger triggerDelRelationChild on Relation__c (before delete) {

 List<Accompaniment__c> accmList=  new List<Accompaniment__c>();
 System.debug('TRIIGER FOR Relation  to Delete Accompaniments---------------------------------------------');
 Set<Id> relIds= Trigger.oldMap.keySet();
 
 accmList=[SELECT ID,NAME FROM Accompaniment__c WHERE Relation__c IN : relIds];
 if(accmList!=null && accmList.size()>0){
 delete accmList;
 }
}