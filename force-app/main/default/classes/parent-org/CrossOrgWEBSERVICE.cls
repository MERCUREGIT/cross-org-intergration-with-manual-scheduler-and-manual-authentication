/**
 * @author ngum buka fon nyuydze
 * @since 06/02/2023
 */

@RestResource(urlMapping='/sync-records/v1/*')
global without sharing class CrossOrgWEBSERVICE {
    @HttpGet
    global static list<lead> getRecords() {
        list<lead> recordsToSync= new list<lead>();
        try {
            set<lead> recentlyCreatedOrUpdatedLead;
            Datetime todayDateAndTime = Datetime.newInstance(system.now().year(), system.now().month(), system.now().day(), 15, 0, 0);
            Datetime yesterdayDateAndTime = Datetime.newInstance(todayDateAndTime.date().addDays(-1),todayDateAndTime.time());
            recentlyCreatedOrUpdatedLead = new Set<Lead>([SELECT Id, Name,Company,Email,LeadSource,LastName FROM Lead WHERE  (CreatedDate>=:yesterdayDateAndTime and CreatedDate <= :todayDateAndTime)]);
            recentlyCreatedOrUpdatedLead.addAll([SELECT  Id, Name,Company,Email,LeadSource, LastName FROM Lead WHERE (LastModifiedDate>=:yesterdayDateAndTime and LastModifiedDate <= :todayDateAndTime)]);
            recordsToSync = new list<lead>(recentlyCreatedOrUpdatedLead);
        } catch (Exception e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
        return recordsToSync;
    }
}