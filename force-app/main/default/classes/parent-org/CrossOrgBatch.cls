global without sharing class CrossOrgBatch implements Database.Batchable<Lead>,Database.AllowsCallouts,Database.Stateful {
    public Datetime lastUpdateEndTime;

    public CrossOrgBatch(Datetime l){
        this.lastUpdateEndTime = l;
    }
    public  Iterable<Lead> start(Database.BatchableContext bc) {
        return this.getLeadRecordsToBeSynchedOnChild();
    }

    public void execute(Database.BatchableContext BC, list<Lead> leadList){
        try {
            HttpServiceConnector.startSyncRecords(JSON.serialize(leadList));
        } catch (Exception e) {
            System.debug(e.getMessage());
        }
    }

    public void finish(Database.BatchableContext BC){
        if (!Test.isRunningTest()) {            
            Metadata.Operations.enqueueDeployment(MetaDataManager.performAsyncUpdate(System.now()), null);
        }
        this.sendEmailToUser(BC);
    }

    public void sendEmailToUser(Database.BatchableContext BC){
        AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id = :BC.getJobId()];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {a.CreatedBy.Email,'ngumbukafon@gmail.com'};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Apex Sharing Recalculation ' + a.Status);
        mail.setPlainTextBody
        ((System.now())+'The batch Apex job processed ' + a.TotalJobItems +
        ' batches with '+ a.NumberOfErrors + ' failures.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    } 

    public list<lead> getLeadRecordsToBeSynchedOnChild(){
        list<lead> recordsToSync= new list<lead>();
        set<lead> recentlyCreatedOrUpdatedLead;
            Datetime yesterdayDateAndTime = this.lastUpdateEndTime;
            recentlyCreatedOrUpdatedLead = new Set<Lead>([SELECT Id, Name,Company,Email,LeadSource,LastName FROM Lead WHERE  CreatedDate>=:yesterdayDateAndTime]);
            recentlyCreatedOrUpdatedLead.addAll([SELECT  Id, Name,Company,Email,LeadSource, LastName FROM Lead WHERE LastModifiedDate>=:yesterdayDateAndTime]);
            recordsToSync = new list<lead>(recentlyCreatedOrUpdatedLead);
            System.debug(recordsToSync);
            return recordsToSync;
    }
}

