@istest
public without sharing class MockHTTPCallOutLeadRecordsFromParentOrg implements HttpCalloutMock {
    public HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
       if(req.getEndpoint().contains('https://login.salesforce.com/services/oauth2/token')){

        }else {
           System.assertEquals('https://resourceful-koala-6six07-dev-ed.trailblaze.my.salesforce.com/services/apexrest/child/sync-records/v1/', req.getEndpoint());
           System.assertEquals('POST', req.getMethod());
           res.setHeader('Content-Type', 'application/json');
           res.setBody('child ran with success');
           res.setStatusCode(200);
        }
        return res;
    }
}