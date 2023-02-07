/**
 * @author ngum buka fon nyuydze
 * @since 07/02/2023
 */

public without sharing class Helper {
    public static string generateUpcommingCronExpression(Integer additionalDays){
        
        String day = string.valueOf(system.now().day()+ additionalDays);
        String month = string.valueOf(system.now().month());
        String year = string.valueOf(system.now().year());
        String hour = '15', minute ='0', second = '0';
        return second + ' ' + minute + ' ' + hour + ' ' + day + ' ' + month + ' ?' + ' ' + year;
    }


    public static string authenticate(){
        Http httpService = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://login.salesforce.com/services/oauth2/token');
        req.setHeader('Content-Type','application/x-www-form-urlencoded');
        req.setMethod('POST');

        string userName = 'ngumbuka@wise-koala-bhzgyy.com';
        string password = 'ngum@salesforce1';
        string consumerKey = '3MVG9ux34Ig8G5eo_FLzLrHLdmrkzzxGz8ARe8FSGHkvUW3KWo8Qm7vdZ9XagB5h0whgsWkt.vFVKxW68spZq';
        string consumerSecrete = 'C5F0CA01B006D51CFEA7D0BF2504904EED5DB8EEA49974F3F458880E49CE5A1B';
        string redirect_ui = 'https://login.salesforce.com/services/oauth2/success';
        string grant_type = 'password';
        String body = 'grant_type='+grant_type+'&client_id='+consumerKey+'&client_secret='+consumerSecrete+'&username='+userName+'&password='+password+'&'+redirect_ui;

        req.setBody(body);
        HttpResponse res = httpService.send(req);
        Map<String,object> responseMap =(Map<String,object>)JSON.deserializeUntyped(res.getBody()) ;  
        String token =  String.valueOf(responseMap.get('access_token'));
        return token;
    }
}