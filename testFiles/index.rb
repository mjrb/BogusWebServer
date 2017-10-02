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

$client[:index].update_one({:counter => "visits"}, '$inc' => {:value => 1})

#.find gives back a CollectionView so we have to unwrap it to get the value
$visits=$client[:index].find(:counter=>"visits").to_a[0][:value].to_i


view "index.html"
