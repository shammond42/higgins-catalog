<a href="https://codeclimate.com/github/shammond42/higgins-catalog"><img src="https://codeclimate.com/github/shammond42/higgins-catalog.png" style="float: right;"/></a>
# Higgins Armory Catalog

## Introduction

A searchable, online catalog for the [Higgins Armory Museum](http://higgins.org). The Higgins Armory collection of 4,000 or so artifact is one of the few signifiant collections of medieval arms and armor outside of Europe.

## Features

* Artifact of the Day
* Search by keyword, location, accession_number
* Filter and brwose by date

## Rails Rumble

This application was initially built in 48 hours for the [2012 Rails Rumble](http://railsrumble.com).

## Dependencies

* Ruby 1.9.3
* Rails 3.2
* Elastic Search
* PostgreSql (though it should also run fine on MySql and SqlLite)

## Getting Started

### Setting up in OS X

1. Download and install VirtualBox (`https://www.virtualbox.org/`)
1. Download and install Vagrant (`http://www.vagrantup.com/downloads`)
1. Git clone this repo into a new project directory
1. Get zip file with csv data
1. Unzip into db/higgins_data in your project directory
1. Get the zip file with the object photos in it.
1. Unzip that into the db/higgins_data directory

### Starting the app

1. Copy config/application.yml.sample to config/application.yml
1. Get SMTP and Akismet authentication and add to file -- secrets will be taken care of later
1. `vagrant up`
1. `vagrant ssh`
1. In your vagrant shell
    1. `cd /vagrant`
    1. Use `rake secret` to create the SESSION_SECRET and add to application.yml
    1. Use `rake secret` to create the DEVISE_SECRET and add to application.yml
    1. `rake test`
    1. `rails server`
1. Go to `http://localhost:3000` in your browser

## Contributing

If you wish to contribute to this project, or use it in another setting your best bet is probably to contact me first, to discuss your idea.
