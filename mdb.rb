require 'mongo'

$client=Mongo::Client.new([$config[:dbaddress]], :database=> $config[:dbname]);
