# Title: R training with EYSSAR Division
# Purpose: to learn about R and RStudio for reproducible analysis
# Your host: Matt Dray
# Date: 18 June 2018 (London)
# Updated: 2 Aug 2018 (Sheffield)

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

# We're not really going to look into them here, but two other fundamental 
# classes of objects are matrices and lists.

# Matrices are used when the data are of the same type

my_matrix <- matrix( 
  c(2, 4, 3, 1, 5, 7), 
  nrow = 3, 
  ncol = 2
)

class(my_vector)

# Lists are like vectors that contain other objects. So elements could be other
# vectors, or even a dataframe.

my_list <- list(
  text_element = c(1:3),
  numeric_element = c(""),
  dataframe_element = data.frame(X = rnorm(3, n = 6), Y = rnorm(1, n = 6)),
  matrix_element = my_matrix
)

class(my_list)


# Load packages -----------------------------------------------------------


# Packages extend the functionality of R. They're bundles of functions written
# for soem purpose (e.g. the 'sf' package contains )

# Packages that have passed certain tests are allowed to be hosted on something
# called CRAN (Comprehensive R Archive Network), which is a big repository of
# packages. Packages can also be downloaded from other places, but CRAN should
# be sufficient for now.

# Install packages to your machine with the function
# install.packages("package_name"). You only need to run this once for each
# package.

# You need to call the packages you need from the 'library' each time you start
# a new R session. You do this with the library() function. For example:

# library(readr)  # for reading in data
# library(dplyr)  # for manipulating data
# library(ggplot2)  # for plotting

# It's typical to load these at the top of your script file, though I've loaded
# them in as needed throughout this particular script.


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

library(readr)  # for reading in data

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

# We'll learn about rename, select, filter, join, group_by, summarise

# first load the package

library(dplyr)  # for manipulating data


# 1. rename() function ----


# To rename specified columns

swfc_rename<- swfc %>%  # take the dataset and...
  rename(teaching_assistant_count = ta_count)  # ...rename the specified column

names(swfc_rename)  # look at the column names to check


# 2. select() function ----


# To specify the columns we want to retain; all others are dropped

swfc_select_1 <- swfc %>%
  select(urn, school_name, school_type)  # get these three columns only

swfc_select_2 <- swfc %>%
  select(-urn, -school_name, -school_type)  # what does this do?


# 3. filter() function ----


# To specify the rows you want to keep based on some conditions
# '==' means 'equals' because a single equals marks is used for argument
# specifying the arguments in your function.

swfc_filter_1 <- swfc %>% filter(la_number == 202)  # just LA 202

swfc_filter_2 <- swfc %>% filter(la_number != 202)  # everything but LA 202

swfc_filter_3 <- swfc %>%
  filter(workforce_count > 700 | teacher_count >= 100)  # 'or', 'greater than'

swfc_filter_4 <- swfc %>%
  filter(la_number %in% c(202, 203, 204) & school_type == "Free Schools")  # multi

swfc_filter_5 <- swfc %>%
  filter(is.na(teacher_count))  # filter for rows that are NA

swfc_filter_6 <- swfc %>%
  filter(!is.na(teacher_count))  # '!' negates, so this gives us all non-NAs


# 4. mutate() function ----


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

# Why isn't the following code ideal?

swfc_mutate_3 <- swfc %>%
  mutate(
    la_number = as.character(la_number),
    establishment_number = as.character(establishment_number),
    urn = as.character(urn)
  )

# We can use the mutate_at() variant instead

swfc_mutate_4 <- swfc %>%
  mutate_at(
    vars(la_number, establishment_number, urn),
    as.character
  )

# Also if we want to mutate_at() without having to type every column name

swfc_mutate_5 <- swfc %>%
  mutate_at(vars(matches("teacher")), log10)

# We can also do this conditionally with mutate_if()

# What does next bit of code do?

swfc_mutate_6 <- swfc %>%
  mutate_if(
    is.numeric,
    as.character
  )


# 5. *_join() function ----


# Merge data from another dataset given a matching key
# There are many *_join() functions: left, right, anti, etc

# Read additional dataset with new information to be matched
# The dataset is available from bit.ly/swfc_headcount

