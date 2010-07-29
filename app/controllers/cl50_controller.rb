class Cl50Controller < ApplicationController
  def index
    @cl50 = Cl50.find_all
  end

  def show
    @cl50 = Cl50.find_by_id(params[:id])
  end
end