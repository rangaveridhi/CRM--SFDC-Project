trigger triggerFamilyHeadUpdate on Contact (before insert,after update) {

 for(Contact con:Trigger.new){
     
      if(con.AccountId!=null){
      Account account = new Account(); 
      account= [SELECT ID,NAME,Contact__C FROM Account WHERE Id=: con.AccountId];
      if(account!=null && account.Contact__C==null){
      account.Contact__C=con.Id;
      update account;
      }
      }
      
 }

}