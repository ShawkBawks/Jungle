class Admin::DashboardController < ApplicationController
  http_basic_authenticate_with name: ENV["HTTP_ADMIN_USER"],
                             password: ENV["HTTP_ADMIN_PASSWORD"]
                             
  def show
    @products_count = Product.count
    @category_count = Category.count
  end

end
