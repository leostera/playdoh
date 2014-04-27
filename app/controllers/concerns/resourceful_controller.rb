module ResourcefulController

  extend ActiveSupport::Concern

  module ClassMethods

    def additional_collection
      @additional_collection ||= []
    end

  end

  def permitted_attrs
    []
  end

  def resource_params
    params.require(resource_name).permit(*permitted_attrs)
  end

  def controller_model
    @controller_model ||= controller_name.classify.constantize
  end

  def collection
    controller_model.all
  end
  
  def new_resource
    instance_variable_set(:"@#{resource_name}",
      controller_model.new(resource_params))
  end

  def find_resource
    instance_variable_set(:"@#{resource_name}",
      controller_model.find(params[:id]))
  end

  def index
    respond_with collection
  end

  def show  
    respond_with find_resource
  end

  def create
    resource = new_resource
    resource.save
    respond_with resource
  end

  def update
    resource = find_resource
    resource.update_attributes(resource_params)
    respond_with resource
  end

  def destroy
    resource = find_resource
    resource.destroy
    respond_with resource
  end

  def resource_name
    controller_name.singularize
  end

end
