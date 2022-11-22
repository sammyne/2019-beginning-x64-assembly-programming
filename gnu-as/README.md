# GNU-AS

Rewrite nasm-based examples in GNU AS syntax.

# Head Ups
- Missing header `.intel_syntax noprefix` will trigger sample error as `Error: too many memory references for 'mov'`.
- `objdump -M intel -d {an-executable-built-from-c-src}` can help us figure out the GAS grammer

## References
- [GNU Assembler Examples](https://cs.lmu.edu/~ray/notes/gasexamples/)
- [Using as](http://sourceware.org/binutils/docs/as/index.html)
