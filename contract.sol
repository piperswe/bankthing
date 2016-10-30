pragma solidity ^0.4.3;
contract EtherBank {
  struct Account {
    uint balance;
    uint lastInterestPayment;
  }

  event Deposit(address addr, uint amount, uint balance);
  event Withdraw(address addr, uint amount, uint balance);

  mapping(address => Account) private accounts;
  // Interest rates are in ten-thousandths of a percent per hundred blocks.
  uint public savingsInterestRate;
  uint public loanInterestRate;

  function EtherBank(uint sir, uint lir) payable {
    savingsInterestRate = sir;
    loanInterestRate = lir;
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
      Withdraw(msg.sender, amount, account.balance);
    }

    accounts[msg.sender] = account;
  }

  function deposit() payable {
    Account account = accounts[msg.sender];
    recalculateInterest();
    // Prevent overflow
    if (account.balance + msg.value < account.balance) throw;

    account.balance += msg.value;

    accounts[msg.sender] = account;
    Deposit(msg.sender, msg.value, account.balance);
  }

  function balance() constant returns (uint balance) {
    return accounts[msg.sender].balance;
  }

  function recalculateInterest() {
    /*Account account = accounts[msg.sender];

    uint blocknum = block.number;
    uint time = blocknum - account.lastInterestPayment;

    account.balance = account.balance * (((1000000 + savingsInterestRate) ** time) / (1000000 ** time));
    account.lastInterestPayment = blocknum;

    accounts[msg.sender] = account;*/
  }
}
