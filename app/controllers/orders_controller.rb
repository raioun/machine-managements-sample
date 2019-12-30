class OrdersController < ApplicationController
  before_action :require_user_logged_in
  
  def index
    # p params[:in_date] = params[:in_date].gsub(/\A(?:\p{Hiragana}|\p{Katakana}|[ー－]|[一-龠々])+\z/, '') if params[:in_date].present?
    p params[:in_date] = params[:in_date].gsub(/\A(?:\p{Hiragana}|[^ -~。-゜]|「|」)+\z/, '') if params[:in_date].present?
    
    # p params[:out_date] = params[:out_date].gsub(/\A(?:\p{Hiragana}|\p{Katakana}|[ー－]|[一-龠々])+\z/, '') if params[:out_date].present?
    p params[:out_date] = params[:out_date].gsub(/\A(?:\p{Hiragana}|[^ -~。-゜]|「|」)+\z/, '') if params[:out_date].present?
    
    @orders = Order.all.includes(:user).includes(:project).includes(:orderer).includes(:rental_machine).order('status', 'out_date', 'out_time', 'in_date', 'in_time').page(params[:page])
    
    # mysql2の場合は下記を使用
    # @orders = @orders.where('out_date LIKE?', "%#{params[:out_date]}%") if params[:out_date].present?
    # @orders = @orders.where('in_date LIKE?', "%#{params[:in_date]}%") if params[:in_date].present?
    
    # postgresqlの場合は下記を使用
    # @orders = @orders.where('CAST(out_date AS text) LIKE ?', "%#{params[:out_date]}%") if params[:out_date].present?
    # @orders = @orders.where('CAST(in_date AS text) LIKE ?', "%#{params[:in_date]}%") if params[:in_date].present?
    
    if Rails.env.production?
      @orders = @orders.where('CAST(out_date AS text) LIKE ?', "%#{params[:out_date]}%") if params[:out_date].present?
      @orders = @orders.where('CAST(in_date AS text) LIKE ?', "%#{params[:in_date]}%") if params[:in_date].present?
    else
      @orders = @orders.where('out_date LIKE?', "%#{params[:out_date]}%") if params[:out_date].present?
      @orders = @orders.where('in_date LIKE?', "%#{params[:in_date]}%") if params[:in_date].present?
    end
    
    @users = User.where('name LIKE?', "%#{params[:user]}%") if params[:user].present?
    @orders = @orders.where(user_id: @users.pluck(:id)) if @users
    
    @customers = Customer.where('name LIKE?', "%#{params[:customer]}%") if params[:customer].present?
    # @orderers = Orderer.where(customer_id: @customers.pluck(:id)) if @customers
    # @orders = @orders.where(orderer_id: @orderers.pluck(:id)) if @orderers
    @project = Project.where(customer_id: @customers.pluck(:id)) if @customers
    @orders = @orders.where(project_id: @project.pluck(:id)) if @project #@projectと次の@projectsは関数名を分けないと、検索フォームに記載した顧客名が無視させる不具合が発生する
    
    @projects = Project.where('name LIKE?', "%#{params[:project]}%") if params[:project].present?
    @orders = @orders.where(project_id: @projects.pluck(:id)) if @projects
    
    # @orderers = Orderer.where('family_name LIKE?', "%#{params[:orderer]}%") if params[:orderer].present?
    # @orders = @orders.where(orderer_id: @orderers.pluck(:id)) if @orderers
    
    @machines = Machine.all
    @rental_machines = RentalMachine.all
    @machines = @machines.where('name LIKE?', "%#{params[:machine]}%") if params[:machine].present?
    @machines = @machines.where('type1 LIKE?', "%#{params[:type1]}%") if params[:type1].present?
    @machines = @machines.where('type2 LIKE?', "%#{params[:type2]}%") if params[:type2].present?
    @rental_machines = @rental_machines.where(machine_id: @machines.pluck(:id)) if @machines
    # @orders = @orders.where(rental_machine_id: @rental_machines.pluck(:id)) if @rental_machines
    
    @companies = Company.where('name LIKE?', "%#{params[:company]}%") if params[:company].present?
    @branches = Branch.where(company_id: @companies.pluck(:id)) if @companies
    # binding.pry
    # @rental_machines = @rental_machines.where(branch_id: @branches.pluck(:id)) if @branches
    # @orders = @orders.where(rental_machine_id: @rental_machines.pluck(:id)) if @rental_machines
    
    @branches = Branch.where('name LIKE?', "%#{params[:branch]}%") if params[:branch].present?
    @rental_machines = @rental_machines.where(branch_id: @branches.pluck(:id)) if @branches
    @orders = @orders.where(rental_machine_id: @rental_machines.pluck(:id)) if @rental_machines
    
  end

  def show
    @order = Order.find(params[:id])
  end

  def new
    @order = Order.new(rental_machine_id: params[:rental_machine_id])
  end

  def create
    @order = Order.new(order_params)
  
    if @order.save
      flash[:success] = '案件を登録しました。'
      redirect_to root_url
    else
      flash.now[:danger] = '案件の登録に失敗しました。'
      render :new
    end
  end

  def edit
    @order = Order.find(params[:id])
  end

  def update
    @order = Order.find(params[:id])
    # binding.pry
    if @order.update(order_params)
      flash[:success] = '案件を編集しました。'
      redirect_to @order
    else
      flash.now[:danger] = '案件の編集に失敗しました。'
      render :edit
    end
  end

  def destroy
    @order = Order.find(params[:id])
    
    if @order.status == '予約中'
      @order.destroy
      flash[:success] = '予約中の案件削除に成功しました。'
      redirect_to orders_url
    else
      flash.now[:danger] = '予約中以外の案件は削除できません。'
      redirect_to root_url
    end
  end
  
  def reservations
    
    @reservations = Order.where(status: "予約中").order('status, out_date, out_time, in_date, in_time').page(params[:page])
    @reservations = @reservations.where('out_date LIKE?', "%#{params[:out_date]}%") if params[:out_date].present?
    @reservations = @reservations.where('in_date LIKE?', "%#{params[:in_date]}%") if params[:in_date].present?
    
    @user = User.where('name LIKE?', "%#{params[:user]}%") if params[:user].present?
    @reservations = @reservations.where(user_id: @user.pluck(:id)) if @user

    @customers = Customer.where('name LIKE?', "%#{params[:customer]}%") if params[:customer].present?
    @project = Project.where(customer_id: @customers.pluck(:id)) if @customers
    @reservations = @reservations.where(project_id: @project.pluck(:id)) if @project
    
    @projects = Project.where('name LIKE?', "%#{params[:project]}%") if params[:project].present?
    @reservations = @reservations.where(project_id: @projects.pluck(:id)) if @projects
    
    # @orderer = Orderer.where('family_name LIKE?', "%#{params[:orderer]}%") if params[:orderer].present?
    # @reservations = @reservations.where(orderer_id: @orderer.pluck(:id)) if @orderer
    
    @machines = Machine.all
    @rental_machines = RentalMachine.all
    @machines = @machines.where('name LIKE?', "%#{params[:machine]}%") if params[:machine].present?
    @machines = @machines.where('type1 LIKE?', "%#{params[:type1]}%") if params[:type1].present?
    @machines = @machines.where('type2 LIKE?', "%#{params[:type2]}%") if params[:type2].present?
    @rental_machines = @rental_machines.where(machine_id: @machines.pluck(:id)) if @machines
    # @reservations = @reservations.where(rental_machine_id: @rental_machines.pluck(:id)) if @rental_machines
    
    @companies = Company.where('name LIKE?', "%#{params[:company]}%") if params[:company].present?
    @branches = Branch.where(company_id: @companies.pluck(:id)) if @companies
    # @rental_machines = @rental_machines.where(branch_id: @branches.pluck(:id)) if @branches
    # @reservations = @reservations.where(rental_machine_id: @rental_machines.pluck(:id)) if @rental_machines
    
    @branches = Branch.where('name LIKE?', "%#{params[:branch]}%") if params[:branch].present?
    @rental_machines = @rental_machines.where(branch_id: @branches.pluck(:id)) if @branches
    @reservations = @reservations.where(rental_machine_id: @rental_machines.pluck(:id)) if @rental_machines
    
  end
  
  def uses
    
    @uses = Order.where(status: "出庫中").order('status, out_date, out_time, in_date, in_time').page(params[:page])
    @uses = @uses.where('out_date LIKE?', "%#{params[:out_date]}%") if params[:out_date].present?
    @uses = @uses.where('in_date LIKE?', "%#{params[:in_date]}%") if params[:in_date].present?
    
    @user = User.where('name LIKE?', "%#{params[:user]}%") if params[:user].present?
    @uses = @uses.where(user_id: @user.pluck(:id)) if @user
    
    @customers = Customer.where('name LIKE?', "%#{params[:customer]}%") if params[:customer].present?
    @project = Project.where(customer_id: @customers.pluck(:id)) if @customers
    @uses = @uses.where(project_id: @project.pluck(:id)) if @project
    
    @projects = Project.where('name LIKE?', "%#{params[:project]}%") if params[:project].present?
    @uses = @uses.where(project_id: @projects.pluck(:id)) if @projects
    
    # @orderer = Orderer.where('family_name LIKE?', "%#{params[:orderer]}%") if params[:orderer].present?
    # @uses = @uses.where(orderer_id: @orderer.pluck(:id)) if @orderer
    
    @machines = Machine.all
    @rental_machines = RentalMachine.all
    @machines = @machines.where('name LIKE?', "%#{params[:machine]}%") if params[:machine].present?
    @machines = @machines.where('type1 LIKE?', "%#{params[:type1]}%") if params[:type1].present?
    @machines = @machines.where('type2 LIKE?', "%#{params[:type2]}%") if params[:type2].present?
    @rental_machines = @rental_machines.where(machine_id: @machines.pluck(:id)) if @machines
    # @uses = @uses.where(rental_machine_id: @rental_machines.pluck(:id)) if @rental_machines
    
    @companies = Company.where('name LIKE?', "%#{params[:company]}%") if params[:company].present?
    @branches = Branch.where(company_id: @companies.pluck(:id)) if @companies
    # @rental_machines = @rental_machines.where(branch_id: @branches.pluck(:id)) if @branches
    # @uses = @uses.where(rental_machine_id: @rental_machines.pluck(:id)) if @rental_machines
    
    @branches = Branch.where('name LIKE?', "%#{params[:branch]}%") if params[:branch].present?
    @rental_machines = @rental_machines.where(branch_id: @branches.pluck(:id)) if @branches
    @uses = @uses.where(rental_machine_id: @rental_machines.pluck(:id)) if @rental_machines
    
  end
  
  def cominghomes
    
    @cominghomes = Order.where(status: "返却済み").order('status, out_date, out_time, in_date, in_time').page(params[:page])
    @cominghomes = @cominghomes.where('out_date LIKE?', "%#{params[:out_date]}%") if params[:out_date].present?
    @cominghomes = @cominghomes.where('in_date LIKE?', "%#{params[:in_date]}%") if params[:in_date].present?
    
    @user = User.where('name LIKE?', "%#{params[:user]}%") if params[:user].present?
    @cominghomes = @cominghomes.where(user_id: @user.pluck(:id)) if @user
    
    @customers = Customer.where('name LIKE?', "%#{params[:customer]}%") if params[:customer].present?
    @project = Project.where(customer_id: @customers.pluck(:id)) if @customers
    @cominghomes = @cominghomes.where(project_id: @project.pluck(:id)) if @project
    
    @projects = Project.where('name LIKE?', "%#{params[:project]}%") if params[:project].present?
    @cominghomes = @cominghomes.where(project_id: @projects.pluck(:id)) if @projects
    
    # @orderer = Orderer.where('family_name LIKE?', "%#{params[:orderer]}%") if params[:orderer].present?
    # @cominghomes = @cominghomes.where(orderer_id: @orderer.pluck(:id)) if @orderer
    
    @machines = Machine.all
    @rental_machines = RentalMachine.all
    @machines = @machines.where('name LIKE?', "%#{params[:machine]}%") if params[:machine].present?
    @machines = @machines.where('type1 LIKE?', "%#{params[:type1]}%") if params[:type1].present?
    @machines = @machines.where('type2 LIKE?', "%#{params[:type2]}%") if params[:type2].present?
    @rental_machines = @rental_machines.where(machine_id: @machines.pluck(:id)) if @machines
    # @cominghomes = @cominghomes.where(rental_machine_id: @rental_machines.pluck(:id)) if @rental_machines
    
    @companies = Company.where('name LIKE?', "%#{params[:company]}%") if params[:company].present?
    @branches = Branch.where(company_id: @companies.pluck(:id)) if @companies
    # @rental_machines = @rental_machines.where(branch_id: @branches.pluck(:id)) if @branches
    # @cominghomes = @cominghomes.where(rental_machine_id: @rental_machines.pluck(:id)) if @rental_machines
    
    @branches = Branch.where('name LIKE?', "%#{params[:branch]}%") if params[:branch].present?
    @rental_machines = @rental_machines.where(branch_id: @branches.pluck(:id)) if @branches
    @cominghomes = @cominghomes.where(rental_machine_id: @rental_machines.pluck(:id)) if @rental_machines
    
  end
  
  private
  
  def order_params
    params.require(:order).permit(:out_date, :out_time, :in_date, :in_time, :status, :project_id, :rental_machine_id, :orderer_id, :user_id, :remarks)
  end
end
