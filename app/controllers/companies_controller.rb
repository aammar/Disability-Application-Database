class CompaniesController < ApplicationController
  before_action :set_company, only: [:show, :edit, :update, :destroy, :matchpg]
  before_action :authenticate_user!, :except => [:create, :new]
  before_filter :admin_only, :except => [:create, :new]
  

  # GET /companies
  # GET /companies.json
  def index
    @companies = Company.search(params[:search])
  end
  
  
  def matchpg
    @applicants= Applicant.all
    @companies = Company.matching(params[:id])
  end
  

  # GET /companies/1
  # GET /companies/1.json
  def show
  end

  # GET /companies/new
  def new
    @company = Company.new
  end

  # GET /companies/1/edit
  def edit
  end

  # POST /companies
  # POST /companies.json
  def create
    @company = Company.new(company_params)

    respond_to do |format|
      if @company.save
        format.html { redirect_to page_path('requestSaved'), notice: 'تم إدخال الطلب الجديد بنجاح' }
        format.json { render :show, status: :created, location: @company }
      else
        format.html { render :new }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /companies/1
  # PATCH/PUT /companies/1.json
  def update
    respond_to do |format|
      if @company.update(company_params)
        format.html { redirect_to @company, notice: 'تم تحديث الطلب بنجاح' }
        format.json { render :show, status: :ok, location: @company }
      else
        format.html { render :edit }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /companies/1
  # DELETE /companies/1.json
  def destroy
    @company.destroy
    respond_to do |format|
      format.html { redirect_to companies_url, notice: 'تم مسح الطلب بنجاح' }
      format.json { head :no_content }
    end
  end
  
  
  def emp
        Applicant.where(id: params[:applicant_ids]).update_all(employed: true)
        redirect_to :back
  end
  
  
  
  

  private
  
  # this below code for checking if logged in user is the admin!
    def admin_only
     unless current_user.admin?
       redirect_to :back, :alert => "لا يمكن الدخول لهذه الصفحة"
     end
   end
  
    # Use callbacks to share common setup or constraints between actions.
    def set_company
      @company = Company.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def company_params
      params.require(:company).permit(:noOfEmployees, :companyName, :jobTitle, :jobDescription, :contactPerson, :mobileNo, :email, :nationality, :gender, :age, :education,  disability:[])
    end
end