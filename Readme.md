# Weatherman

An AppleScript that calls the Met Office daily forecast API, strips out certain data, and then places it into an Adobe InDesign document.

It is specifically designed to provide a simple weather forecast for [a newspaper][mstar]. As is, the script calls for tomorrow’s weather data, pulls out the temperature and average conditions, and places it into specific, named text frames in InDesign. If tomorrow is Saturday then it will also fetch, process and set the weather information for Sunday. For a weekday it takes between 5-10 seconds from start to finish, and 10-20 seconds for Saturday & Sunday. (Most of this time is spent waiting for API responses.)

[mstar]:	http://www.morningstaronline.co.uk

## What you’ll need

*	**A Met Office API key**  
	Visit the [Met Office DataPoint][met] site and sign up for an account. Once you’ve done that you need to register (seemingly *again*) for DataPoint access. You’ll see a 36-character “application key” on [your account page][metacc] if you’ve done it right.
*	**TextWrangler or BBEdit**  
	For the great grep tools they expose through AppleScript. The script is set for TextWrangler but just do a find & replace if you use BBEdit instead. (It works fine.)
*	**An InDesign document with labelled frames**  
	Or named frames, for CS5 or later. As is, the script is looking for `cityName_temperature` and `cityName_condition`. The full names are set dynamically in the script using the `name` property of each `newCity(cityName,cityLocation)` you create, where `cityName` is the front part of the InDesign frame label and `cityLocation` is the Met Office’s location code.

[met]:	http://www.metoffice.gov.uk/datapoint
[metacc]:	https://logon.metoffice.gov.uk/Login

## What to change

*	Set the `APIkey` variable on line 22 to your own key.
*	The `override` block (lines 57-66) to reference your own
	master pages, or just remove it outright if you’re not using masters.
*	The calls to the `newCity` handler (lines 31-43), using
	whatever locations you want to get the forecasts for. See the [Met Office daily forecast API page][daily] to see how to call the location list that includes the 6-digit location codes.
*	The `callAPI` handler. There’s a lot going on in there,
	and it’s specific to the script’s original purpose of getting the maximum temperature and average conditions. This determines (a) the API calls, (b) the data pulled out of the API response and (c) the (slightly) custom condition names (see the `weatherTypes` list on line 25.) You’ll likely need to change any or all of these.  
	*Special note:* If changing the API call, or if you want a different part of the response, note that lines 154 and 176 do more than just call the URL. The shell script also pretty-prints the response, which then allows an initial grep to isolate the desired line.
	
[daily]:	http://www.metoffice.gov.uk/datapoint/product/uk-daily-site-specific-forecast

### Be careful with `make_dateString()`

Specifically, removing (or breaking) the code to add leading zeroes will cause the API call to fail January through September.

### Testing advice

To keep things quick while testing, grab and set a variable to a typical API response that you want to process (see lines 155 and 177 for how I was doing this) and comment out the `do shell script` line. All the processing and setting work can be done in second or two, while each call to a Met Office URL takes anywhere from a third of a second to a whole one.

## What happened to the web scraper version?

It’s sitting in [`Vault/v4`][v4], in case anyone wants to use that method instead. I’d recommend against it because it (a) relies on the BBC not changing their website’s weather pages and (b) requires you to have something to host & run the PHP scraper, even if it is Apache on your local machine. Thanks to [Jack Carr][] for providing the scraper's PHP source.

[v4]:	https://github.com/robjwells/weatherman/tree/master/Vault/v4
[Jack Carr]:	http://twitter.com/funprofessional

## Licence
You can do what you like with the AppleScript. Have fun, and drop me a line on GitHub if it helps you out.

The Met Office have their own restrictions on [how you use the data][metdata] and [their API][metterms].

[metdata]:	http://www.metoffice.gov.uk/datapoint/support/terms-conditions
[metterms]:	http://www.metoffice.gov.uk/about-us/legal/fair-usage