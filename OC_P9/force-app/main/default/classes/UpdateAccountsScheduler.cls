global class UpdateAccountsScheduler implements Schedulable {
    global void execute(SchedulableContext ctx) {
        UpdateAccounts updateAccounts = new UpdateAccounts();
        Database.executeBatch(updateAccounts);
    }
}