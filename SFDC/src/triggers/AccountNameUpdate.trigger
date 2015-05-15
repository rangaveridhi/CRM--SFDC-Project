trigger AccountNameUpdate on Interaction__c (after insert) {

   if(Trigger.isInsert){
   
  //  List<Interaction__c> ct = new List <Interaction__c>();
  List<Contact> con= [Select Id,accountId from Contact];
  List<Interaction__c> inteList=new List<Interaction__c>();
  Set<Interaction__c> inteSetList=new Set<Interaction__c>();
   for(Interaction__c interaction : trigger.new){
  
     if(con!=null && con.size()>0){
     for(Contact conList:con){
      if(conList.Id==interaction.Contact__c){
  // con = [ Select accountId from Contact where Id =: interaction.Contact__c ];
      Interaction__c inte = new Interaction__c();
      inte.Account__c = conList.AccountId;
      inte.Id = interaction.Id;
      inteSetList.add(inte);
      }
    }
    }
    
   }
   inteList.addAll(inteSetList);
   update inteList;
   
  
}
}