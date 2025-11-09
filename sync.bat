REM -- file copy from obsidian --
robocopy ..\obsidian-bingfam\ content\ /xd .obsidian .git template private /mir

REM -- upload to github pages --
npx quartz sync