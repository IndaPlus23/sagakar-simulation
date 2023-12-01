# Conway's game of life (in Common Lisp)
## Running
### To install the prerequisites
1. Install the SBCL Lisp compiler
2. Install the quicklisp package manager
3. Open the SBCL REPL with the command `sbcl`
4. Configure quicklisp to run at SBCL startup by executing `(ql:add-to-init-file)` in the REPL
5. Install the sketch graphics library by executing `(ql:quickload "sketch")` in the REPL
### To run the program
1. Open the SBCL REPL in the directory of the lisp source file
2. Run `(ql:quickload "sketch")` to load the sketch library (this will not reinstall the library after being run the first time)
3. Run `(load "life.lisp")` to load the source file
4. Run `(life:main)` to execute the main function