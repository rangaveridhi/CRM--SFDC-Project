global class ScheduleTaskReminderAndManagerEscalation implements Schedulable {

    global void execute(SchedulableContext sc)
               {
                
                sendActivityEmailReminderToUser();
                sendActivityescalationToManager();
               // sendActionPointRemindertoUser();
                //sendActionPointescalationToManager();
                
               }
    global void createTask(Id owner){
      try{
       System.debug('Create Task------------');
       Task newTask = new Task();
       newTask.Subject='Activity Reminder - No Action Taken';      
       newTask.Status='Not Started';  
       newTask.Priority='Normal';
       newTask.IsReminderSet =true;
       newTask.ReminderDateTime=System.Now();
       newTask.Description='Activity Reminder - No Action Taken'; 
       //newTask.whatId=opid;
       //newTask.whoId=UserInfo.getUserId();
       newTask.OwnerId = owner;
       insert newTask;
        System.debug('Suceefully Task Created ------------');
      }
      catch(Exception e)
             {
              System.debug(e.getMessage());
             } 
    }
    
    
          global void sendActivityEmailReminderToUser()
            {
             try{
             List<Task> openTask= new List<Task>();
             Date d= Date.today();
             Date d1=d.addDays(3);
             //System.debug('The Date before Close Date------'+d1);
                 List<Messaging.SingleEmailMessage> listmail = new List<Messaging.SingleEmailMessage>();
                 Set<Name> taskSet = new Set<Name>();
                 openTask=[SELECT Id,Subject,Owner.Name,ActivityDate,Owner.Email,OwnerId FROM Task  WHERE ActivityDate =:d1];
                 for(integer i =0;i<openTask.size(); i++){ 
                       taskSet.add(openTask[i].owner);
                     }
             
                  if(taskSet!=null && taskSet.size()>0){
                        for(Name taskOwner : taskSet) {
                                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                                               
                                                 
                                
                              
                             String[] toAddresses = new String[] {taskOwner.Email}; 
                             //String[] ccAddresses = new String[] {'dude.kinnu@gmail.com'};
                             mail.setToAddresses(toAddresses);
                           //  mail.setCcAddresses(ccAddresses);
                             mail.setReplyTo(taskOwner.Email);  
                             mail.setSenderDisplayName(taskOwner.Name);
                             mail.setSubject('Open Activity nearing Close Date' + taskOwner.name);
                             mail.setBccSender(false);
                             mail.setUseSignature(false);
                                            
                             String tempStr='<html><body>';
                    
            // LIST<String> openOppsMessage =new List<String>();
                                for(Task task:openTask ){
                                                            if(task.ownerId == taskOwner.Id){
                                                            tempStr  = tempStr +'<br>'+' Task Name: '+ task.subject  + '&nbsp;&nbsp;&nbsp;&nbsp; Close Date: '+ Task.ActivityDate + '&nbsp;&nbsp;&nbsp;&nbsp;Task Owner: '+ task.owner.name+'<br>';                                                       
                                                }
                                          }
             tempStr=tempStr+'</body></html>';
             mail.setHTMLBody('Open Activities Crossed the DueDate, Please follow ' + tempStr);              
             
            listmail.add(mail);
            
            System.debug('Email has been sent successfully (reminder mail)!!!!!!!!!!!!!!11');
             
             Messaging.sendEmail(listmail);
                    
                            }           
                   }
                
             }
             catch(Exception e)
             {
              System.debug(e.getMessage());
             }
       
    }
    
    
    // Escalation Mail to Manager when it crosses the Due Date
    
    global void sendActivityescalationToManager(){            
             try{
             List<Task> openTask= new List<Task>();
             Date d= Date.today();
             Date d1=d.addDays(-3);
             //System.debug('The Date before Close Date------'+d1);
             List<Messaging.SingleEmailMessage> listmail = new List<Messaging.SingleEmailMessage>();
              Set<Name> taskSet = new Set<Name>();
             openTask=[SELECT Id,Owner.Email,OwnerId,Owner.Name,Subject,createdDate,ActivityDate FROM Task WHERE ActivityDate =:d1 and IsClosed=false and Completed_Date__c=null ];
             for(integer i =0;i<openTask.size(); i++){ 
                       taskSet.add(openTask[i].owner);
                     }
             
                  if(taskSet!=null && taskSet.size()>0){
                        for(Name taskOwner : taskSet) {
                                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                                                List<User> user=[SELECT MANAGERId,MANAGER.EMAIL FROM USER WHERE ID=:taskOwner.id limit 1];
                                                String managerEmail='';
                                                 if(user!=null && user.size()>0){
                                                 if(user.get(0).MANAGER.EMAIL!=null){
                                                 managerEmail=user.get(0).MANAGER.EMAIL;
                                                         }
                                                 }
                             System.debug('Manager Email Id----------------------'+manageremail);
                             
                              
                             String[] toAddresses = new String[] {manageremail}; 
                             String[] ccAddresses = new String[] {taskOwner.Email};
                             mail.setToAddresses(toAddresses);
                             mail.setCcAddresses(ccAddresses);
                             mail.setReplyTo(taskOwner.Email);  
                             mail.setSenderDisplayName(taskOwner.Name);
                             mail.setSubject('Activity Reminder - No Action Taken-' + taskOwner.name);
                             mail.setBccSender(false);
                             mail.setUseSignature(false);
                                            
                             String tempStr='<html><body>';
                            
                            
                    
            
            
                                for(Task task:openTask ){
                                                            if(task.ownerId == taskOwner.Id){
                                                            tempStr  = tempStr +'<br>'+ ' Task Name: '+ task.subject  + ' &nbsp;&nbsp;Close Date: '+ Task.ActivityDate + '&nbsp;&nbsp;Task Owner: '+ task.owner.name+'\r\n';                                                       
                                                }
                                          }
             tempStr=tempStr+'</body></html>';
             mail.setHTMLBody('Open Activities Crossed the DueDate, Please follow up with the Sales User ' + tempStr);              
             
            listmail.add(mail);
            
            //System.debug('Email has been sent successfully!!!!!!!!!!!!!!11');
             
             
             Messaging.sendEmail(listmail);
             createTask(user.get(0).MANAGERId);
             System.debug('Opp task Email has been sent successfully!!!!!!!!!!!!!!11');
                            
                            }           
                   }
             
             }
             catch(Exception e)  {
              System.debug(e.getMessage());
             }
       
        
    
    }
    
   /* 
    
    // 3-Dec-2014 Change Request to send reminder on Interaction Action point date .....................
    
    
    global void sendActionPointRemindertoUser()
            {
             try{
             System.debug('Action Point Reminder Mail-----------------------------------------------------');
             List<Interaction__C> openInteractions= new List<Interaction__C>();
             Date d= Date.today();
             Date d1=d.addDays(3);
             //System.debug('The Date before Close Date------'+d1);
                 List<Messaging.SingleEmailMessage> listmail = new List<Messaging.SingleEmailMessage>();
                 Set<String> interactionset = new Set<String>();
                 openInteractions=[SELECT Id,Name,createdby.Email,createdby.Id,Action_point_date__c FROM Interaction__C WHERE Action_point_date__C =:d1];
                 for(integer i =0;i<openInteractions.size(); i++){ 
                       interactionset.add(openInteractions[i].createdby.Email);
                     }
             
                  if(interactionset!=null && interactionset.size()>0){
                        for(String emailvalue : interactionset) {
                                System.debug('Email value in Interaction Created By-----------------------'+emailvalue);
                                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                                String[] toAddresses = new String[] {emailvalue}; 
                             //String[] ccAddresses = new String[] {'dude.kinnu@gmail.com'};
                             mail.setToAddresses(toAddresses);
                           //  mail.setCcAddresses(ccAddresses);
                             mail.setReplyTo(emailvalue);  
                             //mail.setSenderDisplayName(taskOwner.Name);
                             mail.setSubject('Open Interaction Action Point nearing Close Date');
                             mail.setBccSender(false);
                             mail.setUseSignature(false);
                                            
                             String tempStr='<html><body>';
                    
            // LIST<String> openOppsMessage =new List<String>();
                                for(Interaction__c interactiondetail:  openInteractions){
                                                            if(interactiondetail.createdby.email== emailvalue){
                                                            tempStr  = tempStr +'<br>'+' Interaction Name: '+ interactiondetail.Name  + '&nbsp;&nbsp;&nbsp;&nbsp; Action Point Date: '+ interactiondetail.Action_Point_Date__c + '&nbsp;&nbsp;&nbsp;&nbsp;'+'<br>';                                                       
                                                }
                                          }
             tempStr=tempStr+'</body></html>';
             mail.setHTMLBody('Open Interaction Action Point Date Nearing Close Date, Please follow up with the customer ' + tempStr);              
             
            listmail.add(mail);
            
            System.debug('Email has been sent successfully (reminder mail)!!!!!!!!!!!!!!11');
             
             Messaging.sendEmail(listmail);
                    
                            }           
                   }
                
             }
             catch(Exception e)
             {
              System.debug(e.getMessage());
             }
       
    }
    
    
    
    // 4-dec-2014 Change Request to Send email reminder to manager if the action point date crosses due date...
    
    
    
    global void sendActionPointescalationToManager(){            
             try{
             List<Interaction__C> openInteractions= new List<Interaction__C>();
             Date d= Date.today();
             Date d1=d.addDays(-3);
             System.debug('Action Point Escalation To Manager-------------------------------------');
             List<Messaging.SingleEmailMessage> listmail = new List<Messaging.SingleEmailMessage>();
              Set<String> interactionSet = new Set<String>();
             openInteractions=[SELECT Id,Name,createdby.Email,createdby.Id,Action_point_date__c FROM Interaction__C WHERE Action_point_date__C =:d1];
             for(integer i =0;i<openInteractions.size(); i++){ 
                       interactionSet.add(openInteractions[i].createdby.Email);
                     }
             
                  if(interactionSet!=null && interactionSet.size()>0){
                        for(String interactionowneremail : interactionSet) {
                                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                                                List<User> user=[SELECT MANAGERId,MANAGER.EMAIL FROM USER WHERE Email=:interactionowneremail limit 1];
                                                String managerEmail='';
                                                 if(user!=null && user.size()>0){
                                                 if(user.get(0).MANAGER.EMAIL!=null){
                                                 managerEmail=user.get(0).MANAGER.EMAIL;
                                                         }
                                                 }
                             System.debug('Manager Email Id----------------------'+manageremail);
                             
                              
                             String[] toAddresses = new String[] {manageremail}; 
                             String[] ccAddresses = new String[] {interactionowneremail};
                             mail.setToAddresses(toAddresses);
                             mail.setCcAddresses(ccAddresses);
                           //  mail.setReplyTo(taskOwner.Email);  
                             //mail.setSenderDisplayName(taskOwner.Name);
                             mail.setSubject('Interaction Action Point Escalation - No Action Taken');
                             mail.setBccSender(false);
                             mail.setUseSignature(false);
                                            
                             String tempStr='<html><body>';
                             for(Interaction__c interactiondetail:  openInteractions){
                                if(interactiondetail.createdby.email== interactionowneremail){
                                  tempStr  = tempStr +'<br>'+' Interaction Name: '+ interactiondetail.Name  + '&nbsp;&nbsp;&nbsp;&nbsp; Action Point Date: '+ interactiondetail.Action_Point_Date__c + '&nbsp;&nbsp;&nbsp;&nbsp;'+'<br>';                                                       
                                 }
                             }
             tempStr=tempStr+'</body></html>';
             mail.setHTMLBody('Open Activities Crossed the DueDate, Please follow up with the Sales User ' + tempStr);              
             
            listmail.add(mail);
            
            //System.debug('Email has been sent successfully!!!!!!!!!!!!!!11');
             
             
             Messaging.sendEmail(listmail);
             createTask(user.get(0).MANAGERId);
             System.debug('Opp task Email has been sent successfully to Manager!!!!!!!!!!!!!!11');
                            
                            }           
                   }
             
             }
             catch(Exception e)  {
              System.debug(e.getMessage());
             }
       
        
    
    }
    
    global void createTasktoManager(Id owner){
      try{
       System.debug('Create Task------------');
       Task newTask = new Task();
       newTask.Subject='Activity Reminder - No Action Taken';      
       newTask.Status='Not Started';  
       newTask.Priority='Normal';
       newTask.IsReminderSet =true;
       newTask.ReminderDateTime=System.Now();
       newTask.Description='Activity Reminder - No Action Taken'; 
       //newTask.whatId=opid;
       //newTask.whoId=UserInfo.getUserId();
       newTask.OwnerId = owner;
       insert newTask;
        System.debug('Suceefully Task Created ------------');
      }
      catch(Exception e)
             {
              System.debug(e.getMessage());
             } 
    }
    
    */
    
}