
RSpec.configure do |config|
  config.after(:each, type: :system) do
    FileUtils.rm_rf(ActiveStorage::Blob.service.root)
  end
end
