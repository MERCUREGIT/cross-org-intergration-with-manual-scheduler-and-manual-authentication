public without sharing class RecordSyncScheduler implements Schedulable {
    public void execute(SchedulableContext SC) {
        Apex_Parent_To_Child_Last_Import_Time__mdt lastBatchRunTime = Apex_Parent_To_Child_Last_Import_Time__mdt.getInstance('last_org_run');
        Database.executeBatch(new CrossOrgBatch(lastBatchRunTime.last_run__c));
     }
}