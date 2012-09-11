-- Morning Star automatic weather

-- Written on September 6 2012 by Rob Wells

try
	launch application "TextWrangler" -- In case it’s not open
end try

set weatherFile to ((the POSIX path of (path to desktop)) & (weekday of (current date)) & "_weather.txt") -- Sets a location & file name to be used in the next line
do shell script "curl -L http://path/to/weather-app.php -o " & weatherFile -- Saves the output of Jack’s PHP weather app

tell application "Adobe InDesign CS5.5"
	tell the front document
		override group "Weather" of master spread "Feat-12-13" destination page page 2 -- Overrides the weather group so we can edit the frames
		ungroup group "Weather" of page 2 -- Ungroups the frames, so they can be accessed individually
	end tell
end tell

tell application "TextWrangler"
	open weatherFile
	
	replace "intervals" using "spells" searching in text 1 of text document 1 options {search mode:literal, starting at top:true}
	replace "Newcastle upon Tyne" using "Newcastle" searching in text 1 of text document 1 options {search mode:literal, starting at top:true}
	
	my blaze("Aberdeen") -- Finds and sets the information for Aberdeen
	my blaze("Birmingham")
	my blaze("Cardiff")
	my blaze("Edinburgh")
	my blaze("Glasgow")
	my blaze("Liverpool")
	my blaze("London")
	my blaze("Manchester")
	my blaze("Newcastle")
	my blaze("Norwich")
	my blaze("Plymouth")
	my blaze("Sheffield")
	my blaze("Southampton")
	
	close the front document saving no
end tell

do shell script "rm -f " & weatherFile -- Deletes weatherFile


(* Handler beneath this line *)

on blaze(cityName)
	set conditionBox to (cityName & "_condition") -- So we can address the text frames
	set tempBox to (cityName & "_temperature")
	
	tell application "TextWrangler"
		find cityName & "_condition=(.+);" searching in text 1 of text document 1 options {search mode:grep, starting at top:true, case sensitive:false} without selecting match -- Finds the condition for the specified city
		set theCondition to the grep substitution of "\\1" -- Sets the condition as a variable, ready to pass to InDesign
		find cityName & "_temperature=(.+);" searching in text 1 of text document 1 options {search mode:grep, starting at top:true, case sensitive:false} without selecting match -- Finds the temperature
		set theTemp to ("max " & (grep substitution of "\\1")) -- Sets the temperature as a variable, ready to pass to InDesign
	end tell
	
	tell application "Adobe InDesign CS5.5"
		tell the front document
			set the contents of text frame conditionBox to theCondition -- Puts the weather condition in the appropriate box for the specified city
			set the contents of text frame tempBox to theTemp -- Same for temperature
		end tell
	end tell
	
end blaze