<div align="center">
  <br />
  <p>
    <a href="https://github.com/cogmasters/creddit.git"><img src="https://raw.githubusercontent.com/Cogmasters/creddit-docs/master/docs/source/images/logo.svg" width="536" alt="Creddit" style="background-color:red;" /></a>
  </p>
  <br />
  <p>
    <br> <a href="https://discord.gg/Y7Xa6MA82v"><img src="https://img.shields.io/discord/928763123362578552?color=5865F2&logo=discord&logoColor=white" alt="Discord server" /></a> </br>
  </p>
</div>

## About

Creddit is implemented in plain C99, its symbols are organized to be easily matched to the documentation of the API being covered.
Creddit's implementation has minimum external dependencies to make bot deployment deadly simple.
Creddit is pronounced "credit."

### On Windows

* Install **Cygwin**
* **Make sure that you installed libcurl, gcc, make, and git when you ran the Cygwin installer!**

### On Linux

The only dependency is `curl-7.4.1` or higher

#### Ubuntu and Debian

```bash
sudo apt install -y build-essential libcurl4-openssl-dev
```

#### Void Linux

```bash
sudo xbps-install -S libcurl-devel
```

#### Alpine

```bash
sudo apk add curl-dev
```
### Setting up your environment

#### Clone Creddit into your workspace

```bash
$ git clone https://github.com/cogmasters/creddit.git && cd creddit
```

#### Compile Creddit 

```bash
$ make
```

## Installing Creddit

Included headers must be `creddit/` prefixed:
```c
#include <creddit/discord.h>
```

### Standalone executable

#### GCC (Recommended)

```bash
$ gcc myBot.c -o myBot -pthread -lreddit -lcurl
```

#### Clang

```bash
$ clang myBot.c -o myBot -pthread -lreddit -lcurl
```

#### System V UNIX C compiler (not recommended at all)
```bash
$ cc -o myBot myBot.c -L/usr/local/lib -I/usr/local/include -ldiscord -lcurl
```

## Recommended debuggers

First, make sure your executable is compiled with the `-g` flag to ensure human-readable debugger messages.

### Valgrind

Using valgrind to check for memory leaks:

```bash
valgrind --leak-check=full ./myBot
```
For a more comprehensive guide check [Valgrind's Quick Start](https://valgrind.org/docs/manual/quick-start.html).

### GDB

Using GDB to check for runtime errors, such as segmentation faults:

```bash
$ gdb ./myBot
```
And then execute your bot from the gdb environment:
```bash
(gdb) run
```
If the program has crashed, get a backtrace of the function calls leading to it:
```bash
(gdb) bt
```

For a more comprehensive guide check [Beej's Quick Guide to GDB](https://beej.us/guide/bggdb/)

## Support

Problems? Check out our [Discord Server](https://discord.gg/Y7Xa6MA82v).

## Contributing

All kinds of contributions are welcome, all we ask is to abide to our [guidelines](docs/CONTRIBUTING.md)! If you want to help but is unsure where to get started then our [Reddit API Roadmap](docs/REDDIT_ROADMAP.md) is a good starting point. Check our [links](#links) for more helpful information.

**Give us a star if you like this project!**
