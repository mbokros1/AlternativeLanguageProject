# Alternative Language Project: Ruby
For this project I chose Ruby 3.4.4, which was the most up-to-date version
available to me at the time I was starting on this project; 3.4.4 was released
in May 2025, the next version is scheduled to be released in July.

## Why Ruby?
Ruby is flexible and powerful without having too high a barrier for entry. 
It also naturally leads into learning ruby on rails.

## Features of Ruby
#### Object-oriented programming 
Ruby is a very object-oriented language, everything is handled as an object.
This has both advantages and disadvantages. One disadvantage is that during
file ingestion, everything comes in as an object, so at some point there needs
to be a ".to_s" applied to make sure things end up as specifically String objects.
#### File ingestion
While Ruby usually handles files using "File.new()" and "File.open()" commands that
appear similar to those used in other languages such as Python or Java, Ruby's csv
library has some powerful options specifically tailored for .csv files, so it made 
more sense to use those here instead.

The csv library allows .csv files to be processed row by row using a simple
"CSV.foreach()" statement. It also comes with the row object that can easily
be turned into an array using "row.map{}".
#### Conditional statements
Ruby's if/elseif/else statements are similar to those in other languages
like Python or Java. What stands out to me is the "end" at the end of a
statement as opposed to the same thing being accomplished by some set of
parentheses/brackets or whitespace.
#### Assignment statements
Ruby uses a simple equal sign ('=') as an assignment statement.
#### Loops
In addition to the usual while and for loops, Ruby also has an until condition, 
which in effect is a while loop with a different syntax.
#### Subprograms (functions/methods)
In Ruby, functions or methods not associated with a class become methods of the
generic object Object. The syntax used for any function or method is to begin with
"def" and end with "end".
#### Unit testing
RubyMines has minitest for the unit testing of Ruby projects.
#### Exception handling
Ruby's exception handling is done through the "rescue" statement, within which you
can put a "retry" command after changing some arguments that might be causing the
exceptions. Regardless of whether you retry or not, if you want some code to be 
executed even if there is an exception, you can use an "ensure" statement that results
in the block of code within executing even if an exception was raised before.

Alternatively, Ruby also has a "throw"/"catch" statement similar to other languages.

## Libraries used and not used
I needed to use the csv library to allow processing of the csv file in this project.
Ruby has support for regex built into the base language so no library was needed
for that.

## Results
#### What company (oem) has the highest average weight of the phone body?

#### Were there any phones that were announced in one year and released in another? What are they? Give me the oem and models.

#### How many phones have only one feature sensor?

#### What year had the most phones launched in any year later than 1999? 