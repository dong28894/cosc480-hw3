class ProductsController < ApplicationController
    def index
        @products = Product.sorted_by("name")
    end

    def show
        @product = Product.find(params[:id])        
    end
end
