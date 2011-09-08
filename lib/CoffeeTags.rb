# encoding: utf-8
require "CoffeeTags/version"
require "CoffeeTags/parser"
require "CoffeeTags/formatter"

class Object
  def blank?
    if self.respond_to? :"empty?"
      self.nil? or self.empty?
    else
      self.nil?
    end
  end
end

module Coffeetags
  AUTHOR = "Łukasz Korecki /lukasz@coffeesounds.com/"
  NAME = "CoffeeTags"
  URL = "https://github.com/lukaszkorecki/CoffeeTags"
  TAGBAR_COFFEE_CONF = <<-CONF
let g:tagbar_type_coffee = {
  \ 'kinds' : [
  \   'c:class',
  \   'f:functions',
  \   'v:variables'
  \ ],
  \ 'kind2scope' : {
  \  'c' : 'namespace',
  \   'v' : 'namespace'
  \},
  \ 'sro' : ".",
  \ 'ctagsbin' : 'coffeetags',
  \ 'ctagsargs' : '',
  \}
  CONF

  class Utils

    def self.option_parser args
      puts "no args!" and return if args.empty?
      case args.first
      when /version/
        STDOUT << Coffeetags::VERSION
      when 'help'
        STDOUT << 'coffeetags [version|vim_tagbar_install] or path to a coffeescript file'
      when /vim_tagbar_install/
        puts "Add this type definition to your vimrc"
        puts Coffeetags::TAGBAR_COFFEE_CONF
      else
        self.run args
      end

    end

    def self.run files
      files.each do |file|
        sc = File.read file

        parser = Coffeetags::Parser.new sc
        parser.execute!

        formatter = Coffeetags::Formatter.new file, parser.tree

        formatter.parse_tree

        STDOUT << formatter.to_file
      end
    end
  end
end
