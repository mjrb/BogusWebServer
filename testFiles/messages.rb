$problem=""

$hasPwd=$get.has_key? :pwd
$pwdFilled=$get[:pwd]!=""

if $hasPwd
  pwd=$client[:users].find_one({:name => "admin"}).first[:password]
  $goodPwd=pwd==$get[:pwd]
end

if (!$hasPwd or !$pwdFilled)
  $problem="please enter pasword"
elsif 
  
end

def render message
  result="<hr>"
  result+="<h3>"+message[:email]+"</h3>"
  result+="from user: "+message[:email]
end
def messages
  if 
end
view "messages.html"
