require "uri"
require "open-uri"
require "tempfile"
require "fileutils"
require "zip"

require_relative "download_error"

module RemoteZip
  class Reader
    def initialize(url)
      self.url = URI(url)
    end

    def each_file_with_path(&block)
      with_tempfile do |temp|
        temp.write(open(url).read)
        temp.flush

        extract(temp.path) do |absolute_path, zip_path|
          File.open(absolute_path) do |file|
            block.call(file, zip_path)
          end
        end
      end
    rescue OpenURI::HTTPError => e
      raise DownloadError, e
    end

    protected

    attr_accessor :url

    private

    def extract(path, &block)
      contents_dir = path + "_contents"
      FileUtils.mkdir_p(contents_dir)

      Zip::File.open(path) do |zip|
        zip.each do |entry|
          absolute_path = File.join(contents_dir, entry.name)
          FileUtils.mkdir_p(File.dirname(absolute_path))
          entry.extract(absolute_path)
          block.call(absolute_path, entry.name)
        end
      end
    ensure
      FileUtils.rm_r(contents_dir)
    end

    def with_tempfile(&block)
      temp = Tempfile.new(self.class.name)
      temp.binmode
      block.call(temp)
    ensure
      temp.close # GC will do the rest
    end
  end
end