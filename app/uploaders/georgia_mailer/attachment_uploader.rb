# encoding: utf-8
module GeorgiaMailer
  class AttachmentUploader < CarrierWave::Uploader::Base

    storage :fog

    def store_dir
      "/attachments/#{model.id}"
    end

    def extension_white_list
      ["doc", "docx", "xls", "odt", "ods", "pdf", "rar", "zip", "tar", "tar.gz"]
    end

  end
end