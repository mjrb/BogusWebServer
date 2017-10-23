$problem=""

$isPwdGood=false

$hasPwd=$get.has_key? :pwd
$pwdFilled=$get[:pwd]!=""

if (!$hasPwd or !$pwdFilled)
  $problem="please enter a pasword(it has to be correct)"
elsif
  #reaaaaaaly bad security, dont try this at home
  #the pasword should be stored hashed, and esnt hased via post
  #also it should send a cookie so you dont have to log in every time
  pwd=$client[:users].find({:name => "admin"}).first[:password]
  $isPwdGood=pwd==$get[:pwd]
  if !$isPwdGood
    $problem="wrong password"
  end
end

def renderMessage message
  puts message
  result="<hr>"
  result+="<h3>"+message["title"]+"</h3>"
  result+="from user: "+message["email"]+"<br>"
  result+="<p>"+message["message"]+"</p>"
  result
end

def messages
  tmp=""
  if $isPwdGood
    messages=$client[:messages].find.to_a
    messages.each do |message|
      tmp+=renderMessage message
    end
  end
  tmp
end
view "messages.html"
