# Weatherman

A short little script to take the output from a web scraper, grep bits of information and then put it in the right place in an InDesign document.

In this case it’s pulling tomorrow’s weather forecasts for several British cities but there are a bunch of situations where you could use it.

## Instructions
Assuming no changes to the code (hi Star people!):

1. Download Weather.app and put it somewhere safe (/Applications is fine).
2. In InDesign, open the page you need to put tomorrow’s weather forecasts on.
3. Run Weather.app
4. Wait about 10 seconds.
5. Get on with your day.

## Can I use this with {x,y,z}?
Sure! Just please don’t use our .php scraper, both out of courtesy and because it’ll be unreliable for whatever you’re doing.

### Changing the code
There are a couple of things that are Morning Star specific.

1. **The scraper**
You’ll want to change this for something that spits out a file that plays nice with BBEdit/TextWrangler. The syntax (as of 06/09/2012) is:  
	`cityName_condition=weatherCondition; `  
	`cityName_temperature=theTemperature; `  
So if your scraper puts out something different you’ll need to change the grep search in the `blaze` handler stored at the end of script.
2. **InDesign specifics**
Lines 14 & 15 exist to override master page elements from one of the Morning Star master pages, which you are almost certainly not using. The same goes for the "Weather" group and indeed the labelled text frames that the information gets placed into. All this will need to be changed to suit your particular situation.

#### Why `blaze`?
“I wonder if I can write a handler that’ll just blaze through all this stuff.”

If you’d like to get a feel for the evolution of the script, or just fancy a laugh at my expense, check out v1 and v2 of the script in the Vault folder.

### Licence
Go nuts. Seriously. Drop me a line on Github if it helps you out.

The “Cloud” symbol (`Cloud.icns`) is by Adam Whitcroft, from [The Noun Project](http://thenounproject.com). I sloppily added a stroke in Photoshop to stop it from disappearing in the Finder when used as the `.app`’s icon.