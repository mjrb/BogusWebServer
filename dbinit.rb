load "loadConfig.rb"
load "mdb.rb"
$client[:index].insert_one({:counter => "visits", :value => 0})
$client[:users].insert_one({:name => "admin", :password => "password"})
$client[:messages].insert_one({:title => "default message", :body =>"this is a default message", :email =>"user@example.com"})