swfc_fte <- read_csv(  # read in the data to be merged
  "data/swfc_2016_fte.csv",  # full time equivalent data
  na = c("", "NA", "SUPP", "DNS")  # assign values to NA
)

# Perform join

swfc_fte_join_1 <- left_join(  # keep table x rows, match table y rows
    x = swfc, # dataset to join to
    y = swfc_fte,  # the dataset to be joined
    by = "urn"  # the unique matching key
  )

# How might you check that the join has been successful?

glimpse(swfc_fte_join_1)  # this is one way


# 6. Piping with multiple functions ----


# Can you explain what's happening here?

swfc %>%
  select(urn, school_name, school_type, teacher_count, ta_count) %>%
  filter(school_type == "Academies") %>%
  mutate(teacher_ta_ratio = teacher_count / ta_count) %>% 
  left_join(swfc_fte, by = "urn") %>% 
  select(-school_type, -teacher_count, -ta_count, -aux_fte) %>%
  arrange(teacher_ta_ratio)


# 7. group_by() and summarise() functions ----


# Perform operations within specified groups (a bit like VLOOKUP in Excel)
# Example: which LA/school-type combination has the highest mean number of
# teachers?


swfc %>%
  group_by(la_name, school_type) %>%  # perform operations within these groupings
  summarise(
    mean_teacher_count = mean(teacher_count),  # 
    school_count = n()  # get the denominator by counting the number of schools
  ) %>% 
  arrange(desc(mean_teacher_count)) %>%  # order by descending value of the mean
  ungroup()  # 'undo' the 'group_by()


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
# and library(readr) so you can use the package

# Load the package

library(ggplot2)  # for plotting


# 1. Histogram example ----


swfc %>% 
  ggplot() +  # blank canvas
  aes(x = teacher_count) +  # need only supply an x aesthetic
  geom_histogram(binwidth = 5)  # make a histogram

# what does the warning message mean?
# filter out NAs, execute and check the output - there's no warning now

swfc %>% 
  filter(!is.na(teacher_count)) %>% 
  ggplot() +  # blank canvas
  aes(x = teacher_count) +  # x aesthetics
  geom_histogram(binwidth = 5)  # make a histogram

# You can integrate dplyr functions into your pipeline
# Here we log the x variable to remove the right skew

swfc %>% 
  mutate(teacher_count_log10 = log10(teacher_count)) %>% 
  ggplot() +  # blank canvas
  aes(x = teacher_count_log10) +  # x and y aesthetics
  geom_histogram()  # make a boxplot


# 2 Boxplot example ----


# Here's a minimal example of a boxplot of teacher count by school type

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
  coord_flip()  # easier to read labels

# Dotplots and violin plots are also available

swfc %>% 
  ggplot() +  # blank canvas
  aes(x = school_type, y = teacher_count) +  # x and y aesthetics
  geom_violin()  # make a dotplot


# 3 Barplot example ----


# We can assign the plot object to an object name and use '+' to add new layers

library(forcats)  # allows us to use fct_infreq to order the bars

swfc_bar_1 <- swfc %>% 
  ggplot() +
  aes(
    x = fct_infreq(region),
    fill = school_type  # colour it by school type
  ) + 
  geom_bar()

swfc_bar_1  # check it out

# Let's build on it by flipping the axes

swfc_bar_2 <- swfc_bar_1 +  # take the plot object and add more layers
  coord_flip()  # e.g. flip x and y axes

swfc_bar_2

# Also the colours aren't very good; let's alter them using some prewritten
# colour pallettes from the RColorBrewer package. See:
# https://cran.r-project.org/web/packages/viridis/vignettes/intro-to-viridis.html

library(RColorBrewer)  # friendly colour pallettes

swfc_bar_3 <- swfc_bar_2 +  # take the plot object and add more layers
  scale_fill_brewer(
    palette = "Set3",
    name = "School type"
    )

swfc_bar_3


# 4. Scatter example ----


# And let's do a scatter with conditional colouring of the points

# Let's use a different package that contains color pallettes
# https://cran.r-project.org/web/packages/viridis/vignettes/intro-to-viridis.html

