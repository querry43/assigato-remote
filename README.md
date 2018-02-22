# assigato-remote

Building
========

This software requires ruby 2.3.1 or greater as well as bundler.

```
bundle install --path vendor/bundle
```

Running
=======

Run the application in development without hardware control:

```
bundle exec rails server
```

Run the application in production with hardware control:

```
bundle exec rails server -e production
```
