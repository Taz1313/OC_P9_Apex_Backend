global class UpdateAccounts implements Database.Batchable<sObject> {
    
    // Méthode qui retourne la liste des comptes qui ont au moins une commande en statut "Ordered"
    global Database.QueryLocator start(Database.BatchableContext info) { 
        return Database.getQueryLocator('SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id IN (SELECT AccountId FROM Order WHERE Status = \'Ordered\')');
    }
     
    // Méthode qui met à jour le chiffre d'affaires de chaque compte
    global void execute(Database.BatchableContext info, List<Account> scope) {
        Map<Id, Decimal> mapAccountTotalAmount = new Map<Id, Decimal>();

        Map<Id, Account> accountIds = new Map<Id, Account>(scope);

        // Récupération de la somme des montants de toutes les commandes
        for (Order order : [SELECT AccountId, TotalAmount FROM Order WHERE AccountId IN :accountIds.keySet()]) {
            if (!mapAccountTotalAmount.containsKey(order.AccountId)) {
                mapAccountTotalAmount.put(order.AccountId, 0);
            }
            mapAccountTotalAmount.put(order.AccountId, mapAccountTotalAmount.get(order.AccountId) + order.TotalAmount);
        }
        
        // Mise à jour du chiffre d'affaires de chaque compte avec la somme des montants de ses commandes
        for (Account account : scope) {
            account.Chiffre_d_affaire__c = mapAccountTotalAmount.get(account.Id);
        }
        
        update scope;
    }
     
    // Méthode qui est exécutée une fois que l'ensemble du traitement a été effectué
    global void finish(Database.BatchableContext info) {
    } 
}