/**
 * @author ngum buka fon nyuydze
 * @since 06/02/2023
 */

public without sharing class HttpServiceConnector {
    
    public static void startSyncRecords(string jsonstring){
        
        string userToken = Helper.authenticate();
        HttpServiceConnector.syncRecords(jsonstring, userToken);
    }

    public static HttpResponse syncRecords(string jsonstring,string userToken){
        Http httpService = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json;charset=UTF-8');
        req.setEndpoint('https://resourceful-koala-6six07-dev-ed.trailblaze.my.salesforce.com/services/apexrest/child/sync-records/v1/');
        // req.setEndpoint('callout:parentOrg/services/apexrest/sync-records/v1/');
        req.setHeader('Authorization', 'Bearer '+userToken);
        req.setBody(jsonstring);
        HttpResponse res = httpService.send(req);
        System.debug(res.getBody());
        return res;
    }
}