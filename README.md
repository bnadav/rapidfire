# Rapidfire
[![Code Climate](https://codeclimate.com/github/code-mancers/rapidfire/badges/gpa.svg)](https://codeclimate.com/github/code-mancers/rapidfire)
[![Build Status](https://travis-ci.org/code-mancers/rapidfire.png?branch=master)](https://travis-ci.org/code-mancers/rapidfire)


## Note
This is a fork of the Rapidfire projects with some changes that may be incomatible
with the original!
If you want to use the original gem find it [here](https://github.com/code-mancers/rapidfire)


## Descritption
One stop solution for all survey related requirements! Its tad easy!

This gem supports **rails 3.2.13+**, **rails4** and **rails5** versions.

## Installation
Add this line to your application's Gemfile:

```rb
    gem 'rapidfire'
```

And then execute:

```shell
    $ bundle install
    $ bundle exec rake rapidfire:install:migrations
    $ bundle exec rake db:migrate
```

And if you want to customize rapidfire views, you can do

    $ bundle exec rails generate rapidfire:views

If you want to customize rapidfire locales (i18n) files, you can do

    $ bundle exec rails generate rapidfire:locales

If you want to change the default configuration options do

    $ bundle exec rails generate rapidfire:initializer

This will create the config/initializers/rapidfire_init.rb in the main app directory.
All options in this file are commented out. The comments contain short explanations regarding their usage (see also below)

If you want to create basic styling of surveys in your app, you can copy some assets
 
    $ bundle exec rails generate rapidfire:assets

This will create two files in the main app: 
  app/assets/stylesheets/rapidfire.scss
  app/assets/javascripts/rapidfire.js

Note: The generated scss file is based on bootstrap. 
You will need to include the bootstrap-sass gem in your Gemfile in order for it to work.


## Usage

Add this line to your routes will and you will be good to go!

```rb
    mount Rapidfire::Engine => "/rapidfire"
```

And point your browser to [http://localhost:3000/rapidfire](http://localhost:3000/rapidfire)

All rapidfire controllers inherit from your `ApplicationController`. 
Rapidfire expects a method to exists in your `ApplicationController` that returns
the a record representing the user of the gem. By defualt this methos is named `current_user`.

Typical implementation would be:

```rb
  class ApplicationController < ActionController::Base
    def current_user
      @current_user ||= User.find(session[:user_id])
    end
  end
```

The method name can be customized in the initializer file. 
For instance if a sruvey respondent is an `examinee` rather then a `user`, it may be clearer to 
to fetch the record using a method named `current_examinee`.
So in rapidfire_init.rb write: 

```rb
    config.current_user_getter = :current_examinee
```

If you are using authentication gems like devise and you stick to the default naming, 
you get `current_user` for free and you don't have to define it.


### Configuration options
Configurations can be set in config/initializers/rapidfire_init.rb, as follows:
See longer documentation in the generated initializer.
By defalut all options are commented out - See defaults in initializer comments.
Below are some possible modifications, for demonstration:

```rb
  Rapidfire.config do |config|
    # path to go, after successful completion of survey
    config.after_attempt_path = "/login"
    # attempt taking guard (survey is not ran when lambda returns falsy value)
    config.before_attempt = lambda{ |user| user.can_take_survey? }
    # end of survey notifier
    config.after_attempt = lambda{ |user| user.survey_taken! }
    # is current user authorized to administer surveys ?
    config.can_administer = lambda{ |user| user.administrator? }
    # name of getter method in `ApplicationController` which returns survey's `current user`
    config.current_user_getter = :survey_respondent
  end
```

### Routes Information
Once this gem is mounted on, say at 'rapidfire', it generates several routes
You can see them by running `bundle exec rake routes`.

1. The `root_path` i.e `localhost:3000/rapidfire` always points to list of
   surveys {they are called question groups}. Admin can manage surveys, and
   any user {who cannot administer} can see list of surveys.
2. Optionally, each survey can by answered by visiting this path:

   ```
     localhost:3000/rapidfire/surveys/<survey-id>/answer_groups/new
   ```

   You can distribute this url so that survey takers can answer a particular survey
   of your interest.

### Survey Results
A new api is released which helps in seeing results for each survey. The api is:

```
  GET /rapidfire/surveys/<survey-id>/results
```

This new api supports two formats: `html` and `json`. The `json` format is supported
so that end user can use any javascript based chart solutions and render results
in the format they pleased. An example can be seen [here](https://github.com/code-mancers/rapidfire-demo),
which uses chart.js to display results.

Diving into details of `json` format, all the questions can be categorized into
one of the two categories:
1. **aggregatable**: questions like checkboxes, selects, radio buttons fall into
   this category.
2. **non-aggregatable**: questions like long answers, short answers, date, numeric
   etc.

All the aggregatable answers will be returned in the form of hash, and the
non-aggregatable answers will be returned in the form of an array. A typical json
output will be like this:

```json
[
{
    "question_type": "Rapidfire::Questions::Radio",
    "question_text": "Who is author of Waiting for godot?",
    "results": {
        "Sublime": 1,
        "Emacs": 1,
        "Vim": 1
    }
},
{
    "question_type": "Rapidfire::Questions::Checkbox",
    "question_text": "Best rock band?",
    "results": {
        "Led Zeppelin": 2
    }
},
{
    "question_type": "Rapidfire::Questions::Date",
    "question_text": "When is your birthday?",
    "results": [
        "04-02-1983",
        "01/01/1970"
    ]
},
{
    "question_type": "Rapidfire::Questions::Long",
    "question_text": "If Apple made a android phone what it will be called?",
    "results": [
        "Idude",
        "apdroid"
    ]
},
{
    "question_type": "Rapidfire::Questions::Numeric",
    "question_text": "Answer of life, universe and everything?",
    "results": [
        "42",
        "0"
    ]
},
{
    "question_type": "Rapidfire::Questions::Select",
    "question_text": "Places you want to visit after death",
    "results": {
        "Iran": 2
    }
}
]
```

## How it works
This gem gives you access to create questions in a groups, something similar to
survey. Once you have created a group and add questions to it, you can pass
around the form url where others can answer your questions.

The typical flow about how to use this gem is:

1. Create a question group by giving it a name.
2. Once group is created, you can click on the group which takes you to another
   page where you can manage questions.
3. Create a question by clicking on add new, and you will be provided by these
   options: Each question will have a type
   - **Checkbox** Create a question which contains multiple checkboxes with the
     options that you provide in `answer options` field. Note that each option
     should be on a separate line.
   - **Date** It takes date as an answer
   - **Long** It needs a description as answer. Renders a textarea.
   - **Numeric** It takes a number as an answer
   - **Radio** It renders set of radio buttons by taking answer options.
   - **Select** It renders a dropdown by taking answer options.
   - **Range** It renders a dropdown by taking minimum and maximum values for answer options, and 
     automatically generating the whole option range. In this type of question you can add 'suffix' annotation
     to the minimum and maximun options. You do this by adding the requested suffix between '<>' signs.
     For example these answer options: 
     ```
        1<first>
        5<last>
     ```
     will result in the following dropdown options:
     ```
     1 first
     2
     3
     4
     5 last

     ```
   - **Short** It takes a string as an answer. Short answer.

4. Once the type is filled, you can optionally fill other details like
   - **Question text** What is the question?
   - **Answer options** Give options separated by newline for questions of type
     checkbox, radio buttons or select.
   - **Answer presence** Should you mandate answering this question?
   - **min and max length** Checks whether answer if in between min and max length.
     Ignores if blank.
   - **greater than and less than** Applicable for numeric question where answer
     is validated with these values.

5. Once the questions are populated, you can return to root_path ie by clicking
   `Surveys` and share distribute answer url so that others can answer
   the questions populated.
6. Note that answers fail to persist of the criteria that you have provided while
   creating questions fail.

# Grid view
Consecutive questions, with the same answer options, can be marked to be displayed in a 'grid-view'.
This means that the answer options labels wont be displayed separately for each question but rather as headers
of columns. The first question in the grid must also have some text content in the 'introduction' field.
This field will be displayed as the header of the grid.
**Note:** The entire mechanism of transforming displaying grid is based on css. The sole operation of the backend
side is adding extra HTML classes to the question wrapper: 'grid' class for all gird questions, and 'kernel'
class to grid question that has also introduction content.


## Notes on upgrading

##### Upgrading from 2.1.0 to 3.0.0

If you are upgrading you need to rename your `rapidfire_question_groups` to `rapidfire_surveys` and `rapidfire_answer_groups` to `rapidfire_attempts`. Run the given task to do that for you.

```shell
    $ rake rapidfire:upgrade:migrations:from210to300
```

##### Upgrading from 1.2.0 to 2.0.0

The default delimiter which is used to store options for questions like select
input, multiple answers for checkbox question is comma (,). This resulted in
problems where gem is unable to parse options properly if answers also contain
commas. For more information see [issue-19](https://github.com/code-mancers/rapidfire/issues/19).

Starting from version `2.0.0` default delimiter is changed to `\r\n`, but a
configuration is provided to change the delimiter. Please run this rake task
to make existing questions or stored answers to use new delimiter.

NOTE: Please take database backup before running this rake task.

```rb
  bundle exec rake rapidfire:change_delimiter_from_comma_to_srsn
  bundle exec rake rapidfire:change_delimiter_from_comma_to_srsn
```


If you dont want to make this change rightaway, and would like to use comma
as delimiter, then please use this initializer, but be warned that in future
delimiter will be hardcoded to `\r\n`:


```rb
  # /<path-to-app>/config/initializers/rapidfire.rb

  Rapidfire.config do |config|
    config.answers_delimiter = ','
  end
```


## TODO
1. Add ability to sort questions, so that order is preserved.
2. Add multi tenant support.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
