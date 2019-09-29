class RentalMachinesController < ApplicationController
  before_action :require_user_logged_in
  
  def index
    @rental_machines = RentalMachine.all.includes(:machine).includes(:branch).includes(:storage).order('machine_id', 'code').page(params[:page])
    @machines = Machine.all
    @machines = @machines.where('name LIKE?', "%#{params[:machine]}%") if params[:machine].present?
    @machines = @machines.where('type1 LIKE?', "%#{params[:type1]}%") if params[:type1].present?
    @machines = @machines.where('type2 LIKE?', "%#{params[:type2]}%") if params[:type2].present?
    @rental_machines = @rental_machines.where(machine_id: @machines.pluck(:id)) if @machines
    
    @rental_machines = @rental_machines.where('code LIKE?', "%#{params[:code]}%") if params[:code].present?

    @companies = Company.where('name LIKE?', "%#{params[:company]}%") if params[:company].present?
    @branches = Branch.where(company_id: @companies.pluck(:id)) if @companies
    # @rental_machines = @rental_machines.where(branch_id: @branches.pluck(:id)) if @branches
    
    @branches = Branch.where('name LIKE?', "%#{params[:branch]}%") if params[:branch].present?
    @rental_machines = @rental_machines.where(branch_id: @branches.pluck(:id)) if @branches
    
    @storage_companies = Company.where('name LIKE?', "%#{params[:storage_company]}%") if params[:storage_company].present?
    @storages = Storage.where(company_id: @storage_companies.pluck(:id)) if @storage_companies
    
    @storages = Storage.where('name LIKE?', "%#{params[:storage]}%") if params[:storage].present?
    @rental_machines = @rental_machines.where(storage_id: @storages.pluck(:id)) if @storages
    
    @rental_machines = @rental_machines.where(status: params[:rental][:status].to_i) if params[:rental].present?
    # binding.pry
  end

  def show
    @rental_machine = RentalMachine.find(params[:id])
    
    @orders = @rental_machine.orders.order('status, out_date, out_time, in_date, in_time').page(params[:page])
    
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
    @rental_machine = RentalMachine.new
  end

  def create
    @rental_machine = RentalMachine.new(rental_machine_params)
    
    if @rental_machine.save
      flash[:success] = '機材を登録しました。'
      redirect_to root_url
    else
      flash.now[:danger] = '機材の登録に失敗しました。'
      render :new
    end
  end

  def edit
    @rental_machine = RentalMachine.find(params[:id])
  end

  def update
    @rental_machine = RentalMachine.find(params[:id])
    
    if @rental_machine.update(rental_machine_params)
      flash[:success] = '機材を編集しました。'
      redirect_to @rental_machine
    else
      flash.now[:danger] = '機材の編集に失敗しました。'
      render :edit
    end
  end
  
  private
  
  def rental_machine_params
    params.require(:rental_machine).permit(:machine_id, :branch_id, :storage_id, :code, :status, :remarks)
  end
end
