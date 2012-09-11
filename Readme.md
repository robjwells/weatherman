# Weatherman

A short little script to take the output from a web scraper, grep some data and then put it in the right place in an InDesign document.

In this case it’s pulling tomorrow’s weather forecasts for several British cities but there are a bunch of situations where you could use it.

Thanks to Jack Carr for providing the .php source.

## Instructions
Assuming no changes to the code (hi Star people!):

1. Download Weather.app and put it somewhere safe (/Applications is fine).
2. In InDesign, open the page you need to put tomorrow’s weather forecasts on.
3. Run Weather.app
4. Wait about 10 seconds.
5. Get on with your day.

## Can I use this with {x,y,z}?
Sure! You’ll need somewhere to put the .php scraper if you want to use it as-is, though, and then put that address after `curl -L`.

### Changing the code
There are a couple of things in the AppleScript files that are Morning Star specific.

1. **InDesign specifics**  
Lines 14 & 15 exist to override master page elements from one of the Morning Star master pages, which you aren’t using. The same goes for the "Weather" group and indeed the labelled text frames that the information gets placed into. All this will need to be changed to suit your particular situation.
2. **The scraper**
If you want to adapt the scraper to do something slightly different, but don’t want to fiddle with the AppleScript too much, just make sure it still spits out a text file with the data arranged like this:
	`variableName_dataType=theData; `  
	`variableName_dataType=theData; `  
For anything different you’ll have to change the grep search that the `blaze` handler performs.

#### Why `blaze`?
“I wonder if I can write a handler that’ll just blaze through all this stuff.”

If you’d like to get a feel for the evolution of the script, or just fancy a laugh at my expense, check out v1 and v2 in the Vault folder.

### Licence
Go nuts. Seriously. Drop me a line on Github if it helps you out.

The “Cloud” symbol (Cloud.icns) is by Adam Whitcroft, from [The Noun Project](http://thenounproject.com). I sloppily added a stroke in Photoshop to stop it from disappearing in the Finder when used as the .app’s icon.