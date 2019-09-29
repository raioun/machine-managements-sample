class OrderersController < ApplicationController
  before_action :require_user_logged_in 
  
  def index
    @orderers = Orderer.all.includes(:customer).page(params[:page])
    @customers = Customer.where('name LIKE?', "%#{params[:customer]}%") if params[:customer].present?
    @orderers = @orderers.where(customer_id: @customers.pluck(:id)) if @customers
    @orderers = @orderers.where('family_name LIKE?', "%#{params[:family_name]}%") if params[:family_name].present?
    @orderers = @orderers.where(status: params[:orderer][:status].to_i) if params[:orderer].present?
  end

  def show
    @orderer = Orderer.find(params[:id])
    
    @orders = @orderer.orders.order('status, out_date, out_time, in_date, in_time').page(params[:page])
    
    p params[:in_date] = params[:in_date].gsub(/\A(?:\p{Hiragana}|[^ -~。-゜]|「|」)+\z/, '') if params[:in_date].present?
    p params[:out_date] = params[:out_date].gsub(/\A(?:\p{Hiragana}|[^ -~。-゜]|「|」)+\z/, '') if params[:out_date].present?
    
    if Rails.env.production?
      @orders = @orders.where('CAST(out_date AS text) LIKE ?', "%#{params[:out_date]}%") if params[:out_date].present?
      @orders = @orders.where('CAST(in_date AS text) LIKE ?', "%#{params[:in_date]}%") if params[:in_date].present?
    else
      @orders = @orders.where('out_date LIKE?', "%#{params[:out_date]}%") if params[:out_date].present?
      @orders = @orders.where('in_date LIKE?', "%#{params[:in_date]}%") if params[:in_date].present?
    end
    
    @orders = @orders.where(status: params[:order][:status].to_i) if params[:order].present?
  end

  def new
    @orderer = Orderer.new
  end

  def create
    @orderer = Orderer.new(orderer_params)
    
    if @orderer.save
      flash[:success] = '発注者を登録しました。'
      redirect_to root_url
    else
      flash.now[:danger] = '発注者の登録に失敗しました。'
      render :new
    end
  end

  def edit
    @orderer = Orderer.find(params[:id])
  end

  def update
    @orderer = Orderer.find(params[:id])
    
    if @orderer.update(orderer_params)
      flash[:success] = '発注者を編集しました。'
      redirect_to @orderer
    else
      flash.now[:danger] = '発注者の編集に失敗しました。'
      render :edit
    end
  end
  
  private
  
  def orderer_params
    params.require(:orderer).permit(:customer_id, :family_name, :first_name, :phone_number, :status, :remarks)
  end
end
