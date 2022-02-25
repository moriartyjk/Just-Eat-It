# What is Firebase?

Firebase is actually a set of tools developed by Google. It includes a NoSQL database (Firestore), user management, hosting, some server-like stuff (Functions), and more. I don't think we'll need or want anything besides Firestore, users, and hosting, though.

It's really worth spending a minute poking around the [Firebase Project Page](https://console.firebase.google.com/project/cs321-just-eat-it/overview) and the docs.

## Firestore

This is a database, but you don't use SQL to access it. This is probably a good thing, since it's one less thing to learn. Unlike traditional databases, Firestore organizes things into collections and documents instead of tables and rows. Firestore also lets you configure permissions on reading and writing using rules.

## User Management

Firebase allows all kinds of sign up options, and it's pretty easy to use any of them. It's easier than setting it up ourselves, anyway.

## Hosting

Firebase offers free hosting at *.web.app and *.firebaseapp.com. This doesn't have any server functionality (in Firebase, any server-side stuff is handled by Functions, but these are kinda a complex mess that we should avoid if possible), but this is ok because our app just needs to access a database. We don't need a real back end.

I'm actually not a huge fan of Firebase for large apps, a company I've worked used it for like a year before dropping it because it was such a complex mess. It can also get a bit expensive if your site gets popular. But for small apps, like Just-Eat-It, it seems like an easy way to get off the ground.

# What is FlutterFire?

FlutterFire is just the Dart library that contacts Firebase. If we were using JavaScript or Java or Go, we would use another library, but it would do the same thing.

# How to Set Up Firebase

First, open a terminal, `cd` to `Just-Eat-It/`, and run
```
$ git pull
```
to fetch all the latest changes. Then run
```
$ flutter pub get
```
to download all the dependencies in the JustEatIt package list (which is in `pubspec.yaml`). If you already have the dependencies, this won't do anything.

Then you have to download the Firebase CLI. This is used to control the database and whatnot from your computer. The easiest way to do this is to visit the [Firebase CLI page](https://firebase.google.com/docs/cli) and download the **standalone binary** for your OS. Then rename the file to `firebase`, add it to your PATH, and `chmod` it to add run permissions. Here's what I did, but it'll be different on Windows.
```
$ mv ~/Downloads/firebase-tools-linux ~/bin/firebase
$ chmod 755 ~/bin/firebase
$ firebase --version
10.2.1
```
Then run
```
$ dart pub global activate flutterfire_cli
```
to download and install the Flutter Firebase CLI. You'll have to add the install path to your PATH (something like `/home/tom/.pub-cache/bin`).

That's all for installation! Kinda a lot, and we'll probably never use it again.

Now you need to give the Firebase CLI account access. This seems kinda sketchy, but it's the way it works.
```
$ firebase login
i  Firebase optionally collects CLI usage and error reporting information to help improve our products. Data is collected in accordance with Google's privacy policy (https://policies.google.com/privacy) and is not used to identify you.

? Allow Firebase to collect CLI usage and error reporting information? No

Visit this URL on this device to log in:
https://accounts.google.com/o/oauth2/***long url***
Waiting for authentication...

✔  Success! Logged in as thcopeland2001@gmail.com
```
To make sure everything's okay, run
```
$ firebase projects:list
```
and check that you have the `cs321-just-eat-it` project. If not, sorry about, let me know and I'll add you.
