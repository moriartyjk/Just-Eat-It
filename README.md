# Just-Eat-It

JustEatIt is an innovative app designed to help people eat at local restaurants.

It is written in Flutter, and uses Firebase for user management and a database.

# Development

First, clone the app with
```
$ git clone git@github.com:jen-mo/Just-Eat-It.git
```

Then install Flutter and the VSCode Flutter package. Then follow the directions in [doc/firebase_setup.md](https://github.com/jen-mo/Just-Eat-It/blob/main/doc/firebase_setup.md). To make sure everything's okay, launch the app with `flutter run`.

You are ready to go!

## Deploying

If you want to deploy the app, first build it using
```
$ flutter build web
```
then deploy it with
```
$ firebase deploy
```
Then go to https://cs321-just-eat-it.web.app/! Pretty sweet.