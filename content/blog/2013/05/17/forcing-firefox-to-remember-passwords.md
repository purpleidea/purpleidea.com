+++
date = "2013-05-17 07:39:06"
title = "Forcing firefox to remember passwords"
draft = "false"
categories = ["technical"]
tags = ["autocomplete", "bookmarklet", "dangerous", "firefox", "hack", "pgo", "save passwords"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2013/05/17/forcing-firefox-to-remember-passwords/"
+++

There are a handful of websites out there that decide that they know better than your browser and tell it to not offer to save passwords. They do this by setting a form autocomplete attribute to <em>off</em>.

Since we already agree that <a href="https://github.com/tomerfiliba/rpyc/tree/master/demos/web8">HTML and the web are a terrible idea</a>, hopefully we can find a way to hack around this. It turns out that I didn't have to, because many others have solved this hack before me. The cleanest version I found is here: <a href="http://www.howtogeek.com/62980/how-to-force-your-browser-to-remember-passwords/">http://www.howtogeek.com/62980/how-to-force-your-browser-to-remember-passwords/</a>

It's not that complicated actually, a little bookmarklet (javascript code, stored in a bookmark, and activated when you open it) is saved in your browser, and on activation, it loops through all the page's forms and turns <em>on</em> the autocomplete <em>off</em>'s.

I've copied the code here, in the interests of archiving this very useful hack. Here you go:

<strong><span style="text-decoration:underline;">Shortened form</span>:</strong>
{{< highlight javascript >}}
javascript:(function(){var%20ac,c,f,fa,fe,fea,x,y,z;ac="autocomplete";c=0;f=document.forms;for(x=0;x<f.length;x++){fa=f[x].attributes;for(y=0;y<fa.length;y++){if(fa[y].name.toLowerCase()==ac){fa[y].value="on";c++;}}fe=f[x].elements;for(y=0;y<fe.length;y++){fea=fe[y].attributes;for(z=0;z<fea.length;z++){if(fea[z].name.toLowerCase()==ac){fea[z].value="on";c++;}}}}alert("Enabled%20'"+ac+"'%20on%20"+c+"%20objects.");})();
{{< /highlight >}}
<strong><span style="text-decoration:underline;">Long form</span>:</strong>
{{< highlight javascript >}}
function() {
   var ac, c, f, fa, fe, fea, x, y, z;
   //ac = autocomplete constant (attribute to search for)
   //c = count of the number of times the autocomplete constant was found
   //f = all forms on the current page
   //fa = attibutes in the current form
   //fe = elements in the current form
   //fea = attibutes in the current form element
   //x,y,z = loop variables

   ac = "autocomplete";
   c = 0;
   f = document.forms;

   //cycle through each form
   for(x = 0; x < f.length; x++) {
      fa = f[x].attributes;
      //cycle through each attribute in the form
      for(y = 0; y < fa.length; y++) {
         //check for autocomplete in the form attribute
         if(fa[y].name.toLowerCase() == ac) {
            fa[y].value = "on";
            c++;
         }
      }

      fe = f[x].elements;
      //cycle through each element in the form
      for(y = 0; y < fe.length; y++) {
         fea = fe[y].attributes;
         //cycle through each attribute in the element
         for(z = 0; z < fea.length; z++) {
            //check for autocomplete in the element attribute
            if(fea[z].name.toLowerCase() == ac) {
               fea[z].value = "on";
               c++;
            }
         }
      }
   }

   alert("Enabled '" + ac + "' on " + c + " objects.");
}
{{< /highlight >}}
Happy hacking,

James

PS: Best friends forever if you can get firefox to natively integrate with the gnome-keyring. No I don't want to force it to myself, get this code merged upstream please!

