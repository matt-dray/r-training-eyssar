# Title: R training with EYSSAR Division
# Purpose: to learn about R and RStudio for reproducible analysis
# Your host: Matt Dray
# Date: 18 June 2018

# Make sure to write the title, name, date, etc at the top of your R script
# so that people know what it does. Remember you can use the hash mark '#' to
# 'comment out' your code so that it doesn't get interpreted as code when you
# execute it.

# Remember that if you have a commented line that ends in four or more hyphens
# then it will be come a 'section'. You should do this to help break up your
# code and make it easier to navigate. You can see a list of your sections by
# clicking the 'show document outline' button in the top right of the script
# pane (this pane) or the keyboard shortcut ctrl, shift and O (zero).

# Use R Projects for simplicity and reproducibility! Go to File, New Project.
# Projects keep all your code, data, etc in one place so you can transfer it
# to other people easily without filepath links breaking, etc.


# Load packages -----------------------------------------------------------


# Packages extend the functionality of R. Install packages to your machine with 
# the function install.packages("package_name"). You only need to run this once
# for each package.

# You need to call the packages you need from the 'library' each time you start
# a new R session. You do this with the library() function.

library(readr)  # for reading in data
library(dplyr)  # for manipulating data
library(ggplot2)  # for plotting


# Objects -----------------------------------------------------------------


# You can assign values (numbers, strings of text, etc) to a named object.
# You use the 'assignment arrow' operator (<-, keyboard shortcut is alt and
# hyphen) toapply the value to the name. When you create an object it appears in
# the 'environment' pane (top right) in RStudio. Remember that R is case
# sensitive.

my_number <- 12  # my favourite number
my_number  # execute this to see the value in the console
my_number + 1  # what happens when you do this?

my_text <- "splendid"  # strings of text need to be enclosed in quote marks
paste("I feel", my_text)  # what does this do?

# Vectors are one-dimensional 'lists' of values

my_vector <- c(1, 3, 5, 7, 100)  # c() combine these values
my_vector + 1  # what happens when you do this?

# You can see the 'class' of your object with the class() function

class(my_number)  # what's the class?
class(my_text)  # what's the class?
class(my_vector)  # what's the class?


# Get data ----------------------------------------------------------------

# Assuming you've already run install.packages("readr") to install the package
# and library(readr) so you can use the package, you can begin.

# You can look at the help file with ?package_name to get information about the
# function and the 'arguments' it takes. Arguments are the options you give
# the function, like a filepath to a CSV file. 

?read_csv

# You don't necessarily have to write the argument names, e.g. these are the
# same: read_csv("file.csv") and read_csv(file = "file.csv"). It's good practice
# to be explicit thought.

# Now create an object that contains the contents of a CSV at a given filepath
# and encode specific values as NA (which R treats as the absence of a value).
# Specify these arguments within the function call, separated by commas.

# We're using an R Project, so the filepath points to the 'data' subfolder of
# our R Project folder. This means the filepath is valid on anyone's machine.

# The dataset is from the School Workforce Census (SWFC) 2016 and is available
# from bit.ly/swfc_headcount

swfc <- read_csv(
  file = "data/swfc_2016_headcount.csv",  # the filepath to the file
  na = c("", "NA", "SUPP", "DNS")  # argument for specifying NA strings
)

# What class of object is this?

class(swfc)  # what does the output say and what does it mean?

# Take a look at the structure of the data frame with glimpse()

glimpse(swfc)  # tells you the dimensions, the classes and the first few rows

# Take a look at the dataset with View()

View(swfc)

# We can also see the first few or last few rows

head(swfc)  # see ?head to find out how to override the default 6 rows
tail(swfc)



# Manipulating data -------------------------------------------------------


# There are many ways to manipulte data in R. We're focusing on a relatively new
# and simple way of doing this with a package called 'dplyr', which is part of a
# larger suite of packages called the 'tidyverse'. The tidyverse simplifies
# data reading, processing, analysis and presentation and the packages all
# 'play nicely together'. The readr package is also part of the tidyverse; we
# used it to read in our data earlier.

# The functions we're using to manipulate the dataset are all simple verbs like
# 'select', 'filter' and 'arrange' that share similarity with the function names
# in SQL and Excel formulae, for example.

# There's lots of help in the 'Data transformation with dplyr' cheatsheet. Go to
# 'Help' then 'Cheatsheets' in RStudio.

# We're using 'pipes' (%in%, keyboard shortcut ctrl, shift and M) in our code.
# Pipes say take what's on the left of the pipe and pass it through to the right
# hand side. They help us to create readable recipe-like structures that are
# great for human interpretation, commenting and quality-assuring.

# I assume you've already run install.packages("dplyr") to install the package
# and library(dplyr) so you can use the package.

# 1. rename() function ----
# To rename specified columns

swfc_rename<- swfc %>%  # take the dataset and...
  rename(teaching_assistant_count = ta_count)  # ...rename the specified column

names(swfc_rename)  # look at the column names to check

# select() function ----
# To specify the columns we want to retain; all others are dropped

swfc_select_1 <- swfc %>%
  select(urn, school_name, school_type)  # get these three columns only

swfc_select_2 <- swfc %>%
  select(-urn, -school_name, -school_type)  # what does this do?

