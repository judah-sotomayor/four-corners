# Getting Started

This project uses Nix to manage dependencies, git hooks, and the build system.
The easiest installation path for Nix is the Determinate Systems installer.
You can read the install guide here:
https://docs.determinate.systems/

If you're using Windows you will need to have Windows Subsystem for Linux setup; I leave this as an exercise to the reader.

Once you've got Nix installed, you can enter this repo and run `nix develop` to launch the development shell. In here you will have access to the python modules you require to run the application.

> *If* you get tired of running nix develop by hand, you can also setup direnv.
> Direnv has the additional advantage of automatically sourcing a .env file if you have one.
> Instructions to install are here: https://direnv.net

The application can be launched with `python3 src/main.py`.
Lints and formatters can be run with `nix fmt`.

When you go to make a git commit, git will automatically run the formats and lints for you. This is used to ensure QA checks are complete _before_ you push to github and cause an action run failure.

# Configuring the Application

This application is loosely designed around [twelve-factor](https://12factor.net) practices.
Environment variables are used to set up the primitives of the application, such as the database path.
These variables will be named with the prefix `FCR`.
The file .env.example will contain a comprehensive list of the variables required, obviously with credentials stripped out.

To get set up, `cp .env.example .env` and fill in any necessary variables.
