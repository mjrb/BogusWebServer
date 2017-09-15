module Js
  $js="<noscript>"+$config[:noscriptMsg]+"</noscript><script>"

  def Js.reset
    $js="<noscript>"+$config[:noscriptMsg]+"</noscript><script>"
    nil
  end

  def Js.alert str
    $js+="alert(\""+str+"\");"
    nil
  end

  def Js.add str
    $js+=str
  end

  def Js.append str
    insertionPoint=(str.index "<head>")+6
    str.insert insertionPoint, ($js+"</script>")
    reset
  end
end