library(viridis)  # another fancy colour pallette

swfc %>% 
  ggplot() +
  aes(
    x = teacher_count,
    y = ta_count,
    colour = school_type  # colour points by school type
  ) +
  geom_point() +  # note that 'point' gives us scatter
  scale_color_viridis(discrete = TRUE)  # continuous axes, but points are categorical

# We can various lines to these data too

plot <- swfc %>%
  filter(school_type %in% c("Free Schools", "Special schools")) %>% 
  ggplot() +
  aes(
    x = teacher_count,
    y = ta_count,
    colour = school_type
  ) +
  labs(
    title = "Teacher-TA relationship by school type",
    x = "Teacher count",
    y = "TA count",
    caption = "Data: School Workforce Census 2016"
  ) +
  geom_jitter(pch = 1, cex = 3) +  # what's geom_jitter()? what are pch and cex?
  theme_bw()  # what does this do?

plot  # print the plot

# add linear best-fit

plot +
  geom_smooth(
    method = "lm",  # 'lm' as in linear model
    na.rm = TRUE  # we can explicitly remove the NAs from the calculation
  )


# 5. Save the plot ----


# What a beautiful plot! Let's save it somewhere sensible for posterity.

ggsave("plot.png", path = "image")
ggsave("plot.pdf", path = "image")


# Interactive maps --------------------------------------------------------


# We can use the Leaflet package for making interactive maps in R.

# Leaflet is written in the coding language  Javascript, but there is 
# convenient R package that abstracts all that Javascript away, so you only need
# to type R code

# First we'll prepare the data. We need to gat coordinates first. School
# coordinates are available as eastings and northings in Get Information About
# Schools (GIAS) data 

# We can download this from the internet directly into R (beware: it's 54 MB)
# or you can do it manually: https://get-information-schools.service.gov.uk/Downloads

library(data.table)  # handles bigger datasets well
library(stringr)  # tidy string manipulation
library(janitor)  # data cleaning

gias <- data.table::fread(
  paste0(
    "http://ea-edubase-api-prod.azurewebsites.net/edubase/edubasealldata",
    stringr::str_replace_all(Sys.Date(), "-", ""),  # today's date
    ".csv"
  )
) %>% 
  clean_names() %>% 
  select(urn, easting, northing) %>% 
  mutate_at(vars(easting, northing), as.numeric)

# Join the coordinates from GIAS to our swfc data

swfc_en <- swfc %>%
  left_join(
    x = swfc,
    y = gias,
    by = "urn"
  )

# Convert from eastings and northings to latitudes and longitudes. All of the
# elements of our map need to be in the same coordinate system. Lat-long is
# sensible.

library(sf)  # spatial analysis functions

swfc_sf <- swfc_en %>% 
  st_as_sf(
    coords = c("easting", "northing"),  # columns with coordinates
    crs = 27700  # coordinate reference system code for eastings/northings
  ) %>% 
  st_transform(crs = 4326)  # the coord ref system code for latlong

# When we look at this object, it still is a dataframe, but also has some
# spatial metadata and a 'geometry' list-column - each row has a two-element
# list of latitude and longitude. In other words, it's now an 'sf' class
# object as well.

swfc_sf  # take a look
class(swfc_sf)  # actually has multiple classes!

library(leaflet)  # package for interactive mapping

swfc_sf %>% 
  sample_n(100) %>% 
  leaflet() %>% 
  addProviderTiles(providers$Stamen.Toner) %>%
  addMarkers(
    popup = ~paste0(
      "<b>", school_name, "</b><br>Workforce count: ", workforce_count)
  )
  

# Database connection -----------------------------------------------------


# https://gist.github.com/matt-dray/924421d57c3f568d4bc2d6465e00f02c


# What now? ---------------------------------------------------------------


# There are plenty of other places to learn R and get help.

# I've added a list of useful things to the end of another training document
# I've prepared: https://matt-dray.github.io/beginner-r-feat-pkmn/ (see
# Section 9 'Further Reading')

# The department is also creating some training materials (work in progress):
# https://dfe-analytical-services.github.io/r-training-course/

# Don't forget you can ask me or someone else in the department. There is a lot
# of R knowledge around.
