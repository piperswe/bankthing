contract Bank {
  struct Account {
    uint balance;
    uint lastInterestPayment;
  }

  mapping(address => Account) private accounts;
  // Interest rates are in 0.01% per hour.
  uint public savingsInterestRate;
  uint public loanInterestRate;

  function Bank(uint sir, uint lir) {
    savingsInterestRate = sir;
    loanInterestRate = lir;
  }

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

  function recalculateInterest() {
    Account account = accounts[msg.sender];

    uint hundredthsOfHoursSince = ((now - account.lastInterestPayment) * 100) / (3600 * 100);
    account.balance = account.balance * (((10000 + savingsInterestRate) ** hundredthsOfHoursSince) / (100 ** hundredthsOfHoursSince));
    account.lastInterestPayment = now;
  }
}
