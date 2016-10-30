contract Bank {
  enum TransactionType { Initial, Deposit, Withdraw }
  struct Transaction {
    TransactionType transactionType;
    uint amount;
  }

  mapping(address => Transaction[]) private accounts;

  function withdraw(uint amount) {
    Transaction[] account = accounts[msg.sender];
    if (calculateBalance(account) - amount >= 0 && msg.sender.send(amount)) {
      account.push(Transaction(TransactionType.Withdraw, amount));
    }
  }

  function deposit() payable {
    Transaction[] account = accounts[msg.sender];
    account.push(Transaction(TransactionType.Deposit, msg.value));
  }

  function balance()
    returns (uint balance)
  {
    return calculateBalance(accounts[msg.sender]);
  }

  function calculateBalance(Transaction[] account) internal
    returns (uint balance)
  {
    uint working = 0;
    for (uint i = 0; i < account.length; i++) {
      var transaction = account[i];
      if (transaction.transactionType == TransactionType.Deposit) {
        working += transaction.amount;
      } else if (transaction.transactionType == TransactionType.Withdraw) {
        working -= transaction.amount;
      }
    }
    return working;
  }
}
