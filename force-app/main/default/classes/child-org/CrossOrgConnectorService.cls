/**
 * @author ngum buka fon nyuydze
 * @since 06/02/2023
 */

public without sharing class CrossOrgConnectorService {
    @InvocableMethod(label='Get Parent Records' description='Fetch records from parent org')
    public static void start() {
        HttpServiceConnector.getAndUpsertRecords();
        string cronExpression = Helper.generateUpcommingCronExpression(0);
        String jobName = 'Get all records created before 3pm today ::'+cronExpression;
        System.schedule(jobName, cronExpression, new HttpServiceConnectorScheduler());
    }
}