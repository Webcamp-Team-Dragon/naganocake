class Admin::CustomersController < ApplicationController
  before_action :authenticate_admin!

  def index
   @customers = Customer.page(params[:page])
  end

  def show
   @customer = Customer.find(params[:id])
  end

  def edit
    @customer = Customer.find(params[:id])
  end

  def update
    @customer = Customer.find(params[:id])
    if @customer.update(customer_params)
      redirect_to admin_customer_path(@customer)
      flash[:notice] = "顧客情報を更新しました！"
    else
     redirect_to admins_customer_path(@customer)
    end
  end

  private
  def customer_params
    params.require(:customer).permit(:last_name, :first_name, :last_name_kana, :first_name_kana, :postal_code, :address, :telephone_number, :email, :is_active)
  end
end