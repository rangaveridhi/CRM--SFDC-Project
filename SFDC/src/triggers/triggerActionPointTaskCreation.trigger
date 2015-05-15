trigger triggerActionPointTaskCreation on Interaction__c (after insert) {

   if(Trigger.isInsert){
   
  //  List<Interaction__c> ct = new List <Interaction__c>();
   for(Interaction__c interaction : trigger.new){
     
      Contact con = [select name,Potential_Non_Potential__c from contact where Id=:interaction.contact__C];
      if(con!=null && con.Potential_Non_Potential__c!='NP'){
      DateTime dT = interaction.createddate;
     // Date actionpointdate=interaction.Action_Point_Date__C;
     // Date reminderDate= actionpointdate.addDays(3);
      Date myDate = date.newinstance(dT.year(), dT.month(), dT.day());
      Task newTask = new Task();
       
       System.debug('Interaction Contact Name---------------------------'+interaction.Contact__c);
       newTask.Subject=con.Name + '('+ myDate + ')';      
       newTask.Status='In Progress';  
       newTask.Priority='Normal';
       newTask.IsReminderSet =true;
       newTask.ReminderDateTime=interaction.Action_Point_Date__C.addDays(-3);
       newTask.ActivityDate=interaction.Action_Point_Date__C;
       newTask.Description='Activity Reminder - No Action Taken'; 
       newTask.whatId=interaction.Id;
       //newTask.whoId=UserInfo.getUserId();
       newTask.OwnerId = interaction.createdbyId;
       insert newTask;
    }
   }
      
  
}
}