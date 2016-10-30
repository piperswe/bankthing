contract EtherBank {
  struct Account {
    uint balance;
    uint lastInterestPayment;
  }

  mapping(address => Account) private accounts;
  // Interest rates are in ten-thousandths of a percent per hundred blocks.
  uint public savingsInterestRate;
  uint public loanInterestRate;

  function EtherBank(uint sir, uint lir) payable {
    savingsInterestRate = sir;
    loanInterestRate = lir;

    deposit();
  }

  function withdraw(uint amount) {
    Account account = accounts[msg.sender];
    recalculateInterest();
    if (account.balance - amount >= 0 && amount >= 0) {
      // Done this way to protect against recursive calling vuln
      account.balance -= amount;
      if (!msg.sender.send(amount)) {
        account.balance += amount;
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

    uint time = (block.number - account.lastInterestPayment) / 10;
    uint otherTime = (block.number - account.lastInterestPayment) % 10;

    account.balance = account.balance * (((1000000 + savingsInterestRate) ** time) / (1000000 ** time));
    account.lastInterestPayment = now - otherTime;
  }
}
