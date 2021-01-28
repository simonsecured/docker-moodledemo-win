# docker-moodledemo-win
A Docker configuration aimed at easily running a copy of Moodle 3.9 to demonstrate from a Windows 10 machine.

The Moodle instance can also be made accessible over the Internet for demo using NGROK.

# Windows Prerequisites

- [Docker](https://docs.docker.com) and [Docker Compose](https://docs.docker.com/compose/)
- Git command line tools [Git](https://git-scm.com/download/win)
- NGROK [https://ngrok.com/download](https://ngrok.com/download) - ensure a copy of NGROK.EXE is in this folder, or it can be run from command line

# Changing the MOODLE Version if desired

The default configuration uses the version of Moodle in the MOODLE_39_STABLE branch.

This is configured as a value in[bin/start_moodle.cmd](bin/start_moodle.cmd) simply change this to one of the supported [MOODLE 3.x Branches](https://github.com/moodle/moodle)

# Starting and Stopping Moodle

Open a Windows terminal prompt in this folder.

## Start and Setup a Moodle Instance - RUN ONCE

At a Windows terminal prompt run:

```
c:\docker-moodledemo-win>bin\start_moodle.cmd setup
```

This will clone a copy of MOODLE_39_STABLE, and bring up the Docker containers and run the MOODLE CLI Install process.

## Start the Moodle Instance

**IMPORTANT: Setup step needs to have been completed**

At a Windows terminal prompt run:

```
c:\docker-moodledemo-win>bin\start_moodle.cmd
```

This will perform a GIT RESET of MOODLE_39_STABLE, and bring up the Docker containers.

## Start the Moodle Instance and make internet accessible using NGROK

**IMPORTANT: Setup step needs to have been completed**

At a Windows terminal prompt run:

```
c:\docker-moodledemo-win>bin\start_moodle.cmd ngrok
```

This will perform a GIT RESET of MOODLE_39_STABLE, start NGROK.EXE, capture the NGROK HTTPS host and bring up the Docker containers.

## Stop the Moodle Instance

At a Windows terminal prompt run:

```
c:\docker-moodledemo-win>bin\stop_moodle.cmd
```

This will bring down the Docker containers.

## Running Moodle CRON CLI

**IMPORTANT: Setup step needs to have been completed, and Moodle is started**

At a Windows terminal prompt run:

```
c:\docker-moodledemo-win>bin\start_cron_cli.cmd
```

## Running Other Moodle CLI

**IMPORTANT: Setup step needs to have been completed, and Moodle is started**

If referencing any files when running the CLI these need to have been copied to a location the PHP script can access in the Docker Container.

The quickest way is to copy them to the Moodle Web Root folder this is located in:

```
volumes\moodle\MOODLE_39_STABLE\
```

If you changed the MOODLE Branch adjust the above accordingly.

At a Windows terminal prompt run:

```
c:\docker-moodledemo-win>bin\moodle-docker-compose exec webserver php CLISCRIPT
```

So for example to run the course upload CLI using the [examplefiles/courses.csv](examplefiles/courses.csv).

Step 1 - Copy the file to the Moodle root web folder so Moodle CLI can access it

```
c:\docker-moodledemo-win>copy examplefiles\courses.csv volumes\moodle\MOODLE_39_STABLE\*
```

Step 2 - Run the CLI remembering to use the relative physical path references to the root.

**The command line below is one line, but may have been word wrapped when you view this.**

```
c:\docker-moodledemo-win>bin\moodle-docker-compose exec webserver php admin/tool/uploadcourse/cli/uploadcourse.php --mode=createnew --updatemode=dataonly --file=../../../../courses.csv --delimiter=comma
```

## License

MIT © Martin Holden
