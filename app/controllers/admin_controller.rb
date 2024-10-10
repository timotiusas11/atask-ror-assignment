class AdminController < ApplicationController
  def index
    @users = User.all
    @teams = Team.all
    @stocks = Stock.all
    @transactions = Transaction.all

    render json: {
      users: @users,
      teams: @teams,
      stocks: @stocks,
      transactions: @transactions
    }
  end
end
