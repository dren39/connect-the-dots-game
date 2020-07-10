## Introduction

This is a connect the dot game implemented using an HTML, CSS, and JavaScript frontend and a Ruby on Rails backend server.

## Objective

Each player takes turns clicking on a dot on the screen. Each two successful clicks draws a line between the dots. After the
first line is drawn, each successive line must be drawn from the end of an existing line.

## Installation

To run this game it is recommended to have Ruby verion 2.6.1 and Rails 6.0.1 installed. If you are using Ruby Version Manager then you can install Ruby and Rails by typing `rvm install 2.6.1` and `gem install rails` in your terminal.

## Starting Up the Game

Navigate to the `game-server` file in the terminal.
Run `bundle install` in the terminal to install the required gems.\
Run `rails s` in the terminal to spin up the server.\
In your web browser navigate to http://localhost:3000/ to make sure the Rails server is up and running.\
Navigate to the `client` folder and open up the `index.html` file in your browser.