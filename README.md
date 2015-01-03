Heroku buildpack: Java [![Build Status](https://travis-ci.org/heroku/heroku-buildpack-java.svg)](https://travis-ci.org/heroku/heroku-buildpack-java)
=========================

This is a [Heroku buildpack](http://devcenter.heroku.com/articles/buildpack) for Java apps.
It uses Maven 3.2.5 to build your application and OpenJDK 8u20 to run it (by default).

Usage
-----

Example usage:

    $ ls
    Procfile  pom.xml  src

    $ heroku create --buildpack http://github.com/heroku/heroku-buildpack-java.git

    $ git push heroku master
    ...
    -----> Heroku receiving push
    -----> Fetching custom language pack... done
    -----> Java app detected
    -----> Installing OpenJDK 1.8... done
    -----> Installing Maven 3.2.5... done
    -----> Installing settings.xml... done
    -----> executing /app/tmp/repo.git/.cache/.maven/bin/mvn -B -Duser.home=/tmp/build_19z6l4hp57wqm -Dmaven.repo.local=/app/tmp/repo.git/.cache/.m2/repository -s /app/tmp/repo.git/.cache/.m2/settings.xml -DskipTests=true clean install
           [INFO] Scanning for projects...
           [INFO]
           [INFO] ------------------------------------------------------------------------
           [INFO] Building readmeTest 1.0-SNAPSHOT
           [INFO] ------------------------------------------------------------------------
    ...

The buildpack will detect your app as Java if it has the file `pom.xml` in the root.  It will use Maven to execute the build defined by your pom.xml and download your dependencies. The .m2 folder (local maven repository) will be cached between builds for faster dependency resolution. However neither the mvn executable or the .m2 folder will be available in your slug at runtime.


Configuration
-------------

## Choose a JDK

Create a `system.properties` file in the root of your project directory and set `java.runtime.version=1.7`.

Example:

    $ ls
    Procfile pom.xml src

    $ echo "java.runtime.version=1.7" > system.properties

    $ git add system.properties && git commit -m "Java 7"

    $ git push heroku master
    ...
    -----> Heroku receiving push
    -----> Fetching custom language pack... done
    -----> Java app detected
    -----> Installing OpenJDK 1.7... done
    ...

## Choose a Maven Version

The `system.properties` file also allows for `maven.version` entry
(regardless of whether you specify a `java.runtime.version` entry). For example:

```
java.runtime.version=1.7
maven.version=3.1.1
```

Supported versions of Maven include 3.0.5, 3.1.1 and 3.2.5. You can request new
versions of Maven by submitting a pull request against `vendor/maven/sources.txt`.

## Customize Maven

There are three config variables that can be used to customize the Maven execution:

+ `MAVEN_CUSTOM_GOALS`: set to `clean install` by default
+ `MAVEN_CUSTOM_OPTS`: set to `-DskipTests=true` by default

These variables can be set like this:

```sh-session
$ heroku config:set MAVEN_CUSTOM_GOALS="clean package"
$ heroku config:set MAVEN_CUSTOM_OPTS="--update-snapshots -DskipTests=true"
```

Other options are available for [defining custom a `settings.xml` file](https://devcenter.heroku.com/articles/using-a-custom-maven-settings-xml).

Hacking
-------

To use this buildpack, fork it on Github.  Push up changes to your fork, then create a test app with `--buildpack <your-github-url>` and push to it.

For example if you want to have maven available to use at runtime in your application you simply have to copy it from the cache directory to the build directory by adding the following lines to the compile script:

    for DIR in ".m2" ".maven" ; do
      cp -r $CACHE_DIR/$DIR $BUILD_DIR/$DIR
    done

This will copy the local maven repo and maven binaries into your slug.

Commit and push the changes to your buildpack to your Github fork, then push your sample app to Heroku to test. Once the push succeeds you should be able to run:

    $ heroku run bash

and then:

    $ ls -al

and you'll see the .m2 and .maven directories are now present in your slug.

License
-------

Licensed under the MIT License. See LICENSE file.
