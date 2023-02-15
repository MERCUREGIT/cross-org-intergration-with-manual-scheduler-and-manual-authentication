@isTest
public with sharing class BatchTest {
    @testSetup
    static void setup() {
        List<Lead> leads = new List<Lead>();
        for (Integer i=0;i<10;i++) {
            leads.add(new Lead(lastname='Test '+i, Company='Company '+i, Email='test'+i+'@test.com'));
        }
        insert leads;
    }
    @isTest static void test() {
        Test.setMock(HttpCalloutMock.class, new MockHTTPCallOutLeadRecordsFromParentOrg());
        Test.startTest();
            CrossOrgBatch crossBatch = new CrossOrgBatch(system.now());
            Id batchId = Database.executeBatch(crossBatch);
        Test.stopTest();
    }
}