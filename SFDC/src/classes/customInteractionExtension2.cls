public class customInteractionExtension2{
private interaction__c interaction;
private ApexPages.StandardController stdController ;
public Boolean toggle {get;set;}
public Boolean email{get;set;}
public Boolean sms{get;set;}
public Boolean phonecall{get;set;}
public Boolean commonFields{get;set;}
public Boolean outofstore{get;set;}
public String medium {get;set;}
public String accName{get;set;}
public String conName{get;set;}
public customInteractionExtension2(ApexPages.StandardController stdController) {
        this.interaction= (interaction__c)stdController.getRecord();
        this.stdController = stdController;
        toggle = false;
       // for(interaction__c i : [select contact__r.name from interaction__c where contact__c=:interaction.contact__c limit 1]) {      conName= i.contact__r.name;    }
    }
public void doToggle(){
        
        if(medium==''){
            this.commonFields=toggle;
            this.outofstore=toggle;
            this.email=toggle;
            this.phoneCall=toggle;
            }
            
            
            else if(medium=='sms'){
                this.commonFields=toggle;
                this.outofstore=toggle;
                this.email=toggle;
                this.phoneCall=toggle;
            }
        else if(medium=='email'){
        this.email=!toggle;
        this.commonFields=toggle;
        this.outofstore=toggle;
        this.phonecall=toggle;
         }
        else if(medium=='Bumped Into'|| medium=='Store interaction' || medium=='Marketing communication' || medium=='Meeting instore event' || medium=='Meeting at external event'){
        
                this.commonFields=!toggle;
                this.outofstore=toggle;
                this.sms=toggle;
                this.email=toggle;
                this.phonecall=toggle;
                }
        else if(medium=='Phone call'){
         this.phonecall = !toggle;
         this.email =toggle;
         this.commonFields=toggle;
         this.outofstore=toggle;
        }
        else if(medium=='Out of Store appointment'){
               this.commonFields=toggle;
               this.outofstore=!toggle;
                this.sms=toggle;
                this.email=toggle;
                this.phonecall=toggle;
        }
    }
    
    
   // interaction__c interactAccName = new interaction__c();
   // interactAccName = [select contact__r.account.name from interaction__c  limit 1];
   // accountAccName = interactAccName.contact_account.name;



    public String getAccountName(){
          
        for(interaction__c i : [select contact__r.account.name from interaction__c where contact__c=:interaction.contact__c limit 1])
        {
        accName= i.contact__r.account.name;
        }
    return accName;
  }    
  
  
  
  

 public List<SelectOption> getMediumOfInteraction(){
       List<SelectOption> mediumList= new List<SelectOption>();
       
         Schema.DescribeFieldResult fieldResult =interaction__c.Medium_of_Interaction__c.getDescribe();
         List<Schema.PicklistEntry> mle = fieldResult.getPicklistValues();
        
           mediumList.add(new selectOption('', '--None--'));
           for( Schema.PicklistEntry f : mle)
           {
              
              mediumList.add(new SelectOption(f.getLabel(), f.getValue()));
           }       
           return mediumList;   
  }  

public PageReference saveInteraction(){

          try{
                interaction.Medium_of_Interaction__c = medium;
                   
                  
                  
                //  interaction.Name= conName+'\'s Interaction ' + interaction.Interaction_Counter__c;
                  
                  PageReference pr= stdController.save();
                  stdController.save();
                return pr;
          
           } catch(Exception e){
                ApexPages.Message myMsg = new  ApexPages.Message(ApexPages.Severity.ERROR,'Unable to create interaction.    '+e.getMessage() );
                ApexPages.addMessage(myMsg);
                return null;
           }

    }
public PageReference cancel(){
            PageReference pr =  stdController.cancel();
            return pr;
          

    }



}