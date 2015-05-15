@TestVisible Public class cProduct{
   
     public Product2 prod2 {get; set;}
     public Boolean selected {get; set;}   //Selected checkbox
     public String selectedOpp{get;set;}  // Opportunity stage
     public String selectedProd{get;set;} // product liked or disliked
     public String selectedReason{get;set;}  //reason for acceptance of rejection
     public Boolean open{get;set;}        //availability
     public integer SelectedQuantity{get;set;}
   
   public cProduct(Product2 c) {
            prod2 = c;
            selected = false;
            selectedOpp = '';
            selectedProd='';
            selectedReason='';
            selectedQuantity=1;
            open = false;
            }
   @TestVisible
  public cProduct(Product2 c, string cSelectedOpp, string cSelectedProd, string cSelectedReason, boolean cOpen) {
            prod2 = c;
            selected = false;
            selectedOpp = cSelectedOpp;
            selectedProd=cSelectedProd;
            selectedReason=cSelectedReason;
            selectedQuantity=1;
            open = cOpen;
            }
    
    
    
       }