global class UpdateAccountsBatch implements Database.Batchable<sObject> {
    
    // Méthode qui retourne la liste des comptes qui ont au moins une commande en statut "Ordered"
    global Database.QueryLocator start(Database.BatchableContext info) { 
        return Database.getQueryLocator('SELECT Id, Chiffre_d_affaire__c, (SELECT Id, AccountId, TotalAmount FROM Orders WHERE Status = \'Ordered\') FROM Account');
    }
     
    // Méthode qui met à jour le chiffre d'affaires de chaque compte
    global void execute(Database.BatchableContext info, List<Account> scope) {
        // Pour chaque compte avec une commande en statut 'Ordered', affectation du chiffre d'affaires au compte en ajoutant le TotalAmount
        for(Account accountUpdate : scope){
            Decimal accountCA = 0;
            for(Order orders : accountUpdate.orders) {
                if (orders.TotalAmount != null) {
                    accountCA = accountCA + orders.TotalAmount;
                }
            }
            accountUpdate.Chiffre_d_affaire__c = accountCA;
        }
        update scope;
    }
    
    // Méthode qui est exécutée une fois que l'ensemble du traitement a été effectué
    global void finish(Database.BatchableContext info) {
    } 
}