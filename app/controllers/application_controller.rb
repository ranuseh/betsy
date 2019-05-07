class ApplicationController < ActionController::Base
  before_action :require_login
  before_action :current_user
  def render_404
    # DPR: this will actually render a 404 page in production
    raise ActionController::RoutingError, 'Not Found'
  end

  def current_user
    @current_user ||= Merchant.find_by(id: session[:merchant_id]) if session[:merchant_id]
  end

  # find if there is a cart
  def order
    @order ||= Order.find_by(id: session[:order_id]) if session[:order_id]
  end

  def require_login
    if current_user.nil?
      flash[:error] = 'You must be logged in to view this section'
      redirect_to root_path
    end
  end
end
