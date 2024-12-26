# Better Shutdown  

Open Source Windows desktop app made for easier use of [shutdown command](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/shutdown)

## Features:
- Schedule:
  - Shutdown
  - Restart
  - Hibernate
  - Logout
- Schedule modes:
  - Force (default by system)
  - Soft (requires app to constantly run)
- Schedule shutdown with:
  - Seconds
  - Minutes
  - Hours
  - Days
  - Date
- Abort existing scheduled shutdown
- Projected date when would your PC shutdown with current given values
- Information about already scheduled shutdown
  - Date when will PC shutdown
  - How many seconds till shutdown
- Checking if there is already scheduled shutdown at the start of app
- Logs with information about what is currently happening
  - Filter by user input, info and error logs
  - Clear logs
  - Input for basic commands (like in cmd)
- Dark/Light Theme

## Known issues:
- Can't cancel soft shutdown using abort btn or in the confirmation dialog (you can stop it by closing the app though)
- Soft shutdown might still have some issues as I just made a quick fix

## Planned:
- Better time format than only seconds (information about how long till shutdown)
- Minimize (hide) app 
- Huge code clean-up
- Optimization

and more
