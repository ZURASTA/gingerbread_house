[![Stories in Ready](https://badge.waffle.io/ZURASTA/gingerbread_house.png?label=ready&title=Ready)](https://waffle.io/ZURASTA/gingerbread_house?utm_source=badge) [![CircleCI](https://circleci.com/gh/ZURASTA/gingerbread_house.svg?style=svg)](https://circleci.com/gh/ZURASTA/gingerbread_house)
# GingerbreadHouse (Business Management)

Manages and verifies (_using Stripe_) business details for different countries.


### Usage

The service component (`GingerbreadHouse.Service`) is an OTP application that should be started prior to making any requests to the service. This component should only be interacted with to configure/control the service explicitly.

An API (`GingerbreadHouse.API`) is provided to allow for convenient interaction with the service from external applications.

A business details library (`GingerbreadHouse.BusinessDetails`) provides convenient templates to fill out the details required for different business types.


## Configuration

The service may be configured with the following options:

### Setup Mode

The service has two setup modes: `:auto` and `:manual`. When the service is started in `:auto`, it will automatically handle creating and migrating the database. When the service is started in `:manual`, the state of the database is left up to the user to manually setup.

By default the service runs in `:auto` mode. To change this behaviour, pass in the `{ :setup_mode, mode }` when starting the application.

### Database

The database options can be configured by providing the config for the key `GingerbreadHouse.Service.Repo`.

For details on how to configure an [Ecto repo](https://hexdocs.pm/ecto/Ecto.Repo.html).

__Note:__ If a PostgreSQL database is used, the service will create a custom type. For details on how to interact with this type, see the [EctoEnum docs](http://hexdocs.pm/ecto_enum).
