@isTest
private class TeamOrderTotalsCalculatorTest {
    
    @isTest
    static void sumOrdersTest() {
        Test.startTest();

        // Crée 3 comptes et 3 commandes pour chaque compte
        List<Account> accounts = TestDataFactory.createAccounts(3);
        List<Order> orders = TestDataFactory.createOrdersForAccounts(accounts, 3, 100, 1);

        // Calcule la somme attendue des commandes
        decimal expectedTotal = orders.size() * 100;

        // Vérifie que la somme des commandes est correcte
        List<AggregateResult> results = [SELECT SUM(TotalAmount) total FROM Order WHERE Id IN :orders];
        decimal sumOrders = (decimal)results[0].get('total');
        System.assertEquals(expectedTotal, sumOrders);

        Test.stopTest();
    }
    
    @isTest
    static void sumOrdersTestWithNoOrders() {
        Test.startTest();

        // Crée 3 comptes et 3 commandes pour chaque compte
        List<Account> accounts = TestDataFactory.createAccounts(3);
        List<Order> orders = TestDataFactory.createOrdersForAccounts(accounts, 0, 0, 0);

        // Calcule la somme attendue des commandes
        decimal expectedTotal = null;

        // Vérifie que la somme des commandes est correcte
        List<AggregateResult> results = [SELECT SUM(TotalAmount) total FROM Order WHERE Id IN :orders];
        decimal sumOrders = (decimal)results[0].get('total');
        System.assertEquals(expectedTotal, sumOrders);

        Test.stopTest();
    }
}