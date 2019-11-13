class Admin::DashboardController < ApplicationController
  def show
    @products_count = Product.count
    @category_count = Category.count
  end

end
