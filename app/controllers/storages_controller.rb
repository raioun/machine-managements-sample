class StoragesController < ApplicationController
  before_action :require_user_logged_in
  
  def index
    @storages = Storage.all.includes(:company).order('created_at').page(params[:page])
  end

  def show
    @storage = Storage.find(params[:id])
  end

  def new
    @storage = Storage.new
  end

  def create
    @storage = Storage.new(storage_params)
    
    if @storage.save
      flash[:success] = '保管場所を登録しました。'
      redirect_to root_url
    else
      flash.now[:danger] = '保管場所の登録に失敗しました。'
      render :new
    end
  end

  def edit
    @storage = Storage.find(params[:id])
  end

  def update
    @storage = Storage.find(params[:id])
    
    if @storage.update(storage_params)
      flash[:success] = '保管場所を編集しました。'
      redirect_to root_url
    else
      flash.now[:danger] = '保管場所が編集できませんでした。'
      render :edit
    end
  end
  
  private
  
  def storage_params
    params.require(:storage).permit(:company_id, :name, :address)
  end
end
