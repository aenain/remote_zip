# RemoteZip

Iterate over extracted files from a downloaded zip file without a hassle.

Do you want to fetch remote zip file and extract its content? Do you want to use files from the zip as assets for Carrierwave? Do you want to be able to process extracted files from more than one zip at a time? Zip is written to a tempfile and its content to a directory named after the tempfile, so it stays unique.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'remote_zip'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install remote_zip

## Usage

Let's say that we want to incorporate Android resources from an assets generator:

```ruby
source = RemoteZip::Reader.new("http://assets-generator.com/android/res.zip")
source.each_file_with_path do |file, path|
  # path is a path to the file in the zip, i.e. drawable-xxhdpi/ic_launcher.png
  variant = ImageVariant.find_by!(path: path)
  variant.update(image: file) # using Carrierwave uploader
end
```

Open file and its logical path in zip are yielded.

In case of download problems, `RemoteZip::DownloadError` is raised. 

## Contributing

1. Fork it ( https://github.com/aenain/remote_zip/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
