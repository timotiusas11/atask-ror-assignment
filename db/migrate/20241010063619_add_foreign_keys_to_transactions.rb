class AddForeignKeysToTransactions < ActiveRecord::Migration[7.2]
  def change
    if foreign_key_exists?(:transactions, :source_wallets)
      remove_foreign_key :transactions, :source_wallets
    end

    if foreign_key_exists?(:transactions, :target_wallets)
      remove_foreign_key :transactions, :target_wallets
    end

    add_foreign_key :transactions, :wallets, column: :source_wallet_id
    add_foreign_key :transactions, :wallets, column: :target_wallet_id
  end
end
