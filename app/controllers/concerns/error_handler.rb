module ErrorHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordInvalid do |e|
      render_error(422, e.record.errors)
    end

    rescue_from ActiveRecord::RecordNotFound do |e|
      render_error(404, e.message)
    end
  end

  private

  def render_error(code, message)
    render json: { error: message }, status: code
  end
end
