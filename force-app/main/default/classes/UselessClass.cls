public with sharing class UselessClass {
    public UselessClass() {
        for(Integer i = 0; i < 10; i++) {
            Account acc = new Account();

            insert acc;
        }
    }
}
