class TransactionsController < ApplicationController
  before_action :authorize_request

  # Create a new transaction and update wallet balance
  def create
    ActiveRecord::Base.transaction do
      wallet = Wallet.find_by(id: params[:wallet_id])
      return render json: { error: 'Wallet not found' }, status: :not_found unless wallet

      transaction = wallet.transactions.new(transaction_params)
      transaction.user_id = @current_user.id

      if transaction.save
        # Update wallet balance
        if update_wallet_balance(wallet, transaction)
          render json: { transaction: transaction, wallet: wallet }, status: :created
        else
          render json: { error: 'Insufficient funds or wallet update failed' }, status: :unprocessable_entity
        end
      else
        render json: transaction.errors, status: :unprocessable_entity
      end
    end
  end

  private

  # Transaction params
  def transaction_params
    params.require(:transaction).permit(:amount, :transaction_type, :wallet_id)
  end

  # Function to update the wallet balance based on transaction type
  def update_wallet_balance(wallet, transaction)
    if transaction.transaction_type == 'credit'
      wallet.update(balance: wallet.balance + transaction.amount)
    elsif transaction.transaction_type == 'debit'
      return false if wallet.balance < transaction.amount
      wallet.update(balance: wallet.balance - transaction.amount)
    else
      false
    end
  end

  # Authorization for JWT token
  def authorize_request
    header = request.headers['Authorization']
    token = header.split(' ').last if header
    begin
      @decoded = JWT.decode(token, Rails.application.credentials.jwt_secret, true, algorithm: 'HS256')
      @current_user = User.find(@decoded[0]['user_id'])
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end
end
