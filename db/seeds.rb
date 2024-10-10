# db/seeds.rb

# Delete
Transaction.destroy_all
Wallet.destroy_all
Stock.destroy_all
Team.destroy_all
User.destroy_all

# Team
teams = Team.create!([
  { name: 'Team A' },
  { name: 'Team B' },
])

# User
users = User.create!([
  { name: 'Alice', email: 'alice@example.com', password: 'password123', team: teams[0]},
  { name: 'Bob', email: 'bob@example.com', password: 'password123', team: teams[1]},
])

# Stock
stocks = Stock.create!([
  { name: 'Stock A', symbol: 'STKA', price: 100.00 },
  { name: 'Stock B', symbol: 'STKB', price: 200.00 },
])

# Wallet
users.each do |user|
  user.wallet.update(balance: 1000.00)
end

teams.each do |team|
  team.wallet.update(balance: 2000.00)
end

# Transaction
transactions = Transaction.create!([
  { source_wallet: users[0].wallet, target_wallet: teams[0].wallet, amount: 100.00, transaction_type: 'Transfer' },
  { source_wallet: teams[0].wallet, target_wallet: users[0].wallet, amount: 50.00, transaction_type: 'Transfer' },
  { source_wallet: nil, target_wallet: users[1].wallet, amount: 500.00, transaction_type: 'Deposit' },
  { source_wallet: users[1].wallet, target_wallet: nil, amount: 200.00, transaction_type: 'Withdraw' },
])
