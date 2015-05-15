public class ProductControllerExtension {

public String imageUrl;// {get; set;}
public Product2 prod{get;set;}
Product2 prodObj{get;set;}
public ProductControllerExtension(ApexPages.StandardController stdController){
this.prod= (Product2)stdController.getRecord();
System.debug('product name--------------'+prod.id);
prodObj = [SELECT ID,NAME,Material__c FROM PRODUCT2 WHERE ID=:PROD.ID limit 1];
}

public String getImgUrl(){
ContentVersion[] cvs = [select id from contentversion where title=:prodObj.Material__C and isLatest=true];
if(cvs.size() !=0)
return '/sfc/servlet.shepherd/version/download/'+ cvs.get(0).id;
else
return null;
}
//imageUrl = '/sfc/servlet.shepherd/version/download/06990000000AewyAAC';
//return imageUrl;

}