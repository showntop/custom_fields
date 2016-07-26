require 'carrierwave/mongoid'

module CarrierWave

  module MountUploaderWithLocalization
    def mount_uploader_with_localization(column, uploader=nil, options={}, &block)
      mount_uploader_without_localization(column, uploader, options, &block)

      define_method(:read_uploader) do |name|
        # puts "read_uploader #{name} / #{read_attribute(name.to_sym).inspect}" # DEBUG

        value = read_attribute(name.to_sym)
        unless value.nil?
          self.class.fields[name.to_s].demongoize(value)
        else
          nil
        end
      end
    end
  end

  module Mongoid
    prepend MountUploaderWithLocalization
  end

end
