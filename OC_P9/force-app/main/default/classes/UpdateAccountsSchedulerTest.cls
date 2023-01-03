@isTest
private class UpdateAccountsSchedulerTest {
    @isTest
    static void testUpdateAccountsScheduler() {
        // Démarrage de la phase de test
        Test.startTest();

        // Planification de l'exécution de la classe UpdateAccountsScheduler dans 1 minute
        String CRON_EXP = '0 0 0/1 * * ?';
        UpdateAccountsScheduler updateAccountsScheduler = new UpdateAccountsScheduler();
        System.schedule('Update Accounts Scheduler', CRON_EXP, updateAccountsScheduler);

        // Attente de l'exécution de la classe UpdateAccountsScheduler
        Test.stopTest();
        System.assertEquals(1, [SELECT COUNT() FROM CronTrigger WHERE CronJobDetail.Name = 'Update Accounts Scheduler']);
    }
}