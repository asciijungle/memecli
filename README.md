# memecli

This is a small command line meme generator written in Haskell. 
It basically renders a given text onto a given image in JPEG format.

## Motivation
This code has been created during the [ZuriHac2017](https://zurihac.info) hackathon. It has been written for learning purposes and thus is of inferior quality. Though you might very well use this for educational purposes, productive use is discouraged at this point. 

## Building

The software can be build using the [stack](haskellstack.org) build tool.

### External dependencies

It requires the libgd library to be installed on your system. To install on a Debian/Ubuntu based distro issue
```
sudo apt-get install libgd-dev
```
On OS X use Homebrew to install the package `brew install gd`

### Compiling

First you'll have to setup your stack environment.
```
stack setup
```
After that you will be able to build via
```
stack build
```

## Running

You can run the tool using the `stack exec` command.
```
stack exec memecli -- -h
```

## Contributors

Contributions as pull requests are very much welcome. Also constructive suggestions on the coding style will be much appreciated.
