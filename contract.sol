contract EtherBank {
  struct Account {
    uint balance;
    uint lastInterestPayment;
  }

  mapping(address => Account) private accounts;
  // Interest rates are in ten-thousandths of a percent per hour.
  uint public savingsInterestRate;
  uint public loanInterestRate;

  function EtherBank(uint sir, uint lir) {
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

  function balance() constant returns (uint balance) {
    return accounts[msg.sender].balance;
  }

  function recalculateInterest() {
    Account account = accounts[msg.sender];

    if (now - account.lastInterestPayment >= 1 minutes) {
      uint time = (now - account.lastInterestPayment) / 1 minutes;
      uint otherTime = (now - account.lastInterestPayment) % 1 minutes;

      account.balance = account.balance * (((10000 + savingsInterestRate) ** time) / (10000 ** time));
      account.lastInterestPayment = now - otherTime;
    }
  }
}
