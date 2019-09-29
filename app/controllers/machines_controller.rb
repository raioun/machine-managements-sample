class MachinesController < ApplicationController
  before_action :require_user_logged_in
  
  def index
    @machines = Machine.all.order('name, type1, type2').page(params[:page])
    @machines = @machines.where('name LIKE?', "%#{params[:name]}%") if params[:name].present?
    @machines = @machines.where('type1 LIKE?', "%#{params[:type1]}%") if params[:type1].present?
    @machines = @machines.where('type2 LIKE?', "%#{params[:type2]}%") if params[:type2].present?
  end
  
  def show
    @machine = Machine.find(params[:id])
    
    @rental_machines = @machine.rental_machines.order('branch_id, code').page(params[:page])
    @rental_machines = @rental_machines.where('code LIKE?', "%#{params[:code]}%") if params[:code].present?
    @rental_machines = @rental_machines.where(status: params[:rental_machine][:status].to_i) if params[:rental_machine].present?
  end
  
  def new
    @machine = Machine.new
  end

  def create
    @machine = Machine.new(machine_params)
    
    if @machine.save
      flash[:success] = '新規機材名が登録されました。'
      redirect_to root_url
    else
      flash.now[:danger] = '新規機材名の登録に失敗しました。'
      render :new
    end
  end
  
  private
  
  def machine_params
    params.require(:machine).permit(:name, :type1, :type2)
  end
end
