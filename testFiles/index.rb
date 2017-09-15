$views=getDB $dbHash, [:sites, :index, :views]
setDB $dbHash, :sites, :index, :views, $views+1

$problem=""


def greeting
  hasBoth=($get.has_key? :name) and ($get.has_key? :surname)
  bothFilled=!(($get[:name]=="") or ($get[:surname]==""))

  if hasBoth and bothFilled
    tmp="you are the number "+$views.to_s+" visitor, "+$get[:name]+" "+$get[:surname]+"!"
  elsif $get==Hash.new
    tmp="you are the number "+$views.to_s+" visitor!"
  elsif hasBoth and !bothFilled
    $problem="you didnt enter full name"
    tmp="you are the number "+$views.to_s+" visitor!"
  end
  tmp
end


def problem
  $problem
end

content=File.read $config[:root]+"/"+"index.html"
Processor::preprocess content
Js::append content
$session.print content
