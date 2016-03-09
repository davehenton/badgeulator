module Paperclip
  class Pdftoppm < Processor
    attr_accessor :format, :convert_options

    def initialize(file, options = {}, attachment = nil)
      super

      @convert_options     = options[:convert_options]
      @format              = options[:format] || "ppm"
      @current_format      = File.extname(@file.path)
      @basename            = File.basename(@file.path, @current_format)
    end

    def make
      src = @file
      filename = @basename
      dst = TempfileFactory.new.generate(filename)

      begin
        parameters = []
        parameters << ":source"
        parameters << "-r 300 -singlefile"
        parameters << convert_options
        parameters << ":dest"
        parameters = parameters.flatten.compact.join(" ").strip.squeeze(" ")

        success = pdftoppm(parameters, :source => "#{File.expand_path(src.path)}", :dest => "#{File.expand_path(dst.path)}")
      rescue Cocaine::ExitStatusError => e
        raise Paperclip::Error, "There was an error processing the pdftoppm conversion for #{@basename}"
      rescue Cocaine::CommandNotFoundError => e
        raise Paperclip::Errors::CommandNotFoundError.new("Could not run the `pdftoppm` command. Please install it.")
      end

      dst = File.open("#{File.expand_path(dst.path)}.#{@format}", "rb")
    end

    # The convert method runs the convert binary with the provided arguments.
    # See Paperclip.run for the available options.
    def pdftoppm(arguments = "", local_options = {})
      Paperclip.run('pdftoppm', arguments, local_options)
    end    
  end
end
