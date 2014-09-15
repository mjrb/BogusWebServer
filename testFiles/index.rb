$views=getDB $dbHash, [:sites, :index, :views]
setDB $dbHash, :sites, :index, :views, $views+1

$problem=""


def greeting
  cookieName=$get.has_key? :cname
  hasBoth=($get.has_key? :name) and ($get.has_key? :surname)
  bothFilled=!(($get[:name]=="") or ($get[:surname]==""))
  Js::sendCookie "cname", $get[:name]+$get[:surname] if hasBoth and !cookieName

  if cookieName
      tmp="you are the number "+$views.to_s+" visitor"+$get[:cname]+"!"
  elsif hasBoth and bothFilled
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

content=File.read "index.html"
Processor::preprocess content
Js::append content
$session.print content
