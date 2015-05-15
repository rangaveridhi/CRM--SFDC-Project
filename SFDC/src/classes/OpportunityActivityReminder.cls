global class OpportunityActivityReminder Implements Schedulable
{
             global void execute(SchedulableContext sc)
               {
                sendOppRemindermail();
                }
            global void sendOppRemindermail()
            {
             try{
             List<Opportunity> openOpps= new List<Opportunity>();
             List<Messaging.SingleEmailMessage> listmail = new List<Messaging.SingleEmailMessage>();
             Date d= Date.today();
             Date d1=d.addDays(3);
            
            Set<User> oppSet = new Set<User>();
              
             openOpps=[SELECT Id,Name,OwnerId,Contact__c,Owner.Email,Owner.name,interaction__r.name,stageName,closeDate FROM Opportunity WHERE StageName NOT IN ('Bought','Lost') AND Availability_Status__c = True and CloseDate=:d1];
             for(integer i =0;i<openOpps.size(); i++){
                       oppSet.add(openOpps[i].owner);
                    
             }
              
                             
            System.debug('OppSet to contain distinct values'+oppSet);
                 if(oppSet!=null && oppSet.size()>0){
                        for(User oppOwner : oppSet) {
                             Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                             String[] toAddresses = new String[] {oppOwner.Email}; 
                            // String[] ccAddresses = new String[] {'dude.kinnu@gmail.com'};
                             mail.setToAddresses(toAddresses);
                           //  mail.setCcAddresses(ccAddresses);
                             mail.setReplyTo(oppOwner.Email);   
                             mail.setSenderDisplayName(oppOwner.Name);
                             mail.setSubject('Open Opportunities Reminder');
                             mail.setBccSender(false);
                             mail.setUseSignature(false);
                                            
                             String tempStr='<html><body>';
                            
             LIST<String> openOppsMessage =new List<String>();
                                for(Opportunity opp:openOpps ){
                                                     if(opp.owner == oppOwner){
                                                     tempStr  = tempStr + '<br>'+ 'Interaction Name:'+ opp.Interaction__r.name + '&nbsp;&nbsp;&nbsp;&nbsp; Opportunity Name:'+opp.Name + '&nbsp;&nbsp;&nbsp;&nbsp; Stage: '+ opp.StageName + ' &nbsp;&nbsp;&nbsp;&nbsp;Close Date: '+opp.CloseDate+'<br>';                                                      
                                                  }
                                       }
             tempStr=tempStr+'</body></html>';
             mail.setHTMLBody('You have Open Opportunities , please follow up with the Customer, These are the Open opportunities:' + tempStr);              
             
            listmail.add(mail);
            
            //System.debug('Email has been sent successfully!!!!!!!!!!!!!!11');
             
             
             Messaging.sendEmail(listmail);
             System.debug('Opp Reminder Email has been sent successfully!!!!!!!!!!!!!!11');
             
          }
       }
             }      
             catch(Exception e)
             {
              System.debug(e.getMessage());
             }
           
    }

    
    
}