class Definition
  attr_reader :filename

  def initialize lines
    @lines = lines
    process
  end

  def process
    @attrs = {}
    @attrs['title'] = @lines.shift.strip[2..-1].strip
    @lines.map! { |l| l.strip }.delete_if { |s| s == '' }
    @attrs['meaning'] = @lines.shift.gsub(/\r\n?/, 'foo')
    @attrs['usage'] = @lines.shift
    @attrs['usage'] = @attrs['usage'][1..-2] if @attrs['usage']
    @attrs['usage'] = 'NONE' unless @attrs['usage']

    @filename = @attrs['title'].split(';')[0].downcase.gsub ' ', '-'
  end

  def [] key
    @attrs[key]
  end

  def to_s
    s = '---'
    s << "\n"
    s << self['title']
    s << "\n"
    s << self['meaning']
    s << "\n"
    s << self['usage']
    s << "\n"
    s << "\n"
  end

  def to_yaml
    @attrs.delete 'usage' if @attrs['usage'] == 'NONE'
    require 'YAML'
    @attrs.to_yaml
  end

  def write
    File.open "definitions/#{@filename}.html", "w" do |f|
      f.write to_yaml
      f.write '---'
    end
  end
end

lines = File.readlines 'defs.md'

defs = []

temp = []

lines.each_with_index do |line, i|
  unless i == lines.count - 1
    if lines[i+1][0..1] == '##'
      temp << line
      defs << Definition.new(temp)
      temp = []
    else
      temp << line
    end
  end
end

defs.each do |d|
  d.write
end