# 2. filter() function ----
# To specify the rows you want to keep based on some conditions
# '==' means 'equals' because a single equals marks is used for argument
# specifying the arguments in your function.

swfc_filter_1 <- swfc %>% filter(la_number == 202)  # just LA 202

swfc_filter_2 <- swfc %>% filter(la_number != 202)  # everything but LA 202

swfc_filter_3 <- swfc %>%
  filter(workforce_count > 700 | teacher_count >= 100)  # 'or', 'greater than'

swfc_filter_4 <- swfc %>%
  filter(la_number %in% c(202, 203, 204) & school_type == "Free Schools")  # ?


# 3. mutate() function ----
# To create new columns

swfc_mutate_1 <- swfc %>%
  mutate(new_column = "NEW")  # column filled entirely with word 'NEW'

swfc_mutate_2 <- swfc %>%
  mutate(
  laestab = paste0(  # create a new column called 'laestab' that pastes...
    as.character(la_number),  # ...the la number as text and...
    as.character(establishment_number)  # ...the estab number as text
  )
)

# 4. *_join() function ----
# Merge data from another dataset given a matching key
# The dataset is available from bit.ly/swfc_headcount


swfc_fte <- read_csv(  # read in teh data to be merged
  "data/swfc_2016_fte.csv",  # full time equivalent data
  na = na = c("", "NA", "SUPP", "DNS")  # assign values to NA
)

swfc_fte_join <- swfc %>% 
  left_join(  # other joins are available (right-, anti-, etc)
    swfc_fte,  # the dataset to be joined
    by = "urn"  # the unique matching key
  )

glimpse(swfc_fte_join)  # check our join has worked

# 5. Piping with multiple functions ----
# Can you explain what's happening here?

swfc %>%
  select(urn, school_name, school_type, teacher_count, ta_count) %>%
  filter(school_type == "Academies") %>%
  mutate(teacher_ta_ratio = teacher_count / ta_count) %>% 
  left_join(swfc_fte, by = "urn") %>% 
  select(-school_type, -teacher_count, -ta_count, -aux_fte) %>%
  arrange(teacher_ta_ratio)


# 6. group_by() and summarise() functions ----
# Perform operations within specified groups (a bit like VLOOKUP in Excel)
# Example: which LA/school-type combination has the highest mean number of
# teachers?


swfc_summarise <- swfc %>%
  group_by(la_name, school_type) %>%  # perform operations within these groupings
  summarise(
    mean_teacher_count = mean(teacher_count),  # 
    school_count = n()  # get the denominator by counting the number of schools
  ) %>% 
  arrange(desc(mean_teacher_count)) %>%  # order by descending value of the mean
  ungroup()  # 'undo' the 'group_by()'


# Plots -------------------------------------------------------------------


# We're using the ggplot2 package. The 'gg' but stands for 'Grammar of Graphics'
# and is a way of thinking about how to construct a plot from scratch. Plots
# have a structure in the same way sentences have structure; there are rules
# that dictate how they should be assembled.

# There's lots of help in the 'Data visualization with ggplot2' cheatsheet. Go
# to 'Help' then 'Cheatsheets' in RStudio.

# We're going to build a minimal plot by:
# 1. laying down a canvas with ggplot()
# 2. adding info about the aesthetics, aes(), of the plot (x, y, fill, etc)
# 3. adding info about the geometry, geom(), we want to use (bar, scatter, etc)

# These elements are built up one by one with the '+' operator. There are many
# more that can be added to alter things like the labels and colour scheme.

# Assuming you've already run install.packages("readr") to install the package
# and library(readr) so you can use the package, here's a minimal example of a
# boxplot of teacher count by school type

swfc %>% 
  ggplot() +  # blank canvas
  aes(x = school_type, y = teacher_count) +  # x and y aesthetics
  geom_boxplot()  # make a boxplot

# Let's add some things to make it a bit prettier

swfc %>% 
  ggplot() +
  aes(x = school_type, y = teacher_count) +
  geom_boxplot() +
  labs(  # add labels
    title = "Teacher count by school type",
    x = "School type",
    y = "Count",
    caption = "Source: School Workforce Census 2016"
  ) +
  theme_minimal() +  # simplify the style
  coord_flip()  # easier to read labels?

# What about using a 'fill' aesthetic?
# What about assigning a name to the plot object?

swfc_bar<- swfc %>% 
  ggplot() +
  aes(
    x = region,  # only an x axis
    fill = school_type  # colour it by school type
  ) + 
  geom_bar()

swfc_bar  # check it out

swfc_bar +
  coord_flip()  # you can add on top of the plot object

# And let's do a scatter with conditional colouring of the points
  
swfc %>% 
  ggplot() +
  aes(
    x = teacher_count,
    y = ta_count,
    colour = school_type  # colour points by school type
  ) +
  geom_point()


# What now? ---------------------------------------------------------------


# There are plenty of other places to learn R and get help.

# I've added a list of useful things to the end of another training document
# I've prepared: https://matt-dray.github.io/beginner-r-feat-pkmn/ (see Section 9
# 'Further Reading')

# The department is also creating some training materials (work in progress):
# https://dfe-analytical-services.github.io/r-training-course/

# Don't forget you can ask me or someone else in the department. There is a lot
# of R knowledge around.
