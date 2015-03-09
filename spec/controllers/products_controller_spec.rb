require 'rails_helper'

RSpec.describe ProductsController, type: :controller do

  describe "root route" do
    it "routes to products#index" do
      expect(:get => '/').to route_to(:controller => "products", :action => "index")
    end
  end

  describe "GET #index" do
    it "routes correctly" do
      get :index
      expect(response.status).to eq(200)
    end

    it "renders the index template and sorts by name by default" do
      x, y = Product.create!, Product.create!
      expect(Product).to receive(:sorted_by).with("name") { [x,y] }
      get :index
      expect(response).to render_template(:index)
      expect(assigns(:products)).to match_array([x,y])
    end
  end

  describe "GET #show" do
    it "routes correctly" do
      expect(Product).to receive(:find).with("1") { p }
      get :show, id: 1
      p = Product.new
      expect(response.status).to eq(200)
    end

    it "renders the show template" do
      expect(Product).to receive(:find).with("1") { p }
      get :show, id: 1
      expect(response).to render_template(:show)
    end
  end

  it "should redirect to new on failure" do
    p = Product.new
    Product.should_receive(:new).and_return(p)
    # expect(Product).to receive(:new) { p }
    p.should_receive(:save).and_return(nil)
    # expect(p).to receive(:save) { nil }
    post :create, { :product => { "name"=>"dummy", "price"=>"11.50" } }
    response.should redirect_to(new_product_path)
    # expect(response).to redirect_to(new_product_path)
  end
end
