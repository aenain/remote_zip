require "spec_helper"
require "remote_zip/reader"

RSpec.describe RemoteZip::Reader, type: :model do
  describe "#each_file_with_path" do
    context "when downloaded successfully" do
      let(:url) { "http://example.com/remote.zip" }
      let(:zip_path) { spec_dir.join("fixtures", "res.zip") }

      before(:each) do
        stub_request(:get, url)
          .to_return(body: File.new(zip_path), status: 200)
      end

      it "yields open files" do
        described_class.new(url).each_file_with_path do |file, _|
          expect(file).to_not be_closed
        end
      end

      it "yields logical paths for entries" do
        paths = []

        described_class.new(url).each_file_with_path do |_, path|
          paths << path
        end

        expect(paths).to include "drawable-xxhdpi/action_bar_solid.9.png"
      end

      it "cleans up after itself" do
        paths = []

        described_class.new(url).each_file_with_path do |file, _|
          paths << file.to_path
        end

        paths.each do |path|
          expect(File.exist?(path)).to be_falsy, "File not removed: #{path}"
        end
      end
    end

    context "with download error" do
      let(:url) { "http://example.com/not-found.zip" }

      before(:each) do
        stub_request(:get, url)
          .to_return(status: 500)
      end

      it "raises DownloadError" do
        expect {
          described_class.new(url).each_file_with_path {}
        }.to raise_error(RemoteZip::DownloadError)
      end
    end
  end
end