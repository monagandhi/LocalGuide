# Adds a method to write ActionMailer test deliveries to disk
module ActionMailerDeliveriesToDisk
  # Write deliveries to disk
  def self.write!
    ActionMailer::Base.deliveries.each do |mail|
      clean_subject = mail.subject.gsub(/\W+/, '_')
      emails_path = File.join(Rails.root, 'tmp', 'emails')
      if !File.exists?(emails_path)
        Dir.mkdir(emails_path)
      end
      filename = File.join(emails_path, "#{Time.now.to_i}_#{mail.to}_#{clean_subject}.html")
      File.open(filename, 'w') do |f|
        # Image links don't work in dev
        body = mail.body.to_s.gsub(%r{http:///}, %{http://localhost.airbnb.com:3000/})
        f.write(body)
      end
      @last_write = filename
    end
    ActionMailer::Base.deliveries.clear
    return @last_write
  end
end
