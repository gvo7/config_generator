require 'optparse'
require 'yaml'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: example.rb [options]"

  opts.on('-t', '--sourcename TEMPLATE', 'Template') { |v| options[:template] = v }
  opts.on('-h', '--sourcehost HOSTNAME', 'Hostname') { |v| options[:hostname] = v }


end.parse!
$opt_template = options[:template]
$opt_yaml = options[:hostname]


def open_files
    f_template = $opt_template + ".template"
    f_yaml = $opt_yaml + ".yaml"
    file = File.open(f_template, "rb")
    $template = file.read
    $hash = YAML.load(File.read(f_yaml))
end


def generate_vars_cisco_asr
    $variables = Hash.new
    $variables[:hostname] = $hash['device'][0]['hostname']
    $variables[:serialnumber] = $hash['device'][0]['serialnumber']
    $variables[:assettag] = $hash['device'][0]['assettag']
    $variables[:mgmtinterface] = $hash['device'][0]['mgmt'][0]['interface']
end

def generate_vars_juniper_bgp
    puts "nothing to do"
end

case $opt_template
when "cisco-asr"
    open_files()
    generate_vars_cisco_asr()
    vars_generated = true
when "juniper-bgp"
    open_files()
    generate_vars_juniper_bgp()
    vars_generated = true
else
  abort "You gave me #{options[:template]} as template option -- I have no idea what to do with that."
end


if vars_generated == true
    puts $template % $variables
else
    puts "no variables generated"
end