---
title: "Basic application architecture"
keywords: sample homepage
tags: [getting_started]
sidebar: mydoc_sidebar
permalink: index.html
summary: This brief reference will help you start with development of this project.
---

{% include warning.html content="This documentation is not complete and is in beta phase.
You can help with finishing it at <a href='https://code.gov.cz/msp/victims_compensation_fund'>code.gov.cz repository</a>" %}

## High level architecture

<div class="mermaid">
classDiagram
    Claim "1" <-- "1..*" Debt
    Claim "1" <-- "1..*" Appeal
    Appeal "0..*" --> "1..*" Victim
    Appeal --> Offender
    Debt "0..*" --> "1" Offender
    Claim : file_uid
    Claim : court_uid
    Claim : binding_effect
    Debt : amount
    Appeal : amount
</div>

Explenation follows.

### Brief intro

Claim is based on a decision of court. Claim is uniquelly identified with a court's id and file_uid. In Claim Debts can arrise for more Offenders and one Offender can have multiple Debts. The Victims are appealing - thus having Appeals in the Claim. The Victim has to appeal against specific Offender. If the Victim is appealing against more offenders, it has to appeal for each offender.

### Dependencies

Project strongly depends on two custom libraries:

* eGovernment utilities
* Azahara schema


## Development

### 1. Install Rails

If you've never installed or run a Rails application locally on your computer, follow these instructions to install Rails:

* [Install Rails on Linux][mydoc_install_rails_on_linux]
* [Install Rails on Mac][mydoc_install_rails_on_mac]
* [Install Rails on Windows][mydoc_install_rails_on_windows]

### 2. Install Bundler

In case you haven't installed Bundler, install it:

```
gem install bundler
```

You'll want [Bundler](http://bundler.io/) to make sure all the Ruby gems needed work well with your project. Bundler sorts out dependencies and installs missing gems or matches up gems with the right versions based on gem dependencies.

### 3. Option 1: Build the Theme (*without* the github-pages gem) {#option1}


## Running the site in Docker

You can also use Docker to directly build and run the site on your local machine. Just clone the repo and run the following from your working dir:
```
docker-compose build --no-cache && docker-compose up
```
The site should now be running at [http://localhost:4000/](http://localhost:4000/).

This is perhaps the easiest way to see how your site would actually look.

## Configure the application

## Other instructions

The content here is just a getting started guide only. For other details in working with the theme, see the various sections in the sidebar.

{% include links.html %}
