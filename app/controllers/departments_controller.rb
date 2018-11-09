class DepartmentsController < ApplicationController
  before_action :redirect_unless_comm!
  before_action :set_department, only: [:show, :edit, :update, :destroy]

  # GET /departments
  # GET /departments.json
  def index
    @departments = Department.all
  end

  # GET /departments/1
  # GET /departments/1.json
  def show
  end

  # GET /departments/new
  def new
    @department = Department.new
  end

  # GET /departments/1/edit
  def edit
  end

  # POST /departments
  def create
    @department = Department.new(department_params)

    if @department.save
      redirect_to @department, flash: { success: 'Department was successfully created.' }
    else
      render :new
    end
  end

  # PATCH/PUT /departments/1
  def update
    if @department.update(department_params)
      redirect_to @department, flash: { success: 'Department was successfully updated.' }
    else
      render :edit
    end
  end

  # DELETE /departments/1
  def destroy
    @department.destroy
    redirect_to departments_url, flash: { success: 'Department was successfully destroyed.' }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_department
      @department = Department.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def department_params
      params.require(:department).permit(:code, :name, :region_id)
    end
end
