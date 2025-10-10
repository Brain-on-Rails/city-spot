class PlaceUploadToken < ApplicationRecord
  has_secure_token :token, length: 32

  validate :validate_token

  def increase_uploads_counter
    self.increment!(:uploads_count)
  end

  def max_uploads=(value)
    if persisted?
      raise ActiveRecord::ReadOnlyRecord, "max_uploads is read-only"
    else
      super
    end
  end

  private

  def validate_token
    errors.add(:base, "token is expired") if is_expired?
    errors.add(:base, "max uploads reached") if reached_max_uploads?
  end

  def is_expired?
    expires_at < Time.now
  end

  def reached_max_uploads?
    uploads_count >= max_uploads
  end

end
