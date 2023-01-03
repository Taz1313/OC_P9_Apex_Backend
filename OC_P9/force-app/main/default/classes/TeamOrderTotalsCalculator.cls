public without sharing class TeamOrderTotalsCalculator {
    
    // sumOrders retourne la somme de tous les champs "TotalAmount" de tous les enregistrements de la table "Order"
    public decimal sumOrders {
        
        get {
            AggregateResult groupedResults = [SELECT SUM(TotalAmount) total FROM Order WHERE Status = 'Activated'];
            // On convertit le résultat en décimal et on le retourne
            return (decimal)groupedResults.get('total');
        }
        set;
    }
}