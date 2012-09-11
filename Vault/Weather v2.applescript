-- Written Wednesday September 5 2012 by Rob Wells

tell application "Finder"
	set weather_file to ((the POSIX path of (path to desktop)) & (weekday of (current date)) & "_weather.txt") -- Sets a location & file name to be used in the next line.
	do shell script "curl -L http://path/to/weather-app.php -o " & weather_file -- Saves the output of Jack�s PHP weather app to weather_file
end tell

tell application "TextWrangler"
	open weather_file
	
	replace "intervals" using "spells" searching in text 1 of text document 1 options {search mode:literal, starting at top:true}
	
	my conditionSearch("Aberdeen") -- Runs the conditionSearch handler at the bottom of the file, looking for Aberdeen�s weather condition
	set Aberdeen_condition to the grep substitution of "\\1" -- Saves the result to a variable, to be used by InDesign later
	my temperatureSearch("Aberdeen") -- Runs the temperatureSearch handler at the bottom of the file, looking for Aberdeen�s maximum temperature
	set Aberdeen_temperature to ("max " & (grep substitution of "\\1")) -- Saves the result to a variable, to be used by InDesign later
	
	my conditionSearch("Birmingham")
	set Birmingham_condition to the grep substitution of "\\1"
	my temperatureSearch("Birmingham")
	set Birmingham_temperature to ("max " & (grep substitution of "\\1"))
	
	my conditionSearch("Cardiff")
	set Cardiff_condition to the grep substitution of "\\1"
	my temperatureSearch("Cardiff")
	set Cardiff_temperature to ("max " & (grep substitution of "\\1"))
	
	my conditionSearch("Edinburgh")
	set Edinburgh_condition to the grep substitution of "\\1"
	my temperatureSearch("Edinburgh")
	set Edinburgh_temperature to ("max " & (grep substitution of "\\1"))
	
	my conditionSearch("Glasgow")
	set Glasgow_condition to the grep substitution of "\\1"
	my temperatureSearch("Glasgow")
	set Glasgow_temperature to ("max " & (grep substitution of "\\1"))
	
	my conditionSearch("Liverpool")
	set Liverpool_condition to the grep substitution of "\\1"
	my temperatureSearch("Liverpool")
	set Liverpool_temperature to ("max " & (grep substitution of "\\1"))
	
	my conditionSearch("London")
	set London_condition to the grep substitution of "\\1"
	my temperatureSearch("London")
	set London_temperature to ("max " & (grep substitution of "\\1"))
	
	my conditionSearch("Manchester")
	set Manchester_condition to the grep substitution of "\\1"
	my temperatureSearch("Manchester")
	set Manchester_temperature to ("max " & (grep substitution of "\\1"))
	
	my conditionSearch("Newcastle upon Tyne")
	set Newcastle_condition to the grep substitution of "\\1"
	my temperatureSearch("Newcastle upon Tyne")
	set Newcastle_temperature to ("max " & (grep substitution of "\\1"))
	
	my conditionSearch("Norwich")
	set Norwich_condition to the grep substitution of "\\1"
	my temperatureSearch("Norwich")
	set Norwich_temperature to ("max " & (grep substitution of "\\1"))
	
	my conditionSearch("Plymouth")
	set Plymouth_condition to the grep substitution of "\\1"
	my temperatureSearch("Plymouth")
	set Plymouth_temperature to ("max " & (grep substitution of "\\1"))
	
	my conditionSearch("Sheffield")
	set Sheffield_condition to the grep substitution of "\\1"
	my temperatureSearch("Sheffield")
	set Sheffield_temperature to ("max " & (grep substitution of "\\1"))
	
	my conditionSearch("Southampton")
	set Southampton_condition to the grep substitution of "\\1"
	my temperatureSearch("Southampton")
	set Southampton_temperature to ("max " & (grep substitution of "\\1"))
	
	close the front document saving no
end tell


do shell script "rm -f " & weather_file -- Deletes the text file we�ve been using


tell application "Adobe InDesign CS5.5"
	tell the front document
		set locked of layer "Furniture" to false -- Unlocks the Furniture layer so we can edit the text frames
		override group "Weather" of master spread "Feat-12-13" destination page page 2 -- Overrides the weather text frame group
		ungroup group "Weather" of page 2 -- And then ungroups the frames, so we can address each one individually
		
		set the contents of text frame "Aberdeen_condition" to Aberdeen_condition
		set the contents of text frame "Aberdeen_temperature" to Aberdeen_temperature
		set the contents of text frame "Birmingham_condition" to Birmingham_condition
		set the contents of text frame "Birmingham_temperature" to Birmingham_temperature
		set the contents of text frame "Cardiff_condition" to Cardiff_condition
		set the contents of text frame "Cardiff_temperature" to Cardiff_temperature
		set the contents of text frame "Edinburgh_condition" to Edinburgh_condition
		set the contents of text frame "Edinburgh_temperature" to Edinburgh_temperature
		set the contents of text frame "Glasgow_condition" to Glasgow_condition
		set the contents of text frame "Glasgow_temperature" to Glasgow_temperature
		set the contents of text frame "Liverpool_condition" to Liverpool_condition
		set the contents of text frame "Liverpool_temperature" to Liverpool_temperature
		set the contents of text frame "London_condition" to London_condition
		set the contents of text frame "London_temperature" to London_temperature
		set the contents of text frame "Manchester_condition" to Manchester_condition
		set the contents of text frame "Manchester_temperature" to Manchester_temperature
		set the contents of text frame "Newcastle_condition" to Newcastle_condition
		set the contents of text frame "Newcastle_temperature" to Newcastle_temperature
		set the contents of text frame "Norwich_condition" to Norwich_condition
		set the contents of text frame "Norwich_temperature" to Norwich_temperature
		set the contents of text frame "Plymouth_condition" to Plymouth_condition
		set the contents of text frame "Plymouth_temperature" to Plymouth_temperature
		set the contents of text frame "Sheffield_condition" to Sheffield_condition
		set the contents of text frame "Sheffield_temperature" to Sheffield_temperature
		set the contents of text frame "Southampton_condition" to Southampton_condition
		set the contents of text frame "Southampton_temperature" to Southampton_temperature
		
		set locked of layer "Furniture" to true -- Locks Furniture again, so it won�t get accidentally disturbed when people are working on the page
	end tell
end tell



-- Handlers beneath this line --

-- This runs a grep search using the city name provided in the brackets and a pattern to match and pick out the condition, to be fetched with "grep substitution of "\\1"
on conditionSearch(cityName)
	tell application "TextWrangler"
		find cityName & "_condition=(.+);" searching in text 1 of text document 1 options {search mode:grep, starting at top:true, case sensitive:false} without selecting match
	end tell
end conditionSearch

-- Same as above, but for temperature.
on temperatureSearch(cityName)
	tell application "TextWrangler"
		find cityName & "_temperature=(.+);" searching in text 1 of text document 1 options {search mode:grep, starting at top:true, case sensitive:false} without selecting match
	end tell
end temperatureSearch