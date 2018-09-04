class CommunesController < ApplicationController

  def index
    status = params[:format] == "json" ? :ok : :not_acceptable
    render json: {}, status: status
  end

  def create
    render json: {}, status: :forbidden
  end

  def show
    @commune = Commune.find_by_code_insee(params[:id]) || {}
    status = @commune.present? ? :ok : :not_found
    render json: @commune.to_json, status: status
  end

  def update
    @commune = Commune.find_by_code_insee(params[:id]) || {}

    if @commune.present? && params["commune"].present? && @commune.update(commune_params)
      status = :no_content
    elsif @commune.present?
      status = :bad_request
    else
      status = :not_found
    end
    render json: @commune.to_json, status: status
  end

  private

  def commune_params
    params.require(:commune).permit(:name) 
  end
end
