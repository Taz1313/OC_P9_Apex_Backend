trigger OrderTrigger on Order (before update, after update) {
    if (Trigger.isBefore) {
        OrderTriggerHandler.calculateAmount(Trigger.new);
    } else if (Trigger.isAfter) {
        // Récupération de la liste des identifiants de compte des commandes mises à jour
        List<Id> accountIds = new List<Id>();
        for (Order order : Trigger.new) {
            accountIds.add(order.AccountId);
        }
        OrderTriggerHandler.updateAccountCA(accountIds);
    }
}