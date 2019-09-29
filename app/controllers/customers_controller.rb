class CustomersController < ApplicationController
  before_action :require_user_logged_in
  
  def index
    @customers = Customer.all.order('name').page(params[:page])
    # @customers = @customers.where(name: params[:customer]) if params[:customer].present?
    @customers = @customers.where('name LIKE?', "%#{params[:customer]}%") if params[:customer].present?
  end
  
  def show
    @customer = Customer.find(params[:id])
    @projects = @customer.projects.order('created_at DESC').page(params[:page])
    @projects = @projects.where('name LIKE?', "%#{params[:project]}%") if params[:project].present?
    @orderers = @customer.orderers.order('created_at').page(params[:page])
    @orderers = @orderers.where('family_name LIKE?', "%#{params[:family_name]}%") if params[:family_name].present?
    @orderers = @orderers.where(status: params[:orderer][:status].to_i) if params[:orderer].present?
  end
  
  def new
    @customer = Customer.new
  end

  def create
    @customer = Customer.new(customer_params)
    
    if @customer.save
      flash[:success] = '顧客を登録しました。'
      redirect_to root_url
    else
      flash.now[:danger] = '顧客の登録に失敗しました。'
      render :new
    end
  end
  
  def edit
    @customer = Customer.find(params[:id])
  end
  
  def update
    @customer = Customer.find(params[:id])
    
    if @customer.update(customer_params)
    flash[:success] = '顧客企業を編集しました。'
      redirect_to @customer
    else
      flash.now[:danger] = '顧客企業の編集に失敗しました。'
      render :edit
    end
  end
  
  private
  
  def customer_params
    params.require(:customer).permit(:name)
  end
end
