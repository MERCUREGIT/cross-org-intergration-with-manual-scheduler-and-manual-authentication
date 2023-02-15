/**
 * @author ngum buka fon nyuydze
 * @since 07/02/2023
 */

public without sharing class Helper {
    public static string authenticate(){
        Http httpService = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://login.salesforce.com/services/oauth2/token');
        req.setHeader('Content-Type','application/x-www-form-urlencoded');
        req.setMethod('POST');

        string userName = 'ngumbuka@resourceful-koala-6six07.com';
        string password = 'ngum@salesforce1' +'Z6URbx3WTUOxZSD93Vad0yG7L';
        string consumerKey = '3MVG9ux34Ig8G5ep4oU691FOquYqI_behXnAvDg9lmRoNV_oA_tsCUhuXtbRd8_xoCBe.ByXSR5aRfS3_hHmT';
        string consumerSecrete = 'BB47CAADFED6E189449D0A4CC691AF18D494795C76779D4E79F295C1B054709C';
        string redirect_ui = 'https://login.salesforce.com/services/oauth2/success';
        string grant_type = 'password';
        String body = 'grant_type='+grant_type+'&client_id='+consumerKey+'&client_secret='+consumerSecrete+'&username='+userName+'&password='+password+'&'+redirect_ui;
        req.setBody(body);
        HttpResponse res = httpService.send(req);
        System.debug(res.getBody());
        Map<String,object> responseMap =(Map<String,object>)JSON.deserializeUntyped(res.getBody()) ;  
        System.debug(responseMap);
        String token =  String.valueOf(responseMap.get('access_token'));
        return token;
    }
}