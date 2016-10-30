contract Bank {
  enum TransactionType { Deposit, Withdraw }
  struct Transaction {
    TransactionType transactionType;
    uint amount;
  }

  struct Account {
    Transaction[] transactions;
  }

  mapping(address => Account) private accounts;

  function withdraw(uint amount) {
    Account account = accounts[msg.sender];
    if (calculateBalance(account) - amount < 0) {
      throw;
    } else if (msg.sender.send(amount)) {
      account.transactions.push(Transaction(TransactionType.Withdraw, amount));
    }
  }

  function deposit() payable {
    Account account = accounts[msg.sender];
    account.transactions.push(Transaction(TransactionType.Deposit, msg.value));
  }

  function calculateBalance(Account account) internal
    returns (uint balance)
  {
    uint working = 0;
    for (uint i = 0; i < account.transactions.length; i++) {
      var transaction = account.transactions[i];
      if (transaction.transactionType == TransactionType.Deposit) {
        working += transaction.amount;
      } else if (transaction.transactionType == TransactionType.Withdraw) {
        working -= transaction.amount;
      }
    }
    return working;
  }
}
