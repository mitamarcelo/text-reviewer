module CustomError
  class Unauthorized < StandardError; end
  class CredentialInvalid < StandardError; end
  class AlreadySignedOut < StandardError; end
end