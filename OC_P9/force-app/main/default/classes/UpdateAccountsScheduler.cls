global class UpdateAccountsScheduler implements Schedulable {
    global void execute(SchedulableContext ctx) {
        UpdateAccountsBatch updateAccounts = new UpdateAccountsBatch();
        Database.executeBatch(updateAccounts);
    }
}