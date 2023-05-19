module ErrorHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
    rescue_from ActiveRecord::NotNullViolation, with: :database_violation
    rescue_from ActiveRecord::RecordNotDestroyed, with: :record_not_destroyed
    rescue_from CustomError::Unauthorized, with: :unauthorized
    rescue_from CustomError::CredentialInvalid, with: :credential_invalid
    rescue_from JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError, JWT::InvalidIssuerError,
                with: :jwt_invalid
    # rescue_from StandardError, with: :standard_error
  end

  class CustomStandardError
    attr_reader :title, :details, :status

    def initialize(title:, details:, status:)
      @title = title || 'Something went wrong'
      @details = details || ['There were an error while processing your request, our development team has been notificated!']
      @status = status || 500
    end
  end

  # private

  def record_not_found(err)
    @error = CustomStandardError.new(
      title: 'Not found error',
      details: [err.to_s],
      status: 404
    )
    render 'errors/error', status: @error.status
  end

  def record_invalid(err)
    @error = CustomStandardError.new(
      title: 'Invalid Record',
      details: err.record.errors.to_a,
      status: 422
    )
    render 'errors/error', status: @error.status
  end

  def database_violation(err)
    @error = CustomStandardError.new(
      title: 'Database violation',
      details: err.to_s,
      status: 422
    )
    render 'errors/error', status: @error.status
  end

  def record_not_destroyed(err)
    @error = CustomStandardError.new(
      title: 'Record not destroyed',
      details: [err.to_s],
      status: 422
    )
    render 'errors/error', status: @error.status
  end

  def unauthorized(err)
    @error = CustomStandardError.new(
      title: 'Unauthorized',
      details: [err.to_s],
      status: 401
    )
    render 'errors/error', status: @error.status
  end

  def credential_invalid(err)
    @error = CustomStandardError.new(
      title: 'Invalid credentials',
      details: [err.to_s],
      status: 401
    )
    render 'errors/error', status: @error.status
  end

  def jwt_invalid(err)
    @error = CustomStandardError.new(
      title: 'Invalid JWT',
      details: [err.to_s],
      status: 401
    )
    render 'errors/error', status: @error.status
  end
end
