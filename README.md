Dominiate
=========

Dominiate is a Dominion simulator, in which you can program bots to follow
strategies that you define and see which one wins.

It is inspired by Geronimoo's Dominion Simulator. It shares the feature that,
to define many possible strategies, you may simply list cards and conditions in
which to buy them in priority order.

The code is meant to be open and extensible. Many other aspects of a strategy
can be overridden, including its preferences for how to play actions. If this
system doesn't allow you to define the strategy you want and you're okay with
writing more code, I encourage you to fork the simulator and change it so that
it does.

Dominiate is written in CoffeeScript, which compiles to JavaScript. This means
it can either run at the command line using node.js, or it can run natively
in a Web browser!

Documentation
-------------
The `docs` directory contains documentation in the "literate programming" style
-- that is, it shows you the code in parallel with explanations of what it
does.

Installation
------------

Dominiate runs [in your web browser](http://rspeer.github.com/dominiate/play.html)
You do not need to install anything to use it.  Follow these instructions if
you wish to modify the Dominiate code.

### UNIX

Download and install node.js from [nodejs.org](http://nodejs.org)

Install npm from [npmjs.org/](http://npmjs.org/)

    curl http://npmjs.org/install.sh | sh

In the Dominiate project directory, install Dominiate's dependencies

    npm install

Update your PATH environment variable so it can find the installed scripts

    export PATH=./node_modules/bin:$PATH

Update your shell login script to set this every time you open a shell

    echo "export PATH=./node_modules/bin:$PATH" >> ~/.profile

Run `make` to build the web app.  Open "web/play.html" in a browser to view
the web app.

You may also run Dominiate in a terminal by running `./play.coffee`, and
specifying the desired strategies on the command line

    ./play.coffee strategies/BigMoney.coffee strategies/ChapelWitch.coffee

### Windows

You can now compile the CoffeeScript files on Windows, using an
included CoffeeScript compiler, `windows/coffee.exe`. (Being an .exe file
downloaded from the Internet, you of course run this at your own risk.)

Running `windows/compile.bat` should do the Right Thing, but I haven't tested
it. See `windows/README` for more information.

Roadmap
-------
Short-term planned features include:

- Implement almost all the cards
- Don't buy cards that make you instantly lose
- Test cases, making sure the simulator keeps working in weird situations

Some specific features I hope for Dominiate to eventually have appear tagged
with "feature" on the Issues list.
