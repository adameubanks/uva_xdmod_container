![UVA Research Computing](https://www.rc.virginia.edu/images/logos/uvarc-knockout-logo-6-2022.png)

# XDMoD Container for UVA Research Computing

This repository contains a Docker setup for an XDMoD (eXtreme Digital Metrics on Demand) container, specifically tailored for UVA research computing. This setup allows for easy deployment and testing of XDMoD in a containerized environment.

## Quick Start

To get the XDMoD container up and running, follow these steps:

1. Start the XDMoD database:
   ```bash
   docker compose up --build xdmod_db
   ```

2. Once the database is initialized, start the XDMoD service:
   ```bash
   docker compose up --build xdmod_service
   ```

These commands will start XDMoD and run all the necessary initialization scripts.

## Configuration

### Environment Variables

All configuration settings are stored in the `.env` file. This file contains environment variables that control various aspects of the XDMoD setup, including database connections. If you need to modify any settings or connect to a different database, edit this file before starting the containers.

### Automated Setup

The `setup-xdmod.expect` script automates the XDMoD setup process. It uses the values defined in the `.env` file to configure XDMoD without manual intervention. This script streamlines the initialization process, making it easier to deploy and test XDMoD in different environments. Think of it as a script that fills in the setup specifications for XDMoD just like a human would.

### Support

Should you encounter any problems setting up the container, please create a new issue or contact the UVA RC team.