/**
 * @author ngum buka fon nyuydze
 * @since 06/02/2023
 */

public without sharing class CrossOrgConnectorService {
    @invokable
    public static void start() {
        string cronExpression = Helper.generateUpcommingCronExpression(0);
        String jobName = 'Get all records created before 3pm today ::'+cronExpression;
        System.schedule(jobName, cronExpression, new HttpServiceConnectorScheduler());
    }
}