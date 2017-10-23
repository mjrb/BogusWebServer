# SillyWebServer
**this is not an example of good code**  
**this is not a webserver thats intended to be used**  
this was a project i started as a challenge in around freshman year of highschool.
I didn't fully unserstand how webservers and webprogramming worked.
so I set about to write some simple web servers and also have some with some good features.
I made several in a few different programming languages but this one survived and I actually used it to write a webapp to track attendance for the chess club I ran, and i also go halfway through creating a web app to manage tournaments.

## why this server sucks, and why it was abandoned
right now it abuses the global namespace and uses a very hacky almost imperative code style.
at the time of use it used a yaml file as a db, and couldn't serve images, or css, and js was inserted inline at runtime instead of having any static js files.
it was abandoned because attendance at chessclub meetings wasn't the most important metric and usally was ignored, and it was much easier to use other premade software to manage tornaments.

## why it's on github, and why im glad its there
at the time i was pretty proud of it, it had a modest feature set and worked in my use case.
while its a pretty terible server and was written badly it gave me an oportunity to improve and look back, and most importantly its my only connection to my childhood and 7+ years of projects that I've lost in computer wipes.

# features
- you can run a script everytime a page is loaded for dynamic content
- you can put ruby code inside <rb> tags, and when you call the view function it will automaticly insert what the code evaluates to where the tags were.
- javascript insertion
- serves static files and images
- mongodb support
drawbacks
- can only handle one client at a time
- strange "db"

# how to use demo files
first you must install mongodb and the mongo driver for ruby  
then you must update the config for your wanted mongodb settings  
then you can run `ruby dbinit.rb` to set up the database  
finally run `ruby server.rb` to start the server
the default password is password  
i set it to that because its really salt in the wounds because of how poor the authetication is for the example files