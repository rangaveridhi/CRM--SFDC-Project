public class ProfileExtn {
    
    public String relVal{get;public set;}
    public Boolean relpanel{ get; set; }
    
    public String roleVal{get;public set;}
    public String interactionVal {get;public set;}
    public Accompaniment__c influence{get;set;}
    public String SelectedRelative{get;set;}
    public String SelectedRole{get;set;}
    public String relatedContact{get;set;}
    public String relationType{get;set;}
    public String parentContact{get;set;}
    public String conversation{get;set;}
    
    
    public String interactionId{get;set;}
    ApexPages.StandardController stdController;
    public String AccountId;
    public String inteValue;
    private final Contact acct;
    public Relation__c relation{get;set;}
    List<Accompaniment__c> influenceList = new List<Accompaniment__c>(); 
    public ProfileExtn(ApexPages.StandardController stdController) {
        //this.acct = (Contact)stdController.getRecord();
        this.relation = (Relation__c)stdController.getRecord();
        if(System.currentPagereference().getParameters().get('contactid')!=null){
            relation.Parent_Contact__c = System.currentPagereference().getParameters().get('contactid');
        }
        //relpanel=false;
        //  this.relController = stdController;
    }
    
    
    // This method is to get the Relatives List based on the Selected Profile
    
    public List<selectOption> getrelativesList()
    {
        
        try{
            
            AccountId= System.currentPagereference().getParameters().get('contactid');
            List<selectOption> relativeoptions = new List<selectOption>(); 
            relativeoptions.add(new selectOption('', '- None -')); 
            
            for (Relation__c relatives : [SELECT ID,NAME,Related_Contact__r.Contact_Full_Name__c FROM Relation__c WHERE Parent_Contact__c = : AccountId])
            { 
                relativeoptions.add(new selectOption(relatives.Id,relatives.Related_Contact__r.Contact_Full_Name__c)); 
                
            }
            
            return relativeoptions; 
        }
        catch(Exception e){
            ApexPages.addMessages(e);
            return null;
        }
        //return null;
        
    }
    
    
    // This method is to get the Picklist values from the Roles Picklist
    
    public List<selectOption> getRoles(){
        
        try{
            List<SelectOption> roles= new List<SelectOption>();
            Schema.DescribeFieldResult fieldResult =Accompaniment__c.Role_Of_Accompaniment__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            
            roles.add(new selectOption('', '- None -'));
            for( Schema.PicklistEntry f : ple)
            {
                
                roles.add(new SelectOption(f.getLabel(), f.getValue()));
            } 
            return roles;
        }
        catch(Exception e){
            ApexPages.addMessages(e);
            return null;
        }
        //return null;
        
    }
    
    public boolean displayPopup {get; set;} 
    
    
    public PageReference closePopup()
    { 
        displayPopup = false; 
        return null;
        
    } 
    public void showPopup()
    { 
        
        displayPopup = true; 
    } 
    
    
    public PageReference Save()
    {
        try { 
            String interactionValue =System.currentPagereference().getParameters().get('interactionId');
            System.debug('interaction value in main class-------------------------------'+interactionValue);
            inteValue= [SELECT Id FROM Interaction__c WHERE Name = :interactionValue LIMIT 1].Id;
            influenceList = [select Id FROM Accompaniment__c WHERE Interaction__c=:inteValue AND Relation__c=:SelectedRelative];
            System.debug('Selected Relative value---------------------------'+SelectedRelative);
            String relType='';
            if(influenceList.size()==0){
                if(SelectedRelative!=null && SelectedRole!=null){
                    List<Relation__c> relationList= [SELECT Relation_Type__c FROM RELATION__c WHERE id=:SelectedRelative];
                    if(relationList!=null && relationList.size()>0){
                        relType=relationList.get(0).Relation_Type__c ;
                    }
                    Accompaniment__c inf = new Accompaniment__c();
                    inf.Interaction__c=inteValue;
                    inf.Relation__c= SelectedRelative; 
                    inf.Role_Of_Accompaniment__c= SelectedRole; 
                    inf.Relation_Type__c=relType;
                    inf.Conversation__c= conversation;
                    insert inf;
                    PageReference pr = new PageReference('/' +inteValue ); 
                    pr.setRedirect(true); 
                    return pr; 
                }
                else{
                    Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.Warning,'Please Select Accompaniment with Role');
                    Apexpages.addmessage(msg);
                    
                    return null;
                }
            }
            else{
                Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.Info,'Influence has already been created for the selected Relative');
                Apexpages.addmessage(msg);
                
                return null; 
            }
            
            return null;
            
            
            
        }
        catch(System.DMLException e) {
            ApexPages.addMessages(e);
            return null;
            try { 
                insert influence;
                return null;
            }
            catch(System.DMLException e1) {
                ApexPages.addMessages(e1);
                return null;
            }
        }
        
    } 
    
    // This method is to insert the New Relation with the chosen profile
    
    public PageReference saveRelative(){
        
        
        //To avoid duplicate relation entry, check if an existing Contact has been a relationship for the same parent Contact.        
        List<Relation__c> listRelation = [SELECT Id from Relation__c where Related_Contact__c = :relation.Related_Contact__c and Parent_Contact__c = :relation.Parent_Contact__c];
        
        if (listRelation.size() == 0){
            try{
                Relation__c rel = new Relation__c();
                rel.Related_Contact__c = relation.Related_Contact__c;
                rel.Parent_Contact__c = relation.Parent_Contact__c;
                rel.Relation_Type__c =relation.Relation_Type__c;
                if(relation.Related_Contact__c!=null && relation.Parent_Contact__c!=null && relation.Relation_Type__c !=null){
                    insert rel;
                    displayPopup = false;
                    PageReference newpage = new PageReference(System.currentPageReference().getURL());
                    newpage.setRedirect(true);
                    return newpage;
                    
                }
                else{
                    ApexPages.Message myMsg = new  ApexPages.Message(ApexPages.Severity.ERROR,'Please Enter Related Contact,Parent Contact and Type' );
                    ApexPages.addMessage(myMsg);
                    return null;
                }
                
                
            }catch(Exception e){
                ApexPages.Message myMsg = new  ApexPages.Message(ApexPages.Severity.ERROR,'Unable to create the Relation.    '+e.getMessage() );
                ApexPages.addMessage(myMsg);
                displayPopup = false;
                return null;
            }
        }
        else{
            ApexPages.Message myMsg = new  ApexPages.Message(ApexPages.Severity.ERROR,'A Relation with the same Profile already exists.');
            ApexPages.addMessage(myMsg);
            //  displayPopup = false;
            return null;
        }
        
        
        //closePopup();
        
        
    }
    
    public PageReference Cancel(){
        
        PageReference pr = new PageReference('/' +[SELECT Id FROM Interaction__c WHERE Name = :System.currentPagereference().getParameters().get('interactionId')LIMIT 1].Id); 
        pr.setRedirect(true); 
        return pr;
        
    }
    
    
}