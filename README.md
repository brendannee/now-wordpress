# Setting up Wordpress with Now

## Install Now Desktop

Download and install [Now Desktop](https://zeit.co/desktop).

## Create a Google Cloud Account

Your database will be hosted by Google Cloud Platform. If you haven't used it before, you can get [$300 of free credit when signing up](https://console.cloud.google.com/freetrial).

* Log into [Google Cloud Platform](https://console.cloud.google.com).
* If you already have existing projects in Google Cloud Platform, you may want to create a new project.

## Create a new Cloud SQL Instance

* Choose `Cloud SQL Second Generation` for instance type.
* Enter an `Instance ID` such as `my-blog`.
* Use MySQL version 5.7.
* Use `us-central1` for Region and `any` for Zone.
* Change the `Machine Type` to `db-f1-micro`.
* Use the defaults for the rest of the options on this page.
* Click `Create` at the bottom of the page.

It will take a little while for the instance to be created.

## Configure the Cloud SQL Instance

Click on the `Instance ID` of your created instance to configure it.

First, we'll add a network connection to the instance.

* Click `Access Control` and then the `Add Network` button.
* Add a new network with name `Internet` and network `0.0.0.0/0`.
* Click `Done` and then click `Save` at the bottom of the page.

Next, we'll add a client certificate to the instance.

* Click the `SSL` submenu item under `Access Control`.
* Click the `Create a Client Certificate`.
* Create a new certificate, named something like `my-blog-db-cert`.
* Download the resulting `client-key.pem`, `client-cert.pem` and `server-ca.pem`.

## Connect to the Cloud SQL Instance

You can test that things are working correctly by copying the MySQL command provided on the cerificate generation page and running it from the directory that contains the files you downloaded. Note that the IP address of your Cloud SQL Instance will be different.

    mysql -uroot -p -h 104.197.91.190 \
      --ssl-ca=server-ca.pem --ssl-cert=client-cert.pem \
      --ssl-key=client-key.pem

## Create a database within your Cloud SQL Instance

* Click the `Databases` menu item.
* Click the `New Database` button.
* Name your database and click `add`. `wp` is a good database name.

## Create a password for your Cloud SQL Instance

* Click the `Users` submenu item under `Access Control`.
* Change the password for the `root` user - note what you change it to as it will be needed later.

## Create a .env file to hold environment variables.

* Create a file named `.env`
* Add the `DB_NAME`, `DB_USER`, `DB_PASSWORD` and `DB_HOST` to the `.env file`.

For example:

    DB_NAME=wp
    DB_USER=root
    DB_PASSWORD=9FJ8kBFx4FpNh7eF
    DB_HOST=104.197.91.191

`DB_NAME` is the name of the database created in a previous step.
`DB_USER` is `root` unless you created a different user.
`DB_PASSWORD` is the password you set for the database in a previous step.
`DB_HOST` is the IP address of your Cloud SQL Instance which is available on the `Overview` tab of the the Google Cloud Platform interface.

## Add Themes and plugins

Create a folder for your project locally, and add a `wp-content` folder inside of it. Inside of this folder you can add a folder called `themes` and `plugins` and add any themes or plugins your site depends on. The directory structure of your project should look like this:

|____.env
|____Dockerfile
|____nginx.conf
|____wp-config.php
|____wp-content
| |____plugins
| |____themes

## Deploy to Now

To deploy to now with all of the environment variables set in the `.env` file, you can run:

    sed 's/^/-e /' .env | xargs now --docker
