global class SyncToSalesforceWebservice {
global static HttpResponse basicAuthCallout(){
     HttpRequest req = new HttpRequest();
     req.setEndpoint('https://ap1.salesforce.com');
     req.setMethod('GET');
     
     // Specify the required user name and password to access the endpoint
     // As well as the header and header information
 
     String username = 'rangaveridhi@gmail.com';
     String password = 'Rangakiran@312';
  
     Blob headerValue = Blob.valueOf(username + ':' + password);
     String authorizationHeader = 'BASIC ' +
     EncodingUtil.base64Encode(headerValue);
     req.setHeader('Authorization', authorizationHeader);
   
     // Create a new http object to send the request object
     // A response object is generated as a result of the request  
  
     Http http = new Http();
     HTTPResponse res = http.send(req);
     System.debug(res.getBody());
     return res;
     
   }
   }