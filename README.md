Date: 2013 06 30

DDTAF = Data Driven Test Automation Framework
============================================
The original idea for this came from a paper written by Dupire & Fernandez,
The Command Dispatcher Pattern, and from a talk on test automation by 
Linda Hayes, STARWEST 2006.  The talk had one main component which was 
to a 'table-driven' approach.  There were not enough details though to 
really build a framework.

By combining the two sources above it was possible to build a test framework
which took as in input a 'table', (csv), and then execute via handlers.

All logic for the flow, error handling, retries, recovery, etc were isolated
to the framework.  This had the effect of dividing up the work into three
very well compartamentalized areas.

 * All the 'tests' were written in csv 'tables' by the test domain expert users
 * The framework was maintained by a small engineerig group which needed
no knowledge of the 'test' contents.  Work was directed at the flow of commands.
 * Handlers, were implemented by both testers, feature engineers or test
framework engineers.  Given how well isolated they were they could be 
'plugged in' and modified separately.  These handlers covered everything from
    * Command line level calls
    * GUI automation calls
    * XML conversion
    * HTML generation for reporting

This archive preserves to bareboned uses of the pattern, one in AutoIT and one
in C#. A third new version in ruby is getting fleshed out.


DDTAF reconstruction in Ruby.
=============================

Reconstruction from memories of python framework
------------------------------------------------
I revisited original pdf.  There were saved samples of the windows AutoIT and
the C# version.  The AutoIT got some use, but the C# never did get much further.

The original DDTAF was in Python, but I could no longer get the source code.

The bin directory contains the main driver for the code.  Everything else is 
in the lib directory.

ddtaf: main responsibilty, iterate over the chain of commands
-------------------------------------------------------------
This file is calls to load the chain and dispatcher objects.  It's main
responsibility is to iterate of a chain of commands and to handle the flow 
when a test fails or passes.  All logic to move along, inject other commands,
terminate, or repeate any link in the chain is handled here.

chain: Create chain from file/stream, define functions to splice, remove items
------------------------------------------------------------------------------
This module holds the chain of commands.  Functions should allow it to load
from a csv or any other text/stream input.  It will then return via another
function, a linked chain of command objects.

command: container, holds all data related to a 'job' or command.
-----------------------------------------------------------------
This is a container.  Originally holding all data needed to execute a job.
It can also hold current status, history.  It does not execute any action
by itself, it is simply metadata.

dispatcher: Takes metadata from command, and calls handler to execute
---------------------------------------------------------------------
This object keeps a list of 'registered' commands in a hash.  It's 
main responsibilty is to track what handlers respond on what command keys.
It also keeps track of which handlers are 'registered'.  This can probably
be done via one of it's own functions so that it can be dynamicaly reloaded
without having to reboot the app.

handler: These take a command and 'unwrap' it's metadata to execute an action.
------------------------------------------------------------------------------
These can be varied, the only commonality between all handlers is that they 
should take a command as an argument.  Unpack it's metadata, execute an action
and return pass/fail, (true/false).  There should be NO control logic here,
all of that should be relegated to the ddtaf file.

