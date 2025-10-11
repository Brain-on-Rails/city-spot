class UploadsController < ApplicationController

  before_action :validate_and_set_token, only: [ :create ]
  before_action :ensure_file_is_present, only: [ :create ]
  before_action :accept_only_image_uploads, only: [ :create ]
  before_action :ensure_file_size_is_not_too_big, only: [ :create ]
  def create
    blob = ActiveStorage::Blob.create_and_upload!(
      io: params[:file],
      filename: params[:file]&.original_filename,
      content_type: params[:file]&.content_type
    )


    render json: {
      signed_id: blob.signed_id,
      url: url_for(blob),
      filename: blob.filename,
      content_type: blob.content_type,
      byte_size: blob.byte_size,
      width: blob.metadata[:width],
      height: blob.metadata[:height]
    }, status: :created
  end

  private

  def validate_and_set_token
    token = PlaceUploadToken.find_by(token: params[:token])
    unless token
      return render json: { errors: ["invalid token"] }, status: :unauthorized
    end
    token.with_lock do
      unless token.valid?
        return render json: { errors: token.errors.full_messages }, status: :unauthorized
      end
      token.increase_uploads_counter!
    end
    @token = token
  end

  def ensure_file_size_is_not_too_big
    head :unprocessable_entity if params[:file].size > 5.megabytes
  end

  def accept_only_image_uploads
    head :unprocessable_entity unless params[:file].content_type.start_with?('image/')
  end

  def ensure_file_is_present
    head :unprocessable_entity unless params[:file].present?
  end
end
