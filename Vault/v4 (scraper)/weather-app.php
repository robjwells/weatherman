<?php

/* BBC weather scraper by Jack Carr
jacksonpoo@gmail.com
twitter.com/funprofessional
Open source, use as you please.
NB. This relies on the Simple HTML DOM parser, which can be found at http://simplehtmldom.sourceforge.net/
*/


error_reporting(E_ALL);

if (!isset ($_GET['day']))
	{
	$day = 'B';
	}
else	{
	$day = $_GET['day'];
	}

function fetchsummaries ($day)
{
$cities = array (
0	=>	("http://www.bbc.co.uk/weather/2657832"), /*aberdeen*/
1	=>	("http://www.bbc.co.uk/weather/2655603"), /*birmingham*/
2	=>	("http://www.bbc.co.uk/weather/2653822"), /*cardiff*/
3	=>	("http://www.bbc.co.uk/weather/2650225"), /*edinburgh*/
4	=>	("http://www.bbc.co.uk/weather/2648579"), /*glasgow*/
5	=>	("http://www.bbc.co.uk/weather/2644210"), /*liverpool*/
6 	=>	("http://www.bbc.co.uk/weather/2643743"), /*london*/
7	=>	("http://www.bbc.co.uk/weather/2643123"), /*manchester*/
8	=>	("http://www.bbc.co.uk/weather/2641673"), /*newcastle*/
9	=>	("http://www.bbc.co.uk/weather/2641181"), /*norwich*/
10	=>	("http://www.bbc.co.uk/weather/2640194"), /*plymouth*/
11	=>	("http://www.bbc.co.uk/weather/2638077"), /*sheffield*/
12	=>	("http://www.bbc.co.uk/weather/2637487"), /*southampton*/
);



include ("simple_html_dom.php");

$output = "";

for ($i=0; $i<=count($cities)-1; $i++)
	{
	
	$file = $cities[$i];
	$content = file_get_contents ($file);
	$html = file_get_html($file);

	// Find city name 
	foreach ($html->find('span[class=location-name]') as $title)
		{
		$city = $title->title;
		
			$spaces = array ("  ","   ","    ","     ","      ","      ","       ","        ","    ");
//			$city = str_replace ("intervals","spells",$city);
			$city = str_replace ($spaces," ",$city);
			$city = str_replace (" upon Tyne","",$city);
			
			$output .= $city . "_condition=";
		}
	

	// Find weather conditions (Rain, cloudy, etc.)
	$x=0;
	$weatheroutput = array();
	
	foreach ($html->find('span[class=weather-type-image] img') as $weathertype)
	{
		if ($x==2)
			{
			$weathertypestring = $weathertype->alt;	
			$weathertypestring = str_replace ("intervals","spells",$weathertypestring);
			$weathertypestring = str_replace ("White Cloud","cloudy",$weathertypestring);
			$weathertypestring = str_replace ("Grey Cloud","cloudy",$weathertypestring);			
			$weathertypestring = ucfirst(strtolower($weathertypestring));	
			$output .= $weathertypestring . "; \n";
			}
	$x++;
	}

	// Find temperature
	$y=0;
	foreach ($html->find('span[class=units-value temperature-value temperature-value-unit-c]') as $temperature)
	{
		if ($y==2)
			{
			$temperaturestring = "max " . $temperature->plaintext;
			$output .= $city . "_temperature=" . strip_tags ($temperature) . "; \n";
			}
	$y++;
	}	

}

//echo $output;

/* Force the file to be downloaded as a plain text file */
$file = "weather";
header("Cache-Control: public");
header("Content-Description: File Transfer");
header("Content-Disposition: attachment; filename=$file");
header("Content-Type: text/plain");
header("Content-Transfer-Encoding: binary");

// Read the file from disk
readfile($file);

}

/* Backup of cities array for faster parsing when debugging */
$cities = array (
0	=>	("http://www.bbc.co.uk/weather/2657832"), /*aberdeen*/
1	=>	("http://www.bbc.co.uk/weather/2655603"), /*birmingham*/
2	=>	("http://www.bbc.co.uk/weather/2653822"), /*cardiff*/
3	=>	("http://www.bbc.co.uk/weather/2650225"), /*edinburgh*/
4	=>	("http://www.bbc.co.uk/weather/2648579"), /*glasgow*/
5	=>	("http://www.bbc.co.uk/weather/2644210"), /*liverpool*/
6 	=>	("http://www.bbc.co.uk/weather/2643743"), /*london*/
7	=>	("http://www.bbc.co.uk/weather/2643123"), /*manchester*/
8	=>	("http://www.bbc.co.uk/weather/2641673"), /*newcastle*/
9	=>	("http://www.bbc.co.uk/weather/2641181"), /*norwich*/
10	=>	("http://www.bbc.co.uk/weather/2640194"), /*plymouth*/
11	=>	("http://www.bbc.co.uk/weather/2638077"), /*sheffield*/
12	=>	("http://www.bbc.co.uk/weather/2637487"), /*southampton*/
);
/* /Backup of cities array */


fetchsummaries ($day);

?>