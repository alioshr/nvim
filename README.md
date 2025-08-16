# TODOS

## File management
- Add yazi for file management

## Clibboard management
- use the void black hole to delete without polluting the clipboard

## Run tests
- Ditch neotest 
- Add a mapping to run 
    - vitest 
    - jest 
    - craco 


### Plan: 
- Factory function that receives a path with prefix and suffix ({ path, suffix, prefix }) => `${prefix} ${path} ${suffix}`
- Factory function that creates tmux window names. It will combine the predefined name + a suffix that is the file name being tested: 
  ({windowName, fileName}) =>  `${windowName} ${fileName}`

- have a singleton with the different strategies
{
  vitest: {
     prefix: "npx vitest",
     suffix: "--watch",
     windowName: "Vitest"
  jest: {
     prefix: "npx jest," 
     suffix: "--watch,"
     windowName: "Jest"
     }
  craco: {
    prefix: "npx craco test", 
    suffix: "--watch",
    windowName: "Craco
"    }
} 


- This will result in three methods that expect a path, each: 
     - runJestTest(path)
     - runVitestTest(path)
     - runCracoTest(path)


### Expected workflow:

- Run our command to open a tmux floating terminal on the predefined session
- Create a new window predefined by testing strategy. Ensure that if such window already exists that it can still be used
- Open the new window and then execute the command
