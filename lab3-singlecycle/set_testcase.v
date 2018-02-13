/* LC4 Datapath Test Configuration
 * Benedict Brown
 * February 2015
 */

`define CODE_PATH "test_data/"
  
/* Define the full paths to the trace, output, and hex files.
 * INPUT_FILE and OUTPUT_FILE are used by the testbench,
 * MEMORY_IMAGE_FILE is used by bram.v.
 */
`define INPUT_FILE        { `CODE_PATH, `TEST_CASE, ".trace"  }
`define OUTPUT_FILE       { `CODE_PATH, `TEST_CASE, ".output" }
`define MEMORY_IMAGE_FILE { `CODE_PATH, `TEST_CASE, ".hex"    }
