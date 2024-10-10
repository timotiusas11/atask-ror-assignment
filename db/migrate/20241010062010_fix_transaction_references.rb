class FixTransactionReferences < ActiveRecord::Migration[6.0]
  def change
    add_foreign_key :transactions, :wallets, column: :source_wallet_id
    add_foreign_key :transactions, :wallets, column: :target_wallet_id
  end
end
