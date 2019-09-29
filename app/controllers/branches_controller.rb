class BranchesController < ApplicationController
  before_action :require_user_logged_in
  
  def index
    @branches = Branch.all.includes(:company).order('created_at').page(params[:page])
    @companies = Company.where('name LIKE?', "%#{params[:company]}%") if params[:company].present?
    @branches = @branches.where(company_id: @companies.pluck(:id)) if @companies
    @branches = @branches.where('name LIKE?', "%#{params[:branch]}%") if params[:branch].present?
  end

  def show
    @branch = Branch.find(params[:id])
    @rental_machines = @branch.rental_machines.includes(:machine).order('machine_id').page(params[:page])
    @machines = Machine.all
    @machines = @machines.where('name LIKE?', "%#{params[:machine]}%") if params[:machine].present?
    @machines = @machines.where('type1 LIKE?', "%#{params[:type1]}%") if params[:type1].present?
    @machines = @machines.where('type2 LIKE?', "%#{params[:type2]}%") if params[:type2].present?
    @rental_machines = @rental_machines.where(machine_id: @machines.pluck(:id)) if @machines
    @rental_machines = @rental_machines.where('code LIKE?', "%#{params[:code]}%") if params[:code].present?
    @rental_machines = @rental_machines.where(status: params[:rental_machine][:status].to_i) if params[:rental_machine].present?
  end

  def new
    @branch = Branch.new
  end

  def create
    @branch = Branch.new(branch_params)
    
    if @branch.save
      flash[:success] = '所有営業所を登録しました。'
      redirect_to root_url
    else
      flash.now[:danger] = '所有営業所の登録に失敗しました。'
      render :new
    end
  end

  def edit
    @branch = Branch.find(params[:id])
  end

  def update
    @branch = Branch.find(params[:id])
    
    if @branch.update(branch_params)
      flash[:success] = '所有営業所を編集しました。'
      redirect_to root_url
    else
      flash.now[:danger] = '所有営業所が編集できませんでした。'
      render :edit
    end
  end
  
  private
  
  def branch_params
    params.require(:branch).permit(:company_id, :name, :address)
  end
end
