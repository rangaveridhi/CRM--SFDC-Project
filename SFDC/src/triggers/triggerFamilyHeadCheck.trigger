trigger triggerFamilyHeadCheck on Account (before insert,after update) {

   for(Account acc:Trigger.new){
     
      if(acc.contact__C!=null){
      CONTACT conAccount = [SELECT ID,NAME,Account.Name FROM CONTACT WHERE Id=: acc.Contact__C];
      System.debug('Contact name and Account name---and Comparision acnt Name--'+acc.Contact__C+'----'+conAccount.Account.Name+'--'+acc.Name);
      if(conAccount.Account.Name!=acc.Name){
      acc.addError('Please select Relevant Family Head');
      }
      }
   }

}