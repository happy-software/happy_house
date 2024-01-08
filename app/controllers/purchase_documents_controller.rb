class PurchaseDocumentsController < ApplicationController
  before_action :logged_in?
  before_action :correct_user
  before_action :set_property

  def index
    @purchase_documents = @property.purchase_documents.order(created_at: :desc)
  end

  def new
    @purchase_document = @property.purchase_documents.build
  end

  def create
    @purchase_document = @property.purchase_documents.new(purchase_document_params)
    if @purchase_document.save
      redirect_to(user_property_purchase_documents_path([@current_user, @property]), notice: "Successfully Uploaded")
    else
      render :new
    end
  end

  def show
    @purchase_document = @property.purchase_documents.find(params[:id])
  end

  def edit
    @purchase_document = @property.purchase_documents.find(params[:id])
  end

  def update
    @purchase_document = @property.purchase_documents.find(params[:id])
    if @purchase_document.update(purchase_document_params)
      redirect_to [@current_user, @property, @purchase_document], notice: "Document details updated successfully."
    else
      render :edit
    end
  end

  private

  def correct_user
    redirect_to root_url unless Property.find(params[:property_id]).user == current_user
  end

  def set_property
    @property = current_user.properties.find(params[:property_id])
  end

  def purchase_document_params
    params.require(:purchase_document).permit(:title, :document, :notes)
  end
end
