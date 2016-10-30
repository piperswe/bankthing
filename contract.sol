contract Bank {
  struct Account {
    uint balance;
  }

  mapping(address => Account) private accounts;

  function withdraw(uint amount) {
    Account account = accounts[msg.sender];
    if (account.balance - amount >= 0 && amount >= 0) {
      if (msg.sender.send(amount)) {
        account.balance -= amount;
      } else {
        throw;
      }
    }
  }

  function deposit() payable {
    Account account = accounts[msg.sender];
    // Prevent overflow
    if (account.balance + msg.value < account.balance) throw;

    account.balance += msg.value;
  }

  function balance() returns (uint balance) {
    return accounts[msg.sender].balance;
  }
}
