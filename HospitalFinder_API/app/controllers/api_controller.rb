class ApiController < ApplicationController
  def show
    api = Api.all
    render json: api
  end
  def hospitals
    hospitals = Hospital.order("id ASC")
    hospitals = hospitals.to_json(:include => [:images, :insurances])
    render :json => hospitals
  end
  def hospitals_by_city
    hospitals = Hospital.where(city:params[:city]).order("id ASC")
    hospitals = hospitals.to_json(:include => [:images, :insurances])
    render :json => hospitals
  end
end
