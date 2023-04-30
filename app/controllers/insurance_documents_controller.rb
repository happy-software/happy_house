class InsuranceDocumentsController < ApplicationController
  before_action :logged_in?
  before_action :correct_user
  before_action :set_property

  def index
    @insurance_documents = @property.insurance_documents.order(created_at: :desc)
  end

  def new
    @insurance_document = @property.insurance_documents.build
  end

  def create
    @insurance_document = @property.insurance_documents.new(insurance_document_params)
    if @insurance_document.save
      redirect_to(user_property_insurance_documents_path([@current_user, @property]), notice: "Successfully Uploaded")
    else
      render :new
    end
  end

  private

  def correct_user
    redirect_to root_url unless Property.find(params[:property_id]).user == current_user
  end

  def set_property
    @property = current_user.properties.find(params[:property_id])
  end

  def insurance_document_params
    params.require(:insurance_document).permit(:title, :document)
  end
end
