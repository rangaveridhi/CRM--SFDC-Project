public class datePicker {

public String datename {get; set;}
public interaction__c  interact {get; set;}
public datePicker(){
        
        interact = new interaction__c();
        
    }

public void save(){

interact.action_point__c ='hello';
system.debug('interact: '+interact);
//insert interact.Action_Point_date__c;
 insert interact;


 
 }
}