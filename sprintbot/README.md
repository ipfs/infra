# Sprint bots

On [sprinbot.i.ipfs.io](), several things live.

All of the three things there use `forever` to run. `forever start x.js` or `forever restartall` are the most common commands to know.

### [sprint-helper](https://github.com/ipfs/sprint-helper)

This is the IRC sprintbot that is used to announce our sprints. It is run by using `node-cron` and `forever`. The entry point is `irc.js`.

### [node-github-issue-bot](https://github.com/ipfs/node-github-issue-bot)

This is a GitHub bot (using @RichardLitt's credentials) that opens issues automatically in ipfs/pm every week. It uses `node-cron` and `forever`. Command: `cron.js`.
