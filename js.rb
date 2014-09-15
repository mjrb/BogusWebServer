module Js
  $js="<noscript>"+$config[:noscriptMsg]+"</noscript><script>"

  def Js.reset
    $js="<noscript>"+$config[:noscriptMsg]+"</noscript><script>"
  end

  def Js.alert str
    $js+="alert(\""+str+"\");"
    nil
  end
  
  def Js.sendCookie name, value
    $js+="document.cookie=\""+name.to_s+"="+value.to_s+"\";"
    nil
  end 
  
  def Js.sendExpireableCookie name, value, experation
    $js+="document.cookie=\""+name.to_s+"="+value.to_s+";"+experation+"\";"
    nil
  end 
  
  def Js.delCookie name
    $js+="document.cookie=\""+name+"=; expires="+ime.now.getutc+";"
    nil
  end

  def Js.getCookie name, action
    #get cookie funtion in js
    jsGetCookie="function getCookie(cname){var name = cname + \"=\";var ca=document.cookie.split(';');for(var i=0; i<ca.length; i++){var c = ca[i];while(c.charAt(0)==' ')c=c.substring(1);if(c.indexOf(name)!=-1)return c.substring(name.length,c.length);}return \"\";}"
    $js+=(jsGetCookie+"\nwindow.location=(\"#{action}?#{name}=\"+getCookie\"#{name}\");")
  end

  def Js.append str
    insertionPoint=(str.index "<head>")+6
    str.insert insertionPoint, ($js+"</script>")
    reset
  end
end
