/**
 * @author ngum buka fon nyuydze
 * @since 06/02/2023
 */

public without sharing class HttpServiceConnectorScheduler implements  Schedulable  {
    public void execute(SchedulableContext ctx) {
        HttpServiceConnector.getAndUpsertRecords();
        string cronExpression = Helper.generateUpcommingCronExpression(1);
        String jobName = 'Get all records created before 3pm today ::'+cronExpression;
        System.schedule(jobName,cronExpression,new HttpServiceConnectorScheduler());
    }
}