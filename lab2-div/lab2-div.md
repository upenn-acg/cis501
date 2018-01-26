In this lab, you'll create a key component of the processor: the ALU
for the [LC4
ISA](http://cis.upenn.edu/~cis371/current/lc4.html).

LC4 contains the `DIV` (divide) and `MOD` (modulo) instructions. To
complete the ALU that you will use in your single-cycle processor, the
first step is to create the logic for a single-cycle `DIV`/`MOD`
calculation. This is the same calculation as the multi-cycle `DIV`/`MOD`
given below, but done in a single cycle using combinational logic
only.

## Division Algorithm (Software)

The module takes as input two 16-bit data values (dividend and
divisor) and outputs two 16-bit values (remainder and quotient). It
should use the following algorithm:

```c
int divide(int dividend, int divisor) {
    int quotient = 0;
    int remainder = 0;

    if (divisor == 0) {
        return 0;
    }

    for (int i = 0; i < 16; i++) {
        remainder = (remainder << 1) | ((dividend >> 15) & 0x1);
        if (remainder < divisor) {
            quotient = (quotient << 1) | 0x0;
        } else {
            quotient = (quotient << 1) | 0x1;
            remainder = remainder - divisor;
        }

        dividend = dividend << 1;
    }

    return quotient;
}
```

## Writing your code

Begin with the `lc4_divider_one_iter` module that does one "iteration"
of the division operation. You can then instantiate 16 copies of this
module to form the full divider. Think about how each output value is
computed from the inputs.

## Tests

The testbench for the DIV/MOD unit is in
`testbench_lc4_divider.v`. You can run all of the tests via the
Makefile with the command `make test`.

## Submitting your code

As with previous labs, submit your code via Canvas.

## ZedBoard demo

TBD
