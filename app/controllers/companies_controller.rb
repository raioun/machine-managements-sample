class CompaniesController < ApplicationController
  before_action :require_user_logged_in
  
  def index
    @companies = Company.all.order('name').page(params[:page])
    @companies = @companies.where('name LIKE?', "%#{params[:company]}%") if params[:company].present?
  end
  
  def show
    @company = Company.find(params[:id])
    @branches = @company.branches.order('id').page(params[:page])
  end
  
  def new
    @company = Company.new
  end

  def create
    @company = Company.new(company_params)
    
    if @company.save
      flash[:success] = '所有企業を登録しました。'
      redirect_to root_url
    else
      flash.now[:danger] = '所有企業の登録に失敗しました。'
      render :new
    end
  end
  
  def edit
    @company = Company.find(params[:id])
  end
  
  def update
    @company = Company.find(params[:id])
    
    if @company.update(customer_params)
    flash[:success] = '顧客企業を編集しました。'
      redirect_to @company
    else
      flash.now[:danger] = '顧客企業の編集に失敗しました。'
      render :edit
    end
  end
  
  private
  
  def company_params
    params.require(:company).permit(:name)
  end
end
