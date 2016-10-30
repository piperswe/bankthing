contract Bank {
  enum TransactionType { Deposit, Withdraw }
  struct Transaction {
    TransactionType type;
    uint amount;
  }

  struct Account {
    Transaction[] transactions;
  }

  mapping(address => Account) private accounts;

  function calculateBalance(Account account) internal
    returns (uint balance)
  {
    uint working = 0;
    for (int i = 0; i < account.transactions.length; i++) {
      Transaction transaction = account.transactions[i];
      if (transaction.type == Deposit) {
        working += transaction.amount;
      } else if (transaction.type == Withdraw) {
        working -= transaction.amount;
      }
    }
    return working;
  }
}
