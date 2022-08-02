# Blueberry

Blueberry is a bot made for moderating smaller-scale servers while having a fast response at all times (thanks to LuaJIT).
It was made using NxEngine(2)'s environment idea for a better overall coding experience.
## Requirements
The requirements are simple;

### Running the lua code:
- [Luvit](https://luvit.io/)
- Optional but recommended: [pm2](https://pm2.keymetrics.io/)

### Running the bot:
- Discordia - `lit install SinisterRectus/discordia`
## Running the bot
Before running your bot, you'll simply need to change a few details in the start.lua
file from the repository, as well as add your own token, changing the ownerID, etc.

Make sure that everything works and you set the ownerID as **yourself** and **yourself only**, since allowing
a different person to use eval can be dangerous for your server/pc.

If you installed Luvit without pm2, you can run the bot by doing the following
command in your terminal/command prompt/powershell/whatever;

```bash
luvit start.lua
```
---
If you installed both Luvit and pm2, you can run the bot and save the process so
it can be ran in the background, without having the terminal open at all times;

```bash
pm2 start start.lua --interpreter=luvit
```
## Contributing to Blueberry

Contributions are always welcome, and even credited in the main bot!
I would definitely like some improvements for what I am doing, while keeping the
current code clean and adding more commands to it.

Simply open an issue/pull request, and I'll get right to it!