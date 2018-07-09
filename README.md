# Caffeinated Tester | Rails | Training

## Versions / Dependencies
```
Ruby:       2.5.1
Node:       8.9.4
Postgres:   Unknown...
```

Notes: I use RVM to make life a lot easier
```bash
# use correct ruby version
$ rvm user 2.5.1

# use correct gemset (to avoid conflicts with other apps)
$ rvm gemset use railsApp
```

## Getting started
To get started with the app, clone the repo and then install the needed gems:

```
$ bundle install --without production
```

Next, migrate the database:

```
$ rails db:migrate
```

Finally, run the test suite to verify that everything is working correctly:

```
$ rails test
```

If the test suite passes, you'll be ready to run the app in a local server:

```
$ rails server
```

To set guard up to watch for file changes and execute tests:
```
$ bundle exec guard
```

## Structure
This project follows the conventional rails structure.