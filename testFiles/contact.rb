$problem=""

$hasAll=($get.has_key? :message) and ($get.has_key? :title) and ($get.has_key? :email)
puts $hasAll
$allFilled=!(($get[:message]=="") or ($get[:title]=="") or ($get[:email]==""))
puts $allFilled

if $hasAll and !$allFilled
  $problem="you must enter all feilds"
end

if $hasAll and $allFilled
  $client[:messages].insert_one({:message => $get[:message], :email => $get[:email], :title => $get[:title]})
end

def messageSent
  if $hasAll and $allFilled
    return "you're message has been sent!"
  else
    return "tell us your issues"
  end
end


view "contact.html"
