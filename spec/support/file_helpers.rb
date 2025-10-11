module FileHelpers
  TMP_DIR = Rails.root.join("tmp/capybara_uploads")

  def with_temp_image(size_in_mb: 1, filename: "test.jpg", content_type: "image/jpeg")
    FileUtils.mkdir_p(TMP_DIR)
    path = TMP_DIR.join(filename)

    File.open(path, "wb") do |file|
      file.write("a" * size_in_mb.megabytes)
    end

    yield(path.to_s, filename, content_type)
  ensure
    File.delete(path) if File.exist?(path)
  end

  def with_temp_images(count: 1, size_in_mb: 1, filename: "test", extension: ".jpg", content_type: "image/jpeg")
    FileUtils.mkdir_p(TMP_DIR)
    paths = count.times.map do |i|
      filename = "#{filename}_#{i}#{extension}"
      path = TMP_DIR.join("#{filename}")
      File.open(path, "wb") do |file|
        file.write("a" * size_in_mb.megabytes)
      end
      path.to_s
    end
    yield(paths, filename, content_type)
  ensure
    paths.each do |path|
      File.delete(path) if File.exist?(path)
    end
  end
end
