# Redmine Git Work in Progress

[![Build Status](https://travis-ci.org/matsukei/redmine_git_work_in_progress.svg?branch=master)](https://travis-ci.org/matsukei/redmine_git_work_in_progress)

This is a plugin that provides Reduine's Issue like "Work In Progress Pull Request " and makes it easy to share knowledge.

## Demo

TODO

## Usage

TODO

## Requirement

Redmine 3.2.x or higher

## Install

1. git clone or copy an unarchived plugin to plugins/redmine_git_work_in_progress on your Redmine path.
2. `$ cd your_redmine_path`
3. `$ bundle install`
4. `$ bundle exec rake redmine:plugins:migrate NAME=redmine_git_work_in_progress RAILS_ENV=production`
5. web service restart

## Uninstall

1. `$ cd your_redmine_path`
2. `$ bundle exec rake redmine:plugins:migrate NAME=redmine_git_work_in_progress RAILS_ENV=production VERSION=0`
3. remove plugins/redmine_git_work_in_progress
4. web service restart

## Contribution

1. Fork it
2. Create your feature branch: `git checkout -b new-feature`
3. Commit your changes: `git commit -am 'add some new feature'`
4. Push to the branch: `git push origin new-feature`
5. Create new Pull Request

## License

[The MIT License](https://opensource.org/licenses/MIT)
